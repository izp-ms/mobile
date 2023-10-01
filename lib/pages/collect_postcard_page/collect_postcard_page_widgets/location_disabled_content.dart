import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationDisabledContent extends StatelessWidget {
  const LocationDisabledContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
            child: Text(
              "Location is disabled",
              style: GoogleFonts.rubik(
                fontSize: 30,
              ),
            ),
          ),
          const Icon(
            Icons.location_off_outlined,
            size: 200,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: AutoSizeText(
              "If you want to collect postcards you need to turn on your location to determine which postcards are near you.",
              style: GoogleFonts.rubik(
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
              maxLines: 5,
            ),
          ),
        ],
      ),
    );
  }
}
