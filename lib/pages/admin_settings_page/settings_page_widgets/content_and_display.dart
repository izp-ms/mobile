import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/custom_widgets/settings_switch.dart';
import 'package:mobile/helpers/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ContentAndDisplay extends StatefulWidget {
  const ContentAndDisplay({
    Key? key,
    required this.themeValue,
    required this.languageValue,
    required this.useMetricSystem,
  }) : super(key: key);

  final String languageValue;
  final bool themeValue;
  final bool useMetricSystem;

  @override
  State<ContentAndDisplay> createState() => _ContentAndDisplayState();
}

class _ContentAndDisplayState extends State<ContentAndDisplay> {
  bool switchThemeValue = false;
  bool useMetricSystem = false;

  @override
  void initState() {
    super.initState();
    switchThemeValue = widget.themeValue;
    useMetricSystem = widget.useMetricSystem;
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
                  Consumer<ThemeProvider>(
                      builder: (context, ThemeProvider themeNotifier, child) {
                    return SwitchWidget(
                      value: switchThemeValue,
                      onChanged: (bool themeValue) {
                        setState(() {
                          switchThemeValue = themeValue;
                          themeNotifier.isDark = themeValue;
                        });
                        AppSharedPreferences.saveThemePreference(themeValue);
                      },
                    );
                  })
                ],
              ),
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
