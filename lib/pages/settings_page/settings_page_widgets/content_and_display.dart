import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/custom_widgets/settings_switch.dart';
import 'package:mobile/helpers/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ContentAndDisplay extends StatefulWidget {
  const ContentAndDisplay({
    Key? key,
    required this.themeValue,
    required this.languageValue
  }) : super(key: key);

  final String languageValue;
  final bool themeValue;

  @override
  State<ContentAndDisplay> createState() => _ContentAndDisplayState();
}

class _ContentAndDisplayState extends State<ContentAndDisplay> {
  bool switchThemeValue = false;

  @override
  void initState() {
    super.initState();
    switchThemeValue = widget.themeValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
          child: Text(
            AppLocalizations.of(context).contentAndDisplay,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context).switchTheme,
                    style: GoogleFonts.rubik(
                      fontSize: 18,
                    ),
                  ),
                  SwitchWidget(
                    value: switchThemeValue,
                    onChanged: (bool value) {
                      setState(() {
                        switchThemeValue = value;
                      });
                      AppSharedPreferences.saveThemePreference(value); // Save the preference when changed
                    },
                  )
                ],
              ),
              SizedBox(height: 3),
              GestureDetector(
                onTap: () => {print("app language")},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).appLanguage,
                      style: GoogleFonts.rubik(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "${widget.languageValue} >",
                      style: GoogleFonts.rubik(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: openNotificationSettings,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).notifications,
                      style: GoogleFonts.rubik(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context).settings_details,
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

  void openNotificationSettings() {
    AppSettings.openAppSettings(type: AppSettingsType.notification);
  }
}
