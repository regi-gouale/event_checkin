import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_checkin/utils/utils_functions.dart';
import 'package:flutter/material.dart';

class EventAttendeesView extends StatefulWidget {
  const EventAttendeesView({
    Key? key,
    required this.eventID,
  }) : super(key: key);

  final String eventID;

  @override
  State<EventAttendeesView> createState() => _EventAttendeesViewState();
}

class _EventAttendeesViewState extends State<EventAttendeesView> {
  DocumentSnapshot? event;

  @override
  void initState() {
    super.initState();
    getFirestoreDocumentData(
      collection: 'events',
      documentID: widget.eventID,
    ).then((value) {
      setState(() {
        event = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Liste des participants",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("events")
                  .doc(widget.eventID)
                  .collection("attendees")
                  .snapshots(),
              builder: (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.purple,
                    ),
                  );
                }
                if (snapshot.hasError){
                  return Center(
                    child: Text(
                      'Erreur: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text("Pas de participants"),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> attendee = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    return Card(
                      child: ListTile(
                        title: Text(
                          "${attendee['firstname']} ${attendee['lastname']}".toUpperCase()),
                        subtitle: Text(
                         attendee['email'].toString().toLowerCase(),
                        ),
                      ),
                    );
                  },
                );
              }),
        ),
      ],
    );
  }
}
