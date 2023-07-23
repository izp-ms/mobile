import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/styles/auth_text_field_decoration.dart';

class PasswordFormField extends StatelessWidget {
  const PasswordFormField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: GoogleFonts.rubik(fontSize: 14),
      decoration: authTextFieldDecoration(context, "Password", Icons.lock),
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
    );
  }
}


