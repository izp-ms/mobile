import 'package:flutter/material.dart';
import 'package:mobile/custom_widgets/custom_appbars/main_page_app_bar.dart';
import 'package:mobile/custom_widgets/custom_drawer/custom_admin_drawer.dart';

class AdminPostcardManagementPage extends StatelessWidget {
  const AdminPostcardManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainPageAppBar(),
      drawer: CustomAdminDrawer(context),
      body: const Center(
        child: Text("Postcards management"),
      ),
    );
  }
}
