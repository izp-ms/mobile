import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/extensions/capitalize.dart';

class UserNamesSection extends StatelessWidget {
  const UserNamesSection({
    super.key,
    required this.nickName,
    required this.firstName,
    required this.lastName,
  });

  final String nickName;
  final String? firstName;
  final String? lastName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          nickName,
          style: GoogleFonts.rubik(
            fontSize: 30,
          ),
          textAlign: TextAlign.center,
          softWrap: false,
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
        ),
        if (firstName != null && lastName != null)
          Text(
            "${firstName.toString().capitalize()} ${lastName.toString().capitalize()}",
            style: GoogleFonts.rubik(
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
            softWrap: false,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}
