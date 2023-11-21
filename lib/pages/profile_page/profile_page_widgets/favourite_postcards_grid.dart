import 'dart:convert';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/api/response/postcard_response.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/postcard_shimmer.dart';
import '../../../helpers/base64Validator.dart';

class FavouritePostcardsGrid extends StatelessWidget {
  final List<PostcardsResponse>? postcardsData;
  final Function refreshCallback;
  final BuildContext parentContext;
  final void Function(PostcardsResponse postcard)? postcardPopup;

  FavouritePostcardsGrid({
    super.key,
    required this.postcardsData,
    required this.refreshCallback,
    required this.parentContext,
    required this.postcardPopup,
  }) {}

  @override
  Widget build(BuildContext context) {
    int itemCount = postcardsData?.length ?? 0;

    return RefreshIndicator(
      onRefresh: () async {
        refreshCallback.call();
      },
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.7,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (index < (postcardsData?.length ?? 0)) {
            final postcard = postcardsData?[index];
            final postcardImageBase64 = postcard?.imageBase64?.substring(23);
            return GestureDetector(
              onTap: () {
                if (postcard != null) {
                  postcardPopup?.call(postcard);
                }
              },
              child: Column(
                children: <Widget>[
                  if (postcardImageBase64 != null &&
                      isBase64Valid(postcardImageBase64))
                  //if (postcardImageBase64 != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                      child: AspectRatio(
                        aspectRatio: 3/4,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: CachedMemoryImage(
                            uniqueKey: postcard!.id.toString(),
                            errorWidget: const Text('Error'),
                            bytes: base64Decode(postcardImageBase64!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  else
                    AspectRatio(
                      aspectRatio: 1, // 1:1 square
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: SvgPicture.asset(
                            "assets/postcards/First.svg",
                            fit: BoxFit.cover),
                      ),
                    ),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: PostcardShimmer(),
            );
          }
        },
        shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    ),
    );
  }
}
