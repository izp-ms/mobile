import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SwitchPageLink extends StatelessWidget {
  const SwitchPageLink({
    super.key,
    required this.regularText,
    required this.linkText,
    required this.onLinkPress,
  });

  final String regularText;
  final String linkText;
  final VoidCallback onLinkPress;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          regularText,
          style: GoogleFonts.rubik(fontSize: 14),
        ),
        GestureDetector(
          onTap: () {
            onLinkPress();
          },
          child: Text(
            linkText,
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}