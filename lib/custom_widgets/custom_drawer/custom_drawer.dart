import 'package:flutter/material.dart';
import 'package:mobile/helpers/shared_preferences.dart';
import 'package:mobile/pages/collect_postcard_list_page/collect_postcard_list_page.dart';
import 'package:mobile/pages/login_page/login_page.dart';
import 'package:mobile/pages/postcards_page/postcards_page.dart';
import 'package:mobile/pages/profile_page/profile_page.dart';
import 'package:mobile/pages/settings_page/settings_page.dart';
import 'package:mobile/services/secure_storage_service.dart';
import 'custom_drawer_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomDrawer extends Drawer {
  const CustomDrawer(this.context, {super.key});

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
                          tileText: AppLocalizations.of(context).profile,
                          onTilePress: () {
                            onProfilePress(context);
                          }),
                      SizedBox(
                        height: gapBetweenTiles,
                      ),
                      CustomDrawerTile(
                        tileIcon: Icons.local_post_office_outlined,
                        tileText: AppLocalizations.of(context).postcards,
                        onTilePress: () {
                          onPostcardsPress(context);
                        },
                      ),
                      SizedBox(
                        height: gapBetweenTiles,
                      ),
                      CustomDrawerTile(
                        tileIcon: Icons.location_on_outlined,
                        tileText: "Collect",
                        onTilePress: () {
                          onCollectPostcardPress(context);
                        },
                      ),
                      SizedBox(
                        height: gapBetweenTiles,
                      ),
                      CustomDrawerTile(
                        tileIcon: Icons.settings_outlined,
                        tileText: AppLocalizations.of(context).settings,
                        onTilePress: () {
                          onSettingsPress(context);
                        },
                      ),
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

  void onProfilePress(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  void onPostcardsPress(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const PostcardsPage(),
      ),
    );
  }

  void onSettingsPress(context) async {
    bool metricSystemValue =
        await AppSharedPreferences.getMetricSystemPreference();
    bool themeValue = await AppSharedPreferences.getThemePreference();
    String dateFormatValue = await AppSharedPreferences.getDatePreference();
    String languageValue = await AppSharedPreferences.getLanguagePreference();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(
          metricSystemValue: metricSystemValue,
          themeValue: themeValue,
          dateFormatValue: dateFormatValue,
          languageValue: languageValue,
        ),
      ),
    );
  }

  void onCollectPostcardPress(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const CollectPostcardListPage(),
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
