import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/api/response/postcard_data_response.dart';
import 'package:mobile/pages/collect_postcard_list_page/collect_postcard_page_widgets/postcard_card_nearby.dart';
import 'package:mobile/pages/collect_postcard_list_page/collect_postcard_page_widgets/postcard_card_to_collect.dart';

class PostcardListWithTitle extends StatelessWidget {
  const PostcardListWithTitle({
    super.key,
    required this.title,
    required this.postcards,
    this.isReadyToCollect = false,
  });

  final String title;
  final List<PostcardsDataResponse> postcards;
  final bool isReadyToCollect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            title,
            style: GoogleFonts.rubik(
              fontSize: 25,
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: postcards.length,
          itemBuilder: (BuildContext context, int index) {
            final postcard = postcards[index];
            if (isReadyToCollect) {
              return PostcardCardToCollect(
                postcard: postcard,
              );
            }
            return PostcardCardNearby(
              postcard: postcard,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 10);
          },
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
