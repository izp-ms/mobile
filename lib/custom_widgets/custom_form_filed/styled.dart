import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

InputDecoration customTextFieldDecoration(context, hintText, inputIcon) {
  return InputDecoration(
    fillColor: Theme.of(context).colorScheme.onBackground,
    suffixIcon: (inputIcon != null)
        ? Icon(
            inputIcon,
            color: Theme.of(context).colorScheme.secondary,
          )
        : null,
    labelText: (hintText != null) ? hintText : null,
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
    errorBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(25),
      ),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.error,
        width: 2,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(25),
      ),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.error,
        width: 1,
      ),
    ),
    disabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(25),
      ),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    ),
  );
}
