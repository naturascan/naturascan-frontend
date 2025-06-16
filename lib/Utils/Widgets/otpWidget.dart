import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpWidget extends StatelessWidget {
  final PinTheme? errorPinTheme, defaultPinTheme, focusedPinTheme;
  final TextEditingController? controller;

  const OtpWidget(
      {super.key,
      this.controller,
      this.defaultPinTheme,
      this.errorPinTheme,
      this.focusedPinTheme});

  @override
  Widget build(BuildContext context) {
    // Otp layout
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Pinput(
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.characters,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          length: 4,
          controller: controller,
          focusNode: FocusNode(),
          validator: (value) {
            if (value!.isEmpty && value.length < 4) {
              return "Veuillez remplir ce champ";
            }
            return null;
          },
          defaultPinTheme: defaultPinTheme,
          onCompleted: (pin) {},
          focusedPinTheme: focusedPinTheme,
          errorPinTheme: errorPinTheme),
    );
  }
}
