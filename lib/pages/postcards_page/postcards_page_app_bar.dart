import 'package:flutter/material.dart';

class PostcardsPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PostcardsPageAppBar({
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
              final FocusScopeNode currentScope = FocusScope.of(context);
              if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
                FocusManager.instance.primaryFocus?.unfocus();
              };
              Scaffold.of(context).openDrawer();
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
      bottom: TabBar(
        onTap: (index){
          final FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus?.unfocus();
          };
        },
        tabs: [
          Tab(icon: Icon(Icons.collections, color: Theme.of(context).colorScheme.secondary)),
          Tab(icon: Icon(Icons.collections_bookmark, color: Theme.of(context).colorScheme.secondary,)),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 48.0);
}