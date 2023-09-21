import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.buttonText,
    required this.onButtonPressed,
    this.isLoading = false,
    this.height = 60,
  });

  final String buttonText;
  final VoidCallback onButtonPressed;
  final bool isLoading;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
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
        child: getButtonContent(context),
      ),
    );
  }

  getButtonContent(context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          )
        : AutoSizeText(
            buttonText,
            style: GoogleFonts.rubik(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontSize: 20,
            ),
            maxLines: 1,
          );
  }
}
