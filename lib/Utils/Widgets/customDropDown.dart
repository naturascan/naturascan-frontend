// Project imports:
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropDownInputField extends StatelessWidget {
  const CustomDropDownInputField({
    super.key,
    this.value,
    this.brdColor = Colors.black54,
    this.label,
    this.hint,
    this.suffix,
    this.prefix,
    this.inputBorder,
    this.autoValidate,
    this.isDense,
    this.items,
    this.selectedItemBuilder,
    this.onChanged,
    this.validator,
  });

  final String? value;
  final String? label;
  final Color? brdColor;
  final String? hint;
  final Widget? suffix;
  final Widget? prefix;
  final InputBorder? inputBorder;
  final bool? autoValidate;
  final bool? isDense;
  // final List<String>? items;
  final List<Widget> Function(BuildContext)? selectedItemBuilder;
  final List<DropdownMenuItem<String>>? items;
  final Function(dynamic)? onChanged;
  final String? Function(dynamic)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade200,
          boxShadow: const [
            // BoxShadow(
            //     color: Colors.grey.shade200,
            //     offset: const Offset(0, -2),
            //     blurRadius: 2,
            //     spreadRadius: 2)
          ]),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items,
        selectedItemBuilder: selectedItemBuilder,
        // items?.map<DropdownMenuItem<String>>((String value) {
        //   return DropdownMenuItem<String>(
        //       value: value,
        //       child: Text(
        //         value,
        //         overflow: TextOverflow.ellipsis,
        //         style: const TextStyle(),
        //       ));
        // }).toList(),
        autovalidateMode: autoValidate ?? false
            ? AutovalidateMode.always
            : AutovalidateMode.onUserInteraction,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
            errorMaxLines: 3,
            isDense: (isDense != null) ? isDense : false,
            errorStyle: GoogleFonts.nunito(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            contentPadding: const EdgeInsets.only(left: 16.0, right: 8.0),
            suffixIcon: suffix,
            prefixIcon: prefix,
            labelText: label,
            hintText: hint,
            labelStyle: GoogleFonts.nunito(color: brdColor),
            hintStyle: GoogleFonts.nunito(color: brdColor),
            border: InputBorder.none,
            enabledBorder: InputBorder.none
            // border: inputBorder ??
            //     OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(10),
            //         borderSide: BorderSide(color: brdColor!, width: 1.0)),
            // enabledBorder: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(10),
            //     borderSide: BorderSide(color: brdColor!, width: 1.0))
            ),
      ),
    );
  }
}

class CustomDropDownInputField2 extends StatelessWidget {
  const CustomDropDownInputField2({
    super.key,
    this.value,
    this.brdColor = Colors.black54,
    this.label,
    this.hint,
    this.suffix,
    this.prefix,
    this.inputBorder,
    this.autoValidate,
    this.isDense,
    this.items,
    this.selectedItemBuilder,
    this.onChanged,
    this.validator,
  });

  final String? value;
  final String? label;
  final Color? brdColor;
  final String? hint;
  final Widget? suffix;
  final Widget? prefix;
  final InputBorder? inputBorder;
  final bool? autoValidate;
  final bool? isDense;
  // final List<String>? items;
  final List<Widget> Function(BuildContext)? selectedItemBuilder;
  final List<DropdownMenuItem<String>>? items;
  final Function(dynamic)? onChanged;
  final String? Function(dynamic)? validator;

  @override
  Widget build(BuildContext context) {
    return 
    Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade200,
          boxShadow: const [
          
          ]),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items,
        selectedItemBuilder: selectedItemBuilder,
        autovalidateMode:  AutovalidateMode.always,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
            errorMaxLines: 3,
            isDense: (isDense != null) ? isDense : false,
            errorStyle: GoogleFonts.nunito(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            contentPadding: const EdgeInsets.only(left: 16.0, right: 8.0),
            suffixIcon: suffix,
            prefixIcon: prefix,
            labelText: label,
            hintText: hint,
            labelStyle: GoogleFonts.nunito(color: Colors.black),
            hintStyle: GoogleFonts.nunito(color: Colors.black),
            border: InputBorder.none,
            enabledBorder: InputBorder.none
            ),
      ),
    );
 
  }
}
