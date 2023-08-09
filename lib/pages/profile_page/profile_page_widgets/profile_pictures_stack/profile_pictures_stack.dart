import 'package:flutter/material.dart';
import 'package:mobile/pages/profile_page/profile_page_widgets/profile_pictures_stack/profile_pictures_widgets/profile_background_picture.dart';
import 'package:mobile/pages/profile_page/profile_page_widgets/profile_pictures_stack/profile_pictures_widgets/profile_picture.dart';

class ProfilePicturesStack extends StatelessWidget {
  const ProfilePicturesStack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        ProfileBackgroundPicture(),
        ProfilePicture(),
      ],
    );
  }
}
