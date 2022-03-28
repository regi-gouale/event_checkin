import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarPicker extends StatefulWidget {
  const CalendarPicker({Key? key, required this.controller}) : super(key: key);

  final TextEditingController controller;
  static String timeFormat = "EEEE, d MMMM, yyyy 'at' h:mm";

  static DateTime? stringToDate(String dateString) {
    try {
      return DateFormat(CalendarPicker.timeFormat).parseStrict(dateString);
    } catch (e) {
      return null;
    }
  }

  static TimeOfDay? stringToTime(String timeString) {
    try {
      return TimeOfDay.fromDateTime(
          DateFormat(CalendarPicker.timeFormat).parseStrict(timeString));
    } catch (e) {
      return null;
    }
  }

  @override
  State<CalendarPicker> createState() => _CalendarPickerState();
}

class _CalendarPickerState extends State<CalendarPicker> {
  

  Future<void> dateTimePicker() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        final DateTime dateTime =
            DateTime(date.year, date.month, date.day, time.hour, time.minute);
        setState(() {
          widget.controller.text = DateFormat(CalendarPicker.timeFormat).format(dateTime);
        });
      }
    }
  }

  

  bool datValidator(String date) {
    return CalendarPicker.stringToDate(date) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
              labelText: 'Date et Heure',
              border: const OutlineInputBorder(),
              prefixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: dateTimePicker,
              ),
            ),
            keyboardType: TextInputType.datetime,
            validator: (value) =>
                datValidator(value!) ? null : 'Veuillez entrer une date valide',
          ),
        ),
        IconButton(
          onPressed: () => dateTimePicker(),
          icon: const Icon(Icons.more_horiz_rounded),
          tooltip: "Choisir une date",
        )
      ],
    );
  }
}
