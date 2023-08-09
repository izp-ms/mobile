import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/custom_widgets/auth_form_filed/styled.dart';

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
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter validate email';
        }
        return null;
      },
      style: GoogleFonts.rubik(fontSize: 14),
      decoration: authTextFieldDecoration(context, hintText, inputIcon),
      cursorColor: Theme.of(context).colorScheme.secondary,
    );
  }
}
