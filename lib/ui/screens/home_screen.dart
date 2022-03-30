import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_checkin/ui/screens/add_event_screen.dart';
import 'package:event_checkin/ui/screens/add_person_screen.dart';
import 'package:event_checkin/ui/screens/event_screen.dart';
import 'package:event_checkin/ui/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        title: const Text('ICC Lyon Event Check-In'),
        leading: IconButton(
          icon: const Icon(Icons.person_add),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddPersonScreen(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false);
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: Material(
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
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.yellow,
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
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot document = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Text(
                        document.get('name'),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(document.get('type')),
                      trailing: Text(
                        DateFormat('dd-MM-yyyy HH:mm').format(
                          document.get('startTime').toDate(),
                        ),
                      ),
                      selectedTileColor: Colors.redAccent,
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
