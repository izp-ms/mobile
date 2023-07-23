import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.buttonText,
    required this.onButtonPressed,
  });

  final String buttonText;
  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onButtonPressed();
      },
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      child: Text(
        buttonText,
        style: GoogleFonts.rubik(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          fontSize: 20,
        ),
      ),
    );
  }
}
