import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_checkin/ui/screens/add_event_screen.dart';
import 'package:event_checkin/utils/event_checkin_colors.dart';
import 'package:flutter/material.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({
    Key? key,
    required this.event,
  }) : super(key: key);
  final DocumentSnapshot event;

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentPage,
      // keepPage: true,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.get('type').toString().toUpperCase()),
      ),
      body: Center(
        child: PageView(
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          controller: _pageController,
          children: <Widget>[
            _buildEventDetails(context),
            _buildEventParticipants(context),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (index) {
          setState(() {
            _currentPage = index;
          });
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_rounded),
            label: 'Evenement',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_rounded),
            label: 'Participants',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEventScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _buildEventDetails(BuildContext context) {
    return Container(
      color: EventCheckinColors.primary,
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text(widget.event.get('name')),
                  subtitle: Text(widget.event.get('type')),
                  trailing: Text(widget.event.get('dateDebut').toDate().toString()),
                ),
                ListTile(
                  title: const Text('Description'),
                  subtitle: Text(widget.event.get('description')),
                ),
                ListTile(
                  title: const Text('Lieu'),
                  subtitle: Text(widget.event.get('lieu')),
                ),
                ListTile(
                  title: const Text('Nombre de places'),
                  subtitle: Text(widget.event.get('nbPlaces').toString()),
                ),
                ListTile(
                  title: const Text('Nombre de participants'),
                  subtitle: Text(widget.event.get('nbParticipants').toString()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildEventParticipants(BuildContext context) {
    return Container(
      color: EventCheckinColors.primary,
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                const ListTile(
                  title: Text('Participants'),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('event')
                      .doc(widget.event.id)
                      .collection('participants')
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot document = snapshot.data!.docs[index];
                        return ListTile(
                          title: Text(document.get('name')),
                          subtitle: Text(document.get('email')),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
