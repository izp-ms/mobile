import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: (MediaQuery.of(context).size.width - 60) * 0.3,
      child: Container(
        height: (MediaQuery.of(context).size.width - 60) * 0.4,
        width: (MediaQuery.of(context).size.width - 60) * 0.4,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: const DecorationImage(
            fit: BoxFit.cover,
            //TODO image from backend
            image: NetworkImage(
                'https://zipmex.com/static/d1af016df3c4adadee8d863e54e82331/1bbe7/Twitter-NFT-profile.jpg'),
          ),
          border: Border.all(
            color: Theme.of(context).colorScheme.background,
            width: 5,
          ),
        ),
      ),
    );
  }
}
