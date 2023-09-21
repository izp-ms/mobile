import 'package:flutter/material.dart';
import 'package:mobile/custom_widgets/custom_shimmer/custom_shimmer.dart';

class UserNamesSectionShimmer extends StatelessWidget {
  const UserNamesSectionShimmer({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomShimmer(
          context: context,
          width: 250,
          height: 32,
        ),
        const SizedBox(
          height: 17,
        ),
        CustomShimmer(
          context: context,
          width: 150,
          height: 20,
        ),
      ],
    );
  }
}