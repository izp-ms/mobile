import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/custom_widgets/settings_dialog.dart';

class PrivacySettings extends StatelessWidget {
  const PrivacySettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
          child: Text(
            AppLocalizations.of(context).privacySetting,
            style: GoogleFonts.rubik(
              fontSize: 18,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => SettingsDialog(
                    dialogTitle: AppLocalizations.of(context).termsOfService,
                    dialogContent: AppLocalizations.of(context).termsOfServiceContent,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).termsOfService,
                      style: GoogleFonts.rubik(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context).details,
                      style: GoogleFonts.rubik(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => SettingsDialog(
                    dialogTitle: AppLocalizations.of(context).privacy,
                    dialogContent: AppLocalizations.of(context).privacyContent,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).privacy,
                      style: GoogleFonts.rubik(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context).details,
                      style: GoogleFonts.rubik(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


