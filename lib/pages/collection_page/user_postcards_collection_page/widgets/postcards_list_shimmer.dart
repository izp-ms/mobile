import 'package:flutter/material.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/postcard_shimmer.dart';

class PostcardsListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: PostcardShimmer(),
        );
      },
    );
  }
}
