import 'package:flutter/material.dart';

class ProfileBackgroundPicture extends StatelessWidget {
  const ProfileBackgroundPicture({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          'assets/profile_background_placeholder.jpg',
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
