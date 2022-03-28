import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_checkin/utils/utils_functions.dart';
import 'package:flutter/material.dart';

class EventDetailsView extends StatefulWidget {
  const EventDetailsView({
    Key? key,
    required this.eventID,
  }) : super(key: key);
  final String eventID;

  @override
  State<EventDetailsView> createState() => _EventDetailsViewState();
}

class _EventDetailsViewState extends State<EventDetailsView> {
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
    return event == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  event!.get('name').toString().toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                event!.get('startTime').toDate().toString(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  event!.get('description').toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              StreamBuilder(
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
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erreur: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return Center(
                      child: Column(
                        children: const [
                          Icon(
                            Icons.beach_access_rounded,
                            size: 64,
                          ),
                          Text("Pas de participants"),
                        ],
                      ),
                    );
                  }
                  return Center(
                    child: Text(
                      '${snapshot.data!.docs.length} participant${snapshot.data!.docs.length > 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  );
                },
                stream: FirebaseFirestore.instance
                    .collection("events")
                    .doc(widget.eventID)
                    .collection("attendees")
                    .snapshots(),
              ),
            ],
          );
  }
}
