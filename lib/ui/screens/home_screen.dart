import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_checkin/ui/screens/add_event_screen.dart';
import 'package:event_checkin/ui/screens/event_screen.dart';
import 'package:event_checkin/utils/event_checkin_colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void addEvent() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddEventScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: addEvent,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Event Check-In'),
      ),
      body: Material(
        color: EventCheckinColors.primary,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('events')
              .orderBy("startTime")
              .where(
                "startTime",
                isGreaterThan: DateTime.now().add(
                  const Duration(hours: -3),
                ),
              )
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot document = snapshot.data!.docs[index];
                return Card(
                  child: ListTile(
                    title: Text(document.get('name')),
                    subtitle: Text(document.get('type')),
                    trailing:
                        Text(document.get('startTime').toDate().toString()),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return EventScreen(
                              event: document,
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
