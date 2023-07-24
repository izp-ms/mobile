import 'package:flutter/material.dart';
import 'package:mobile/custom_widgets/custom_drawer/custom_drawer.dart';
import 'package:mobile/custom_widgets/main_page_app_bar.dart';
import 'package:mobile/pages/profile_page/profile_page_widgets/profile_pictures_stack/profile_pictures_stack.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainPageAppBar(),
      drawer: CustomDrawer(context),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: const Column(
          children: [
            ProfilePicturesStack(),
          ],
        ),
      ),
    );
  }
}






