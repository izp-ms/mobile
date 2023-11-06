import 'package:flutter/material.dart';
import 'package:mobile/helpers/shared_preferences.dart';
import 'package:mobile/pages/admin_postcard_page/admin_postcard_management_page.dart';
import 'package:mobile/pages/admin_settings_page/admin_settings_page.dart';
import 'package:mobile/pages/login_page/login_page.dart';
import 'package:mobile/pages/user_profiles_page/user_profiles_page.dart';
import 'package:mobile/services/secure_storage_service.dart';
import 'custom_drawer_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomAdminDrawer extends Drawer {
  const CustomAdminDrawer(this.context, {super.key});

  final BuildContext context;
  final double gapBetweenTiles = 30;

  _closeDrawer() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  padding: const EdgeInsets.only(left: 30),
                  iconSize: 30,
                  onPressed: _closeDrawer,
                  icon: const Icon(Icons.arrow_back),
                ),
                Container(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDrawerTile(
                          tileIcon: Icons.person,
                          tileText: AppLocalizations.of(context).userProfiles,
                          onTilePress: () {
                            onUserProfilesPress(context);
                          }),
                      SizedBox(
                        height: gapBetweenTiles,
                      ),
                      CustomDrawerTile(
                          tileIcon: Icons.local_post_office_outlined,
                          tileText:
                              AppLocalizations.of(context).postcardsManagement,
                          onTilePress: () {
                            onPostcardManagementPress(context);
                          }),
                      SizedBox(
                        height: gapBetweenTiles,
                      ),
                      CustomDrawerTile(
                          tileIcon: Icons.settings_outlined,
                          tileText: AppLocalizations.of(context).adminSettings,
                          onTilePress: () {
                            onAdminSettingsPress(context);
                          }),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(30, 0, 0, 60),
              child: CustomDrawerTile(
                tileIcon: Icons.logout,
                tileText: AppLocalizations.of(context).logOut,
                onTilePress: () {
                  onLogOutPress(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onUserProfilesPress(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const UserProfilesPage(
          isUserAdmin: true,
        ),
      ),
    );
  }

  void onPostcardManagementPress(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const AdminPostcardManagementPage(),
      ),
    );
  }

  Future<void> onAdminSettingsPress(context) async {
    bool metricSystemValue =
        await AppSharedPreferences.getMetricSystemPreference();
    bool themeValue = await AppSharedPreferences.getThemePreference();
    String dateFormatValue = await AppSharedPreferences.getDatePreference();
    String languageValue = await AppSharedPreferences.getLanguagePreference();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AdminSettingsPage(
          metricSystemValue: metricSystemValue,
          themeValue: themeValue,
          dateFormatValue: dateFormatValue,
          languageValue: languageValue,
        ),
      ),
    );
  }

  Future<void> onLogOutPress(context) async {
    await SecureStorageService.delete(key: 'token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }
}
