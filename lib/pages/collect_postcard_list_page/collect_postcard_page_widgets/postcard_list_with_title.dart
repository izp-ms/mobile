import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/api/response/postcard_data_response.dart';
import 'package:mobile/pages/collect_postcard_list_page/collect_postcard_page_widgets/postcard_list_card.dart';

class PostcardListWithTitle extends StatelessWidget {
  const PostcardListWithTitle({
    super.key,
    required this.title,
    required this.postcards,
  });

  final String title;
  final List<PostcardsDataResponse> postcards;

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

            return PostcardListCard(
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
