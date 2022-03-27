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
                event!.get('dateDebut').toDate().toString(),
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
              SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: event!.get('participants')!.length,
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> participant =
                        event!.get('participants')![index];
                    // print(participant.data());
                    return Card(
                      child: ListTile(
                        title: Text(
                            "${participant['firstName'].toString()} ${participant['lastName'].toString()}"),
                        subtitle: Text(participant['email'].toString()),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }
}
