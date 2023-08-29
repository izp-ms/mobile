import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.buttonText,
    required this.onButtonPressed,
    this.isLoading = false,
  });

  final String buttonText;
  final VoidCallback onButtonPressed;
  final bool isLoading;

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
        child: getButtonContent(context));
  }

  getButtonContent(context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          )
        : Text(
            buttonText,
            style: GoogleFonts.rubik(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontSize: 20,
            ),
          );
  }
}
