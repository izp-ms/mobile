import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

PreferredSizeWidget loginAppBar(context) {
  return PreferredSize(
    preferredSize: Size.fromHeight(appBarHeight(context)),
    child: AppBar(
      shadowColor: Colors.black,
      backgroundColor: const Color(0xFFA6ECFF),
      elevation: 10.0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      toolbarHeight: appBarHeight(context),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.local_post_office_outlined,
            color: Colors.black,
            size: 40,
          ),
          Text(
            "postcardia",
            style: GoogleFonts.rubik(
              fontSize: 40,
              fontWeight: FontWeight.w300,
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
