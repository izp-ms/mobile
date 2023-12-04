import 'dart:convert';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/api/response/friend_response.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/postcard_shimmer.dart';
import 'package:mobile/pages/friends_page/widgets/friend_shimmer.dart';
import '../../../../helpers/base64Validator.dart';

class FriendsGrid extends StatelessWidget {
  final ScrollController listScrollController;
  final List<FriendResponse>? friendsData;
  final Function refreshCallback;
  final BuildContext parentContext;
  final bool isLoadingMore;
  final void Function(FriendResponse friend)? friendPopup;
  final String title;

  FriendsGrid({
    Key? key,
    required this.listScrollController,
    required this.friendsData,
    required this.refreshCallback,
    required this.parentContext,
    required this.isLoadingMore,
    required this.friendPopup,
    this.title = "",
  });

  @override
  Widget build(BuildContext context) {
    int itemCount = friendsData!.length ?? 0;
    if (isLoadingMore) {
      itemCount += 8;
    }

    return RefreshIndicator(
      onRefresh: () async {
        refreshCallback.call();
      },
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: CustomScrollView(
        controller: listScrollController,
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              if (title != "")
                Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ]),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, childAspectRatio: 4),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index < (friendsData?.length ?? 0)) {
                  final friend = friendsData?[index];
                  final friendImageBase64 = friend?.avatarBase64?.substring(0);
                  print(friend?.avatarBase64 ?? "");
                  print(friendImageBase64);
                  return Container(
                    height: 100,
                    child: GestureDetector(
                      onTap: () => friendPopup?.call(
                        friend!,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              if (friendImageBase64 != null &&
                                  isBase64Valid(friendImageBase64))
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: 100, // Set maximum height
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 1, // 1:1 square
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: ClipOval(
                                        child: Image.memory(
                                          base64Decode(friendImageBase64!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              else
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: 100, // Set maximum height
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 1, // 1:1 square
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: ClipOval(
                                        child: Image.asset(
                                          'assets/profile_background_placeholder.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      friend?.nickName ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.rubik(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      "${friend?.firstName ?? '---'} ${friend?.lastName ?? '---'}",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Icon(
                              Icons.search,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: FriendShimmer(),
                  );
                }
              },
              childCount: itemCount,
            ),
          ),
        ],
      ),
    );
  }
}
