import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:kgs_mobile_v2/theme/colors.dart';

class BasicTextField extends StatefulWidget {

  String? Function(String?)? validator;
  final void Function(dynamic)? onChanged;
  String? initialValue;
  TextEditingController? controller = TextEditingController();


  BasicTextField({
    this.onChanged,
    this.validator,
    this.initialValue,
    this.controller,
    super.key
  });

  @override
  State<BasicTextField> createState() => _BasicTextFieldState();
}

class _BasicTextFieldState extends State<BasicTextField> {
  final String primaryFont = 'Poppins';

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
        decoration: InputDecoration(
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
        onChanged: widget.onChanged,
        validator: widget.validator,
        initialValue: widget.initialValue,
    );
  }
}
