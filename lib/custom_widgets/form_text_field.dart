import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/styles/auth_text_field_decoration.dart';

class FormTextField extends StatelessWidget {
  const FormTextField({
    super.key,
    required this.hintText,
    required this.inputIcon,
  });

  final String hintText;
  final IconData inputIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: GoogleFonts.rubik(fontSize: 14),
      decoration: authTextFieldDecoration(context, hintText, inputIcon),
    );
  }
}
