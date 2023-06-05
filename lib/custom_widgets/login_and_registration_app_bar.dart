import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

PreferredSizeWidget loginAndRegistrationAppBar(context) {
  return PreferredSize(
    preferredSize: Size.fromHeight(appBarHeight(context)),
    child: AppBar(
      shadowColor: Colors.black,
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 10.0,
      centerTitle: true,
      toolbarHeight: appBarHeight(context),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.local_post_office_outlined,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 40,
          ),
          Text(
            "postcardia",
            style: GoogleFonts.rubik(
              fontSize: 40,
              fontWeight: FontWeight.w300,
              color: Theme.of(context).colorScheme.onPrimary
            ),
          )
        ],
      ),
    ),
  );
}

double appBarHeight(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.12;
}
