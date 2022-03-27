import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_checkin/ui/views/event_attendees_view.dart';
import 'package:event_checkin/ui/views/event_details_view.dart';
import 'package:event_checkin/ui/views/scan_code_view.dart';
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
        title: Text(
          widget.event.get('name').toString().toUpperCase(),
        ),
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
            EventDetailsView(eventID: widget.event.id),
            EventAttendeesView(eventID: widget.event.id),
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
              builder: (context) => ScanCodeView(
                eventID: widget.event.id,
              ),
            ),
          );
        },
        child: const Icon(
          Icons.qr_code_2_rounded,
        ),
      ),
    );
  }
}
