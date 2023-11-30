import 'package:flutter/material.dart';
import 'package:mobile/pages/friends_page/widgets/friend_shimmer.dart';

class FriendListShimmer extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final String title;

  FriendListShimmer({
    required this.itemCount,
    required this.crossAxisCount,
    this.title = "",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Add a title widget here
        if(title != "")
          Text(
            title,
            style: TextStyle(
              fontSize: 25, // Customize the font size as needed
              fontWeight: FontWeight.bold, // Customize the font weight as needed
            ),
          ),
        Flexible(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 4,
            ),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: FriendShimmer(),
              );
            },
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(), // Disable scrolling
          ),
        ),
      ],
    );
  }
}