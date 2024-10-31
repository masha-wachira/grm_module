import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:kgs_mobile_v2/theme/colors.dart';
import 'package:sqflite/sqflite.dart';
import 'package:kgs_mobile_v2/db/kgs_db.dart';

class DropdownTextField extends StatefulWidget {
  DropdownTextField(
      {required this.dropDownItems,
        required this.onChanged,
        this.asyncItems,
        this.validator,
        this.initialValue,
        super.key});

  List dropDownItems=[];
  final void Function(dynamic)? onChanged;
  Future<List<dynamic>> Function(String)? asyncItems;
  String? Function(dynamic)? validator;
  String? initialValue;

  @override
  State<DropdownTextField> createState() => _DropdownTextFieldState();
}

class _DropdownTextFieldState extends State<DropdownTextField> {
  final String primaryFont = 'Poppins';
  @override
  Widget build(BuildContext context) {
    return DropdownSearch(
      validator: widget.validator,
        asyncItems: widget.asyncItems,
        items: widget.dropDownItems,
        selectedItem: widget.initialValue,
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: funGreen),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: funGreen),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: funGreen),
            ),
            fillColor: funGreen.withOpacity(0.1),
            filled: true,
          ),
        ),
        onChanged: widget.onChanged,
        popupProps: const PopupProps.menu(
          showSearchBox: true,
        ));
  }
}
