import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.overflow,
    this.maxLines,
    this.fontStyle,
    this.textAlign,
  });
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;
  final FontStyle? fontStyle;
  final int? maxLines;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: true,
        style: GoogleFonts.nunito(
            fontSize: fontSize, fontWeight: fontWeight, color: color, fontStyle: fontStyle));
  }
}
