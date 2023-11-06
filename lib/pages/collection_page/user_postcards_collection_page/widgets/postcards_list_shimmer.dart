import 'package:flutter/material.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/postcard_shimmer.dart';

class PostcardsListShimmer extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final bool showDescription;

  PostcardsListShimmer({
    required this.itemCount,
    required this.crossAxisCount,
    required this.showDescription,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.7,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: PostcardShimmer(showDescriptionShimmer: showDescription),
        );
      },
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(), // Disable scrolling
    );
  }
}