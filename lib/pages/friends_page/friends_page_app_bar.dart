import 'package:flutter/material.dart';

class FriendsPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FriendsPageAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(
              Icons.menu,
              size: 30,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
      bottom: TabBar(
        tabs: [
          Tab(icon: Icon(Icons.person, color: Theme.of(context).colorScheme.secondary)),
          Tab(icon: Icon(Icons.person_pin_sharp, color: Theme.of(context).colorScheme.secondary,)),
          Tab(icon: Icon(Icons.search, color: Theme.of(context).colorScheme.secondary,)),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 48.0);
}