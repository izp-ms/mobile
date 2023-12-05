import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobile/api/request/postcard_transfer_request.dart';
import 'package:mobile/api/request/register_request.dart';
import 'package:mobile/api/response/friend_response.dart';
import 'package:mobile/api/response/postcard_response.dart';
import 'package:mobile/cubit/friends_cubit/all_friends_cubit/all_friends_cubit.dart';
import 'package:mobile/cubit/friends_cubit/all_friends_cubit/all_friends_state.dart';
import 'package:mobile/custom_widgets/custom_form_filed/styled.dart';
import 'package:mobile/custom_widgets/submit_button.dart';
import 'package:mobile/helpers/date_extractor.dart';
import 'package:mobile/helpers/show_error_snack_bar.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/SortDialog.dart';
import 'package:mobile/pages/friends_page/widgets/friend_details.dart';
import 'package:mobile/pages/friends_page/widgets/friends_grid.dart';
import 'package:mobile/pages/friends_page/widgets/friends_list_shimmer.dart';
import 'package:mobile/services/secure_storage_service.dart';


class TransferPostcard extends StatefulWidget {
  final PostcardsResponse postcard;

  TransferPostcard({
    Key? key,
    required this.postcard,
  }) : super(key: key);

  @override
  _TransferPostcardState createState() => _TransferPostcardState();
}

class _TransferPostcardState extends State<TransferPostcard> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;



  @override
  void initState() {
    super.initState();
    context.read<AllFriendsCubit>().clearAllFriends();
    context.read<AllFriendsCubit>().currentPage = 1;
    context
        .read<AllFriendsCubit>()
        .getAllFriends(search, orderBy);
  }

  Future _refresh() async {
    setState(() {
      selectedFriendIndex = null;
      selectedFriendId = null;
    });
    context.read<AllFriendsCubit>().clearAllFriends();
    context.read<AllFriendsCubit>().currentPage = 1;
    context
        .read<AllFriendsCubit>()
        .getAllFriends(search, orderBy);
  }

  bool isLoadingMore = false;
  final listScrollController = ScrollController();

  void setupScrollController(bool isSent) {
    listScrollController.addListener(() {
      if (listScrollController.position.atEdge) {
        if (listScrollController.position.pixels != 0) {
          BlocProvider.of<AllFriendsCubit>(context).getAllFriends(
              search, orderBy);
        }
      }
    });
  }

  String search = ""; //Palmiarnia
  String orderBy = "nickName"; //-city
  TextEditingController searchController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();


  int? selectedFriendIndex = null;
  int? selectedFriendId = null;

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
    final deviceSize = MediaQuery.of(context).size;
    final imageSize = (deviceSize.width - 60) * 0.4;
    final borderRadius = BorderRadius.circular((imageSize - 10) * 0.5);
    setupScrollController(false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: Stack(
        children: [Column(

          children: [
            Text(
              "Edit postcard details",
              style: TextStyle(
                fontSize: 25, // Customize the font size as needed
                fontWeight: FontWeight.bold, // Customize the font weight as needed
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: titleController,
                onChanged: (value) {
                  setState(() {
                    search = value;
                  });
                },
                maxLength: 50,
                decoration: customTextFieldDecoration(
                    context, "Choose title", null),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextFormField(
                controller: descriptionController,
                onChanged: (value) {
                  setState(() {
                    search = value;
                  });
                },
                maxLength: 280,
                maxLines: 2, // Set the maximum number of lines
                minLines: 2, // Set the minimum number of lines
                decoration: customTextFieldDecoration(context, "Choose description", null),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Choose postcard receiver",
              style: TextStyle(
                fontSize: 25, // Customize the font size as needed
                fontWeight: FontWeight.bold, // Customize the font weight as needed
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 10,
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
                        context, "Find someone!", Icons.search),
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
            BlocConsumer<AllFriendsCubit, AllFriendsState>(
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
                    ),
                  );
                }

                if (state is LoadingState && state.isFirstFetch) {
                  return Flexible(
                    child: FriendListShimmer(
                      itemCount: 8,
                      crossAxisCount: 1,
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
                    selectedFriendIndex: selectedFriendIndex,
                    friendPopup: (friend) {
                      setState(() {
                        if(selectedFriendIndex == postcardsData?.indexOf(friend))
                          {
                            selectedFriendIndex = null;
                            selectedFriendId = null;
                          }
                        else
                          {
                            selectedFriendIndex = postcardsData?.indexOf(friend);
                            selectedFriendId = friend.id;
                          }
                      });
                    },
                  ),
                );
              },
            ),
          ],
        ),

          Positioned(
            bottom: 25,
            left: 0,
            right: 0,
            child: Center(
              child: Visibility(
                visible: selectedFriendIndex != null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SubmitButton(
                    buttonText: "Send Postcard",
                    onButtonPressed: () {
                      onSendButtonPressed(context);
                    },
                  ),
                ),
              ),
            ),
          ),
    ]
      ),
    );
  }


  Future<void> onSendButtonPressed(BuildContext context) async {

    String title = titleController.text;
    String description = descriptionController.text;

    final token = await SecureStorageService.read(key: 'token');

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    String userIdString = decodedToken[
    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];

    int userId;
    try {
      userId = int.parse(userIdString);
    } catch (e) {
      // Handle the case where userIdString is not a valid integer
      print('Error parsing userId: $e');
      userId = 0; // Default value or any other suitable handling
    }

    PostcardTransferRequest request = PostcardTransferRequest(
      postcardDto: PostcardDto(
        id: widget.postcard.id?? 0,
        title: title,
        content: description,
        postcardDataId: widget.postcard.postcardDataId ?? -1,
        createdAt: dateExtractor(DateTime.now().toString()),
        userId: userId,
        isSent: true,
      ),
      newUserId: selectedFriendId?? 0,
    );

    context.read<AllFriendsCubit>().transferPostcard(request, context);
    Navigator.pop(context);


  }
}
