import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/constants/theme.dart';

PreferredSizeWidget loginAndRegistrationAppBar(context) {
  return PreferredSize(
    preferredSize: Size.fromHeight(appBarHeight(context)),
    child: AppBar(
      shadowColor: SharedColors.black,
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 10.0,
      centerTitle: true,
      toolbarHeight: appBarHeight(context),
      title: Container(
        padding: EdgeInsets.only(bottom: appBarHeight(context) * 0.2),
        height: appBarHeight(context),
        child: FittedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.local_post_office_outlined,
                color: Theme.of(context).colorScheme.primaryContainer,
                size: 40,
              ),
              Text(
                AppLocalizations.of(context).postcardia,
                style: GoogleFonts.rubik(
                  fontSize: 40,
                  fontWeight: FontWeight.w300,
                  color: Theme.of(context).colorScheme.primaryContainer
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

double appBarHeight(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.13;
}
