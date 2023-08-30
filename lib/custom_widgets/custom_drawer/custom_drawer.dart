import 'package:flutter/material.dart';
import 'package:mobile/pages/login_page/login_page.dart';
import 'package:mobile/pages/postcards_page/postcards_page.dart';
import 'package:mobile/pages/profile_page/profile_page.dart';
import 'package:mobile/pages/settings_page/settings_page.dart';
import 'package:mobile/repositories/secure_storage_repository.dart';
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

  void onSettingsPress(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsPage(),
      ),
    );
  }

  Future<void> onLogOutPress(context) async {
    await SecureStorageRepository.delete(key: 'token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }
}
