import 'package:flutter/material.dart';
import 'package:mobile/custom_widgets/custom_shimmer/custom_shimmer.dart';

class PostcardShimmer extends StatelessWidget {
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
        SizedBox(height: 5),

        // Shimmer for text
        CustomShimmer(
          context: context,
          width: double.infinity,
          height: 20,
        )
      ],
    );
  }
}
