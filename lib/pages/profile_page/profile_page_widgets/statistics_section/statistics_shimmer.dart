import 'package:flutter/material.dart';
import 'package:mobile/custom_widgets/custom_shimmer/custom_shimmer.dart';

class UserStatisticsShimmer extends StatelessWidget {
  const UserStatisticsShimmer({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            child: FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      CustomShimmer(
                        context: context,
                        width: 150,
                        height: 32,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomShimmer(
                        context: context,
                        width: 32,
                        height: 32,
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      CustomShimmer(
                        context: context,
                        width: 150,
                        height: 32,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomShimmer(
                        context: context,
                        width: 32,
                        height: 32,
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      CustomShimmer(
                        context: context,
                        width: 150,
                        height: 32,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomShimmer(
                        context: context,
                        width: 32,
                        height: 32,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    // return Column(
    //   children: [
    //     CustomShimmer(
    //       context: context,
    //       width: 250,
    //       height: 32,
    //     ),
    //     const SizedBox(
    //       height: 17,
    //     ),
    //     CustomShimmer(
    //       context: context,
    //       width: 150,
    //       height: 20,
    //     ),
    //   ],
    // );
  }
}