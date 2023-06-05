import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      style: GoogleFonts.rubik(fontSize: 8),
      decoration: textFieldDecoration(context, hintText, inputIcon),
    );
  }
}

InputDecoration textFieldDecoration(context, hintText, inputIcon) {
  return InputDecoration(
    suffixIcon: Icon(
      inputIcon,
      color: Theme.of(context).colorScheme.secondary,
    ),
    labelText: hintText,
    labelStyle: GoogleFonts.rubik(
      color: Theme.of(context).colorScheme.onPrimary,
    ),
    filled: true,
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(20),
      ),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(20),
      ),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.secondary,
        width: 2,
      ),
    ),
  );
}
