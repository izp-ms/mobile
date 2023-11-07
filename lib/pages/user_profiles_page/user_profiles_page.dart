import 'package:flutter/material.dart';
import 'package:mobile/custom_widgets/custom_appbars/main_page_app_bar.dart';
import 'package:mobile/custom_widgets/custom_drawer/custom_admin_drawer.dart';
import 'package:mobile/custom_widgets/custom_drawer/custom_drawer.dart';

class UserProfilesPage extends StatelessWidget {
  const UserProfilesPage({
    super.key,
    this.isUserAdmin = false,
  });

  final bool isUserAdmin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainPageAppBar(),
      drawer: isUserAdmin ? CustomAdminDrawer(context) : CustomDrawer(context),
      body: const Center(
        child: Text("user profiles"),
      ),
    );
  }
}
