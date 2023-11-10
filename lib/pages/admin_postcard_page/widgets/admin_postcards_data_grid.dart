import 'dart:convert';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/api/response/postcard_data_response.dart';
import 'package:mobile/helpers/base64Validator.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/postcard_shimmer.dart';

class AdminPostcardsDataGrid extends StatelessWidget {
  final ScrollController listScrollController;
  final List<PostcardsDataResponse>? postcardsData;
  final Function refreshCallback;
  final BuildContext parentContext;
  final bool isLoadingMore;
  final void Function(PostcardsDataResponse postcard)? postcardPopup;

  const AdminPostcardsDataGrid({
    super.key,
    required this.listScrollController,
    required this.postcardsData,
    required this.refreshCallback,
    required this.parentContext,
    required this.isLoadingMore,
    required this.postcardPopup,
  });

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
      child: CustomScrollView(
        controller: listScrollController,
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              const Center(
                child: Text(
                  "Admin Panel",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ]),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 100),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.7,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index < (postcardsData?.length ?? 0)) {
                    final postcard = postcardsData?[index];
                    final postcardImageBase64 =
                        postcard?.imageBase64?.substring(23);
                    return GestureDetector(
                      onTap: () => postcardPopup?.call(postcard!),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Column(
                          children: [
                            if (postcardImageBase64 != null &&
                                isBase64Valid(postcardImageBase64))
                              Padding(
                                padding: const EdgeInsets.fromLTRB(18,18,18,0),
                                child: AspectRatio(
                                  aspectRatio: 3/4,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: CachedMemoryImage(
                                      uniqueKey: postcard!.id.toString() +
                                          postcard.createdAt.toString(),
                                      errorWidget: const Text('Error'),
                                      bytes: base64Decode(postcardImageBase64!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                            else
                              AspectRatio(
                                aspectRatio: 1,
                                child: Container(
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
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: PostcardShimmer(),
                    );
                  }
                },
                childCount: itemCount,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
