import 'dart:convert';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/api/response/postcard_data_response.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/postcard_shimmer.dart';
import '../../../../helpers/base64Validator.dart';

class PostcardsGrid extends StatelessWidget {
  final ScrollController listScrollController;
  final List<PostcardsDataResponse>? postcardsData;
  final Function refreshCallback;
  final BuildContext parentContext;
  final bool isLoadingMore;
  final void Function(PostcardsDataResponse postcard)? postcardPopup;
  final bool obfuscateData;

  PostcardsGrid({
    super.key,
    required this.listScrollController,
    required this.postcardsData,
    required this.refreshCallback,
    required this.parentContext,
    required this.isLoadingMore,
    required this.postcardPopup,
    this.obfuscateData = false,
  }) {}

  @override
  Widget build(BuildContext context) {
    int itemCount = postcardsData?.length ?? 0;
    if (isLoadingMore) {
      itemCount += 12;
    }

    return RefreshIndicator(
      onRefresh: () async {
        refreshCallback.call();
      },
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: GridView.builder(
        controller: listScrollController,
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
              onTap: () => postcardPopup?.call(
                postcard!,
              ),
              child: Column(
                children: <Widget>[
                  if (postcardImageBase64 != null &&
                      isBase64Valid(postcardImageBase64))
                    //if (postcardImageBase64 != null)
                    AspectRatio(
                      aspectRatio: 1, // 1:1 square
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: obfuscateData
                            ? ColorFiltered(
                                colorFilter: const ColorFilter.mode(
                                    Colors.grey, BlendMode.saturation),
                                child: CachedMemoryImage(
                                  uniqueKey: postcard!.id.toString(),
                                  errorWidget: const Text('Error'),
                                  bytes: base64Decode(postcardImageBase64!),
                                  fit: BoxFit.contain,
                                ),
                              )
                            : CachedMemoryImage(
                                uniqueKey: postcard!.id.toString(),
                                errorWidget: const Text('Error'),
                                bytes: base64Decode(postcardImageBase64!),
                                fit: BoxFit.contain,
                              ),
                      ),
                    )
                  else
                    AspectRatio(
                      aspectRatio: 1, // 1:1 square
                      child: obfuscateData
                          ? ColorFiltered(
                              colorFilter: const ColorFilter.mode(
                                  Colors.grey, BlendMode.saturation),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: SvgPicture.asset(
                                    "assets/postcards/First.svg",
                                    fit: BoxFit.contain),
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                  "assets/postcards/First.svg",
                                  fit: BoxFit.contain),
                            ),
                    ),
                  Flexible(
                    child: Text(
                      postcard?.title ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      "${postcard?.country ?? ''}, ${postcard?.city ?? ''}",
                      overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}
