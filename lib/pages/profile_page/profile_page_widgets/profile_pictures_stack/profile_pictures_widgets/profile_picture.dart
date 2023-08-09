import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final double profileImageSize = (deviceSize.width - 60) * 0.4;
    return Positioned(
      top: (deviceSize.width - 60) * 0.3,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: profileImageSize,
            width: profileImageSize,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              shape: BoxShape.circle,
              ),
            ),
          Container(
            height: profileImageSize - 10,
            width: profileImageSize - 10,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                //TODO image from backend
                image: NetworkImage(
                  'https://zipmex.com/static/d1af016df3c4adadee8d863e54e82331/1bbe7/Twitter-NFT-profile.jpg',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
