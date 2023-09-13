import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/custom_widgets/custom_drawer/settings_switch.dart';
import 'package:mobile/pages/settings_page/settings_page_widgets/components/settings_toggle_button.dart';

class UnitsFormat extends StatelessWidget {
  const UnitsFormat({
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
            AppLocalizations.of(context).unitsFormat,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.date_range,
                    size: 25,
                  ),
                  Text(
                    AppLocalizations.of(context).choseDateFormat,
                    style: GoogleFonts.rubik(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SettingsToggleButtons(
                onSelected: (int index) {
                  // Handle the selected index here
                  print(
                      "Selected format: ${index == 0 ? 'DD.MM.YYYY' : 'MM.DD.YYYY'}");
                },
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.map,
                        size: 25,
                      ),
                      Text(
                        AppLocalizations.of(context).useMetricSystem,
                        style: GoogleFonts.rubik(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SwitchWidget(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}