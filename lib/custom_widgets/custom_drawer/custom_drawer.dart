import 'package:flutter/material.dart';
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
                      ),
                      SizedBox(
                        height: gapBetweenTiles,
                      ),
                      CustomDrawerTile(
                        tileIcon: Icons.local_post_office_outlined,
                        tileText: AppLocalizations.of(context).postcards,
                      ),
                      SizedBox(
                        height: gapBetweenTiles,
                      ),
                      CustomDrawerTile(
                        tileIcon: Icons.settings_outlined,
                        tileText: AppLocalizations.of(context).settings,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
