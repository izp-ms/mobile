import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/api/response/postcard_data_response.dart';
import 'package:mobile/cubit/postcard_cubit/postcard_cubit.dart';
import 'package:mobile/pages/postcards_page/user_postcards_collection_page/widgets/postcard_details.dart';
import 'package:mobile/pages/postcards_page/user_postcards_collection_page/widgets/postcard_shimmer.dart';

class PostcardsGrid extends StatelessWidget {
  final listScrollController = ScrollController();
  final List<PostcardsDataResponse>? postcardsData;
  final Function refreshCallback;
  final BuildContext parentContext;
  final bool isLoadingMore;

  PostcardsGrid({super.key,
    required this.postcardsData,
    required this.refreshCallback,
    required this.parentContext,
    required this.isLoadingMore,
  }) {
    setupScrollController();
  }

  void setupScrollController() {
    listScrollController.addListener(() {
      if (listScrollController.position.atEdge) {
        if (listScrollController.position.pixels != 0) {
          BlocProvider.of<PostcardCubit>(parentContext).getPostcardData();
        }
      }
    });
  }

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
              onTap: () {
                _showImageDialog(context, postcard!);
              },
              child: Column(
                children: <Widget>[
                  // if (postcardImageBase64 != null &&
                  //     isBase64Valid(postcardImageBase64))
                  if (postcardImageBase64 != null)
                    AspectRatio(
                      aspectRatio: 1, // 1:1 square
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Image.memory(
                          base64Decode(postcardImageBase64),
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  else
                    AspectRatio(
                      aspectRatio: 1, // 1:1 square
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: SvgPicture.asset("assets/postcards/First.svg",
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


void _showImageDialog(BuildContext context, PostcardsDataResponse? postcard) {
  double width = MediaQuery.of(context).size.width * 0.9;
  double height = MediaQuery.of(context).size.height * 0.75;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return PostcardDetails(width: width, height: height, postcard: postcard);
    },
  );
}