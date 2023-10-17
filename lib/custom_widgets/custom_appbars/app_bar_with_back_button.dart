import 'package:flutter/material.dart';

class AppBarWithBackButton extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWithBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      scrolledUnderElevation: 0,
      leading: IconButton(
        padding: const EdgeInsets.only(left: 30),
        iconSize: 30,
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
