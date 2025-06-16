// Project imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomInputField extends StatelessWidget {
  const CustomInputField(
      {super.key,
      this.controller,
      this.backgroundColor,
      this.brdColor = Colors.black54,
      this.label,
      this.inputBorder,
      this.obscure,
      this.maxLines,
      this.minLines,
      this.readOnly,
      this.suffix,
      this.prefix,
      this.hint,
      this.autoValidate,
      this.isDense,
      this.onChanged,
      this.onTap,
      this.validator,
      this.enabled,
      this.keyboardType,
      this.contentPadding});

  final TextEditingController? controller;
  final String? label;
  final InputBorder? inputBorder;
  final Color? backgroundColor;
  final Color? brdColor;
  final bool? obscure;
  final int? minLines;
  final int? maxLines;
  final bool? readOnly;
  final Widget? suffix;
  final Widget? prefix;
  final String? hint;
  final bool? autoValidate;
  final bool? isDense;
  final bool? enabled;
  final Function(String)? onChanged;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry? contentPadding;

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
      child: TextFormField(
        maxLines: maxLines ?? 1,
        minLines: minLines ?? 1,
        autovalidateMode: autoValidate ?? false
            ? AutovalidateMode.always
            : AutovalidateMode.onUserInteraction,
        // style: const TextStyle(color: Colors.white),
        controller: controller,
        readOnly: readOnly ?? false,
        textCapitalization: TextCapitalization.sentences,
        keyboardType: keyboardType ?? TextInputType.text,
        obscureText: obscure ?? false,
        validator: validator,
        onChanged: onChanged,
        enabled: enabled ?? true,
        onTap: onTap,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        decoration: InputDecoration(
            errorMaxLines: 3,
            // fillColor: Colors.grey.shade200,
            // filled: true,
            isDense: (isDense != null) ? isDense : false,
            errorStyle: GoogleFonts.nunito(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              // height: 18,
            ),
            // contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            contentPadding: contentPadding ??
                const EdgeInsets.only(left: 16.0, right: 8.0, top: 10),
            suffixIcon: suffix,
            // filled: true,
            // fillColor: backgroundColor ?? kInputBackground,
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
            // enabledBorder: inputBorder ??
            //     OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(10),
            //         borderSide: BorderSide(color: brdColor!, width: 1.0))
            ),
      ),
    );
  }
}
