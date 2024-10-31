import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class DateSelect extends StatefulWidget {
  const DateSelect({super.key, required this.onDateSelected});

  final Function(DateTime) onDateSelected;

  @override
  State<DateSelect> createState() => _DateSelectState();
}

class _DateSelectState extends State<DateSelect> {
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _dateController,
      decoration: InputDecoration(
        labelText: 'Date',
        labelStyle:
        customTextStyle(color: Colors.grey),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintText: 'choose Date',
        hintStyle: customTextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.green.withOpacity(0.1),
        suffixIcon: const Icon(Icons.calendar_month_rounded),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.green,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.green,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Registration Date cannot is required.';
        }
        return null;
      },
      readOnly: true,
      onTap: () {
        _selectDate(context);
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
        // _dateController.text = picked.toString().split(' ')[0];
        widget.onDateSelected(picked);
      });
    }
  }
}


