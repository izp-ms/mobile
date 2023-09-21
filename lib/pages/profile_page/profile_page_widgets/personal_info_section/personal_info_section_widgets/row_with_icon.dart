import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RowWithIcon extends StatelessWidget {
  const RowWithIcon({
    super.key,
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 25,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          text,
          style: GoogleFonts.rubik(
            fontSize: 18,
          ),
        )
      ],
    );
  }
}
