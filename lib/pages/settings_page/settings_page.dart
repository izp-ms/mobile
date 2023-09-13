import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/custom_widgets/custom_drawer/custom_drawer.dart';
import 'package:mobile/custom_widgets/main_page_app_bar.dart';
import 'package:mobile/custom_widgets/submit_button.dart';
import 'package:mobile/pages/settings_page/settings_page_widgets/content_and_display.dart';
import 'package:mobile/pages/settings_page/settings_page_widgets/privacy_settings.dart';
import 'package:mobile/pages/settings_page/settings_page_widgets/units_format.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const MainPageAppBar(),
      drawer: CustomDrawer(context),
      body: ListView(
        children: [
          const SingleChildScrollView(
            child: Column(
              children: [
                ContentAndDisplay(),
                UnitsFormat(),
                PrivacySettings(),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: SubmitButton(
                      buttonText: AppLocalizations.of(context).deleteAccount,
                      onButtonPressed: () => {print("delete account")},
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    AppLocalizations.of(context).postcardia.toUpperCase(),
                    style: GoogleFonts.rubik(
                        fontSize: 18, color: Colors.grey[500]),
                  ),
                ),
                Center(
                  child: Text(
                    AppLocalizations.of(context).version,
                    style: GoogleFonts.rubik(
                        fontSize: 18, color: Colors.grey[500]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
