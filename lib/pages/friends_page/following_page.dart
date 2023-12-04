import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/api/response/friend_response.dart';
import 'package:mobile/cubit/friends_cubit/following_cubit/following_cubit.dart';
import 'package:mobile/cubit/friends_cubit/following_cubit/following_state.dart';
import 'package:mobile/custom_widgets/custom_form_filed/styled.dart';
import 'package:mobile/helpers/show_error_snack_bar.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/SortDialog.dart';
import 'package:mobile/pages/friends_page/widgets/friend_details.dart';
import 'package:mobile/pages/friends_page/widgets/friends_grid.dart';
import 'package:mobile/pages/friends_page/widgets/friends_list_shimmer.dart';

class FollowingPage extends StatefulWidget {
  const FollowingPage({Key? key}) : super(key: key);

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context.read<FollowingCubit>().clearFollowing();
    context.read<FollowingCubit>().currentPage = 1;
    context
        .read<FollowingCubit>()
        .getFollowing(search, orderBy);
  }

  Future _refresh() async {
    context.read<FollowingCubit>().clearFollowing();
    context.read<FollowingCubit>().currentPage = 1;
    context
        .read<FollowingCubit>()
        .getFollowing(search, orderBy);
  }

  bool isLoadingMore = false;
  final listScrollController = ScrollController();

  void setupScrollController(bool isSent) {
    listScrollController.addListener(() {
      if (listScrollController.position.atEdge) {
        if (listScrollController.position.pixels != 0) {
          BlocProvider.of<FollowingCubit>(context).getFollowing(
              search, orderBy);
        }
      }
    });
  }

  String search = ""; //Palmiarnia
  String orderBy = "date"; //-city
  TextEditingController searchController = TextEditingController();

  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return SortDialog(
          initialOrderBy: orderBy, // Pass the initial sorting option
          onApply: (selectedOrderBy) {
            setState(() {
              orderBy = selectedOrderBy; // Update the orderBy variable
            });
            _refresh(); // Refresh the data with the new sorting option
          },
          options: [
            {'title': 'nickname A-Z', 'value': 'nickName'},
            {'title': 'nickname Z-A', 'value': '-nickName'},
            {'title': 'Country A-Z', 'value': 'country'},
            {'title': 'Country Z-A', 'value': '-country'},
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    setupScrollController(false);
    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: TextFormField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    search = value;
                  });
                },
                onEditingComplete: () {
                  _refresh();
                },
                decoration: customTextFieldDecoration(
                    context, "Search", Icons.search),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            GestureDetector(
              onTap: () {
                _showSortDialog(context);
              },
              child: Icon(
                Icons.sort_by_alpha,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            SizedBox(
              width: 15,
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        BlocConsumer<FollowingCubit, FollowingState>(
          listener: (context, state) {
            if (state is ErrorState) {
              showErrorSnackBar(context, state.errorMessage);
            }
          },
          builder: (context, state) {
            if (state is ErrorState) {
              return Flexible(
                child: FriendListShimmer(
                  itemCount: 8,
                  crossAxisCount: 1,
                  title: "Following Users",
                ),
              );
            }

            if (state is LoadingState && state.isFirstFetch) {
              return Flexible(
                child: FriendListShimmer(
                  itemCount: 8,
                  crossAxisCount: 1,
                  title: "Following Users",
                ),
              );
            }

            List<FriendResponse>? postcardsData = [];
            isLoadingMore = false;

            if (state is LoadingState) {
              postcardsData = state.oldFriendsData.content;
              if (postcardsData!.length <
                  (state.oldFriendsData.totalCount ?? 0)) {
                isLoadingMore = true;
              }
            } else if (state is LoadedState) {
              postcardsData = state.friendsData.content;
            }

            return Flexible(
              child: FriendsGrid(
                listScrollController: listScrollController,
                friendsData: postcardsData,
                refreshCallback: _refresh,
                parentContext: context,
                isLoadingMore: isLoadingMore,
                friendPopup: (friend) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FriendDetails(friendID: friend.id!)),
                  );
                },
                title: "Following Users",
              ),
            );
          },
        ),
      ],
    );
  }
}
