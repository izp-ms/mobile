import 'package:flutter/material.dart';

class CollectionPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CollectionPageAppBar({
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
        indicatorSize: TabBarIndicatorSize.label, // Set indicatorSize to label
        indicatorWeight: 2.0, // Adjust the indicatorWeight as needed
        tabs: [
          Tab(
            icon: Icon(Icons.collections, color: Theme.of(context).colorScheme.secondary),
          ),
          Tab(
            icon: Icon(Icons.collections_bookmark, color: Theme.of(context).colorScheme.secondary),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 48.0);
}