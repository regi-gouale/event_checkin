import 'package:flutter/material.dart';

class EventParticipantsView extends StatefulWidget {
  const EventParticipantsView({Key? key, required this.eventID})
      : super(key: key);

  final String eventID;

  @override
  State<EventParticipantsView> createState() => _EventParticipantsViewState();
}

class _EventParticipantsViewState extends State<EventParticipantsView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
