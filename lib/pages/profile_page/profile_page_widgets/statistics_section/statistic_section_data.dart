import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatisticsSectionData extends StatelessWidget {
  const StatisticsSectionData({
    super.key,
    required this.dataTitle,
    required this.dataValue,
  });

  final String dataTitle;
  final int dataValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          dataTitle,
          style: GoogleFonts.rubik(
            fontSize: 18,
          ),
        ),
        Text(
          '$dataValue',
          style: GoogleFonts.rubik(
            fontSize: 22,
          ),
        )
      ],
    );
  }
}