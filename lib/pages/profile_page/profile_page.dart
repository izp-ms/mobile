import 'package:flutter/material.dart';
import 'package:mobile/custom_widgets/custom_drawer/custom_drawer.dart';
import 'package:mobile/custom_widgets/main_page_app_bar.dart';
import 'package:mobile/pages/profile_page/profile_page_widgets/personal_info_section/personal_info_section.dart';
import 'package:mobile/pages/profile_page/profile_page_widgets/profile_pictures_stack/profile_pictures_stack.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainPageAppBar(),
      drawer: CustomDrawer(context),
      body: Container(
        constraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
          maxWidth: double.infinity,
          maxHeight: double.infinity,
        ),
        padding: const EdgeInsets.all(30),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProfilePicturesStack(),
            SizedBox(height: 70,),
            PersonalInfoSection(),
          ],
        ),
      ),
    );
  }
}







