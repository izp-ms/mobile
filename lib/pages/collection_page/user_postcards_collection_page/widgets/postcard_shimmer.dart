import 'package:flutter/material.dart';
import 'package:mobile/custom_widgets/custom_shimmer/custom_shimmer.dart';

class PostcardShimmer extends StatelessWidget {
  final bool showDescriptionShimmer;

  PostcardShimmer({this.showDescriptionShimmer = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10),
          child: CustomShimmer(
            context: context,
            width: double.infinity,
            height: 110,
          ),
        ),
        if (showDescriptionShimmer)
          SizedBox(height: 5),

        if (showDescriptionShimmer) // Conditionally show the text shimmer
          CustomShimmer(
            context: context,
            width: double.infinity,
            height: 20,
          ),
      ],
    );
  }
}