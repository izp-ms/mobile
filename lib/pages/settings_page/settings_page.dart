import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/constants/ColorProvider.dart';
import 'package:mobile/custom_widgets/custom_drawer/custom_drawer.dart';
import 'package:mobile/custom_widgets/custom_appbars/main_page_app_bar.dart';
import 'package:mobile/pages/settings_page/settings_page_widgets/content_and_display.dart';
import 'package:mobile/pages/settings_page/settings_page_widgets/privacy_settings.dart';
import 'package:mobile/pages/settings_page/settings_page_widgets/units_format.dart';
import 'package:mobile/providers/metric_system_provider.dart';
import 'package:mobile/services/notification_service.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/text_icon_button.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    Key? key,
    required this.metricSystemValue,
    required this.themeValue,
    required this.dateFormatValue,
    required this.languageValue,
    required this.postcardLocationValue,
    required this.notificationRangeValue,
  }) : super(key: key);

  final bool metricSystemValue;
  final bool themeValue;
  final String dateFormatValue;
  final String languageValue;
  final bool postcardLocationValue;
  final double notificationRangeValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const MainPageAppBar(),
      drawer: CustomDrawer(context),
      body: ChangeNotifierProvider(
        create: (_) => MetricSystemProvider(),
        child: ListView(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  ContentAndDisplay(
                    themeValue: themeValue,
                    languageValue: languageValue,
                    postcardLocationValue: postcardLocationValue,
                    notificationRangeValue: notificationRangeValue,
                    useMetricSystem: metricSystemValue,
                  ),
                  UnitsFormat(
                      metricSystemValue: metricSystemValue,
                      dateFormatValue: dateFormatValue),
                  PrivacySettings(),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: Column(
                children: [
                  Center(
                      child: TextIconButton(
                        text: "Test noti",
                        shouldHaveIcon: true,
                        iconData: Icons.delete_forever,
                        iconSide: IconSide.left,
                        onTap: () {
                          NotificationService().showNotification(title: "Siema", body: "it Works");
                        },
                        fontSize: 15.0,
                        iconSize: 20.0,
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),),
                  Center(
                      child: TextIconButton(
                    text: AppLocalizations.of(context).deleteAccount,
                    shouldHaveIcon: true,
                    iconData: Icons.delete_forever,
                    iconSide: IconSide.left,
                    onTap: () {
                      print("Delete account button tapped");
                    },
                    fontSize: 15.0,
                    iconSize: 20.0,
                    mainAxisAlignment: MainAxisAlignment.center,
                  )),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      AppLocalizations.of(context).postcardia.toUpperCase(),
                      style: GoogleFonts.rubik(
                          fontSize: 18,
                          color: ColorProvider.getColor('inactive')),
                    ),
                  ),
                  Center(
                    child: Text(
                      AppLocalizations.of(context).version,
                      style: GoogleFonts.rubik(
                          fontSize: 18,
                          color: ColorProvider.getColor('inactive')),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
