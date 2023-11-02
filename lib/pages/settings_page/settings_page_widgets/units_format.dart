import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/custom_widgets/settings_switch.dart';
import 'package:mobile/pages/settings_page/settings_page_widgets/components/settings_toggle_button.dart';
import 'package:mobile/helpers/shared_preferences.dart';
import 'package:mobile/providers/metric_system_provider.dart';
import 'package:provider/provider.dart';

class UnitsFormat extends StatefulWidget {
  const UnitsFormat({
    Key? key,
    required this.metricSystemValue,
    required this.dateFormatValue,
  }) : super(key: key);

  final bool metricSystemValue;
  final String dateFormatValue;

  @override
  State<UnitsFormat> createState() => _UnitsFormatState();
}

class _UnitsFormatState extends State<UnitsFormat> {
  bool useMetricSystemValue = false;
  int dateFormatToggleButtonIndex = 0;

  @override
  void initState() {
    super.initState();
    useMetricSystemValue = widget.metricSystemValue;
    dateFormatToggleButtonIndex =
        widget.dateFormatValue == 'DD.MM.YYYY' ? 0 : 1;
  }

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
                initialSelectedIndex: dateFormatToggleButtonIndex,
                onSelected: (int index) {
                  AppSharedPreferences.saveDatePreference(
                      index == 0 ? 'DD.MM.YYYY' : 'MM.DD.YYYY');
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
                  Consumer<MetricSystemProvider>(builder:
                      (context, MetricSystemProvider metricNotifier, child) {
                    return SwitchWidget(
                      value: useMetricSystemValue,
                      onChanged: (bool value) {
                        setState(() {
                          useMetricSystemValue = value;
                          metricNotifier.isMetric = value;
                        });
                        AppSharedPreferences.saveMetricSystemPreference(value);
                      },
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
