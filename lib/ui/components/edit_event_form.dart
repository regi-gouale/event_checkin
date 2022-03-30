import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'calendar_picker.dart';

class EditEventForm extends StatefulWidget {
  const EditEventForm({
    Key? key,
    required this.onSubmitFormCallback,
    required this.initialValues,
  }) : super(key: key);

  final void Function(Map<String, dynamic>) onSubmitFormCallback;
  final Map<String, dynamic> initialValues;

  @override
  State<EditEventForm> createState() => _EditEventFormState();
}

class _EditEventFormState extends State<EditEventForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _nbAttendeesController = TextEditingController();

  String _eventType = 'Culte';

  @override
  void initState() {
    if (widget.initialValues.isNotEmpty) {
      _nameController.text = widget.initialValues['name'];
      _typeController.text = widget.initialValues['type'];
      _descriptionController.text = widget.initialValues['description'];
      _startTimeController.text = DateFormat(CalendarPicker.timeFormat)
          .format(widget.initialValues['startTime']);
      _endTimeController.text = DateFormat(CalendarPicker.timeFormat)
          .format(widget.initialValues['endTime']);
      _locationController.text = widget.initialValues['location'];
      _nbAttendeesController.text = widget.initialValues['nbAttendees'];
    }

    super.initState();
  }

  Future<void> _submitForm() async {
    _formKey.currentState!;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final Map<String, dynamic> data = {
        'name': _nameController.text.trim(),
        'type': _typeController.text.trim(),
        'description': _descriptionController.text.trim(),
        'startTime': CalendarPicker.stringToDate(_startTimeController.text),
        'endTime': CalendarPicker.stringToDate(_endTimeController.text),
        'location': _locationController.text.trim(),
        'nbAttendees': int.parse(_nbAttendeesController.text),
      };
      widget.onSubmitFormCallback(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nom de l\'événement',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.event),
            ),
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Veuillez entrer le nom de l\'événement';
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
            value: _eventType,
            decoration: const InputDecoration(
              labelText: 'Type d\'événement',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.event_available),
            ),
            items: <String>[
              'Culte',
              'Atmosphère De Gloire',
              'Mariage',
              'Conférence',
              'Séminaire',
              'Atelier',
              'Réunion',
              'Autre',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                _eventType = value!;
                _typeController.text = value;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description de l\'événement',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description),
            ),
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Veuillez décrire l\'événement';
              }
              return null;
            },
            maxLines: 5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CalendarPicker(controller: _startTimeController),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CalendarPicker(
            controller: _endTimeController,
            dateLabel: "Heure de fin",
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Lieu',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_on),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: _nbAttendeesController,
            decoration: const InputDecoration(
              labelText: 'Nombre de participants',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.people),
            ),
            validator: (String? value) {
              if (int.tryParse(value!) == null || int.tryParse(value)! <= 0) {
                return 'Veuillez entrer un nombre de participants. Doit être un nombre entier positif';
              }
              return null;
            },
            onSaved: (String? value) {
              if (int.tryParse(value!) != null) {
                _nbAttendeesController.text = value.toString();
              }
            },
          ),
        ),
        ElevatedButton(
          child: const Text('Enregistrer'),
          onPressed: _submitForm,
        ),
      ],
    );
  }
}
