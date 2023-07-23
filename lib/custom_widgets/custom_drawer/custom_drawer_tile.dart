import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawerTile extends StatelessWidget {
  const CustomDrawerTile({
    super.key,
    required this.tileIcon,
    required this.tileText,
    required this.onTilePress,
  });

  final IconData tileIcon;
  final String tileText;
  final VoidCallback onTilePress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
      title: Row(
        children: [
          Icon(
            tileIcon,
            size: 30,
          ),
          const SizedBox(
            width: 18,
          ),
          Text(
            tileText,
            style: GoogleFonts.rubik(
              fontSize: 25,
            ),
          )
        ],
      ),
      onTap: () {
        onTilePress();
      },
    );
  }
}
