import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_checkin/ui/components/edit_event_form.dart';
import 'package:flutter/material.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key}) : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  Future<void> submitForm(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection('events').add(data);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un événement'),
      ),
      body: Center(
        child: EditEventForm(
          initialValues: const {},
          onSubmitFormCallback: submitForm,
        ),
      ),
    );
  }
}
