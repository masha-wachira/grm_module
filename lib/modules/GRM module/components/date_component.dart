import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:kgs_mobile_v2/main.dart';
import 'package:kgs_mobile_v2/theme/colors.dart';

class DateSelect extends StatefulWidget {
   DateSelect({
    super.key,
    required this.onDateSelected,
    this.initialValue,
     this.dateController
  });

  final Function(DateTime) onDateSelected;
  String? initialValue;
  TextEditingController? dateController = TextEditingController();

  @override
  State<DateSelect> createState() => _DateSelectState();
}

class _DateSelectState extends State<DateSelect> {


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.dateController,
      // initialValue: widget.initialValue,
      decoration: InputDecoration(
        labelStyle:
        customTextStyle(color: Colors.grey),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintStyle: customTextStyle(color: Colors.grey),
        filled: true,
        fillColor: funGreen.withOpacity(0.1),
        suffixIcon: const Icon(Icons.calendar_month_rounded),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: funGreen,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: funGreen,
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
        widget.dateController?.text = DateFormat('yyyy-MM-dd').format(picked);
        // _dateController.text = picked.toString().split(' ')[0];
        widget.onDateSelected(picked);
      });
    }
  }
}


