import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_checkin/ui/components/calendar_picker.dart';
import 'package:event_checkin/ui/components/text_field_form_component.dart';
import 'package:validators/validators.dart';
import 'package:flutter/material.dart';

class AddPersonScreen extends StatefulWidget {
  const AddPersonScreen({Key? key}) : super(key: key);

  @override
  State<AddPersonScreen> createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends State<AddPersonScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  String _genderString = 'Homme';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un membre'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: _buildForm(),
            ),
          ),
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
          child: buildTextFormField(
            controller: _firstnameController,
            labelText: 'Prénom',
            prefixIcon: const Icon(Icons.person),
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Veuillez entrer un prénom';
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: buildTextFormField(
            controller: _lastnameController,
            labelText: 'Nom',
            prefixIcon: const Icon(Icons.person),
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Veuillez entrer un nom';
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: buildTextFormField(
            controller: _emailController,
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email),
            validator: (String? value) =>
                !isEmail(value!) ? 'Veuillez entrer un email valide' : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: buildTextFormField(
            controller: _phoneController,
            labelText: 'Téléphone',
            prefixIcon: const Icon(Icons.phone),
            validator: (String? value) => !isNumeric(value!)
                ? 'Veuillez entrer un numéro de téléphone valide'
                : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: buildTextFormField(
            controller: _addressController,
            labelText: 'Adresse',
            prefixIcon: const Icon(Icons.place),
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Veuillez entrer une adresse';
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildBirthdayField(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildGenderField(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildSubmitButton(),
        ),
      ],
    );
  }

  Widget _buildBirthdayField() {
    return CalendarPicker(
      controller: _birthdayController,
      dateLabel: "Date de naissance",
      startDateCount: 100,
      endDateCount: 1,
    );
  }

  Widget _buildGenderField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio(
          value: 'Homme',
          groupValue: _genderString,
          onChanged: (String? value) {
            setState(() {
              _genderString = value!;
              _genderController.text = value;
            });
          },
        ),
        const Text('Homme'),
        Radio(
          value: 'Femme',
          groupValue: _genderString,
          onChanged: (String? value) {
            setState(() {
              _genderString = value!;
              _genderController.text = value;
            });
          },
        ),
        const Text('Femme'),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      child: const Text('Ajouter'),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          final Map<String, dynamic> data = {
            'firstname': _firstnameController.text,
            'lastname': _lastnameController.text,
            'email': _emailController.text,
            'phone': _phoneController.text,
            'address': _addressController.text,
            'birthday': _birthdayController.text,
          };
          await FirebaseFirestore.instance.collection('members').add(data);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Membre ajouté')),
          );
          Navigator.pop(context);
        }
      },
    );
  }
}
