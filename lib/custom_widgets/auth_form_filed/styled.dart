import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

InputDecoration authTextFieldDecoration(context, hintText, inputIcon) {
  return InputDecoration(
    fillColor: Theme.of(context).colorScheme.primary,
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
        Radius.circular(25),
      ),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(25),
      ),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.secondary,
        width: 2,
      ),
    ),
  );
}