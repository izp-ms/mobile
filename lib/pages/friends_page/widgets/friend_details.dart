import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/api/response/friend_response.dart';
import 'package:mobile/cubit/friends_cubit/all_friends_cubit/all_friends_cubit.dart';
import 'package:mobile/cubit/friends_cubit/followed_by_cubit/followed_by_cubit.dart';
import 'package:mobile/cubit/friends_cubit/following_cubit/following_cubit.dart';
import 'package:mobile/cubit/friends_cubit/friend_favourite_postcards_cubit/friends_cubit.dart';
import 'package:mobile/cubit/friends_cubit/friend_favourite_postcards_cubit/friends_state.dart';
import 'package:mobile/custom_widgets/custom_shimmer/custom_shimmer.dart';
import 'package:mobile/custom_widgets/submit_button.dart';
import 'package:mobile/helpers/base64Validator.dart';
import 'package:mobile/helpers/date_extractor.dart';
import 'package:mobile/helpers/formatDateString.dart';
import 'package:mobile/helpers/shared_preferences.dart';
import 'package:mobile/helpers/show_error_snack_bar.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/postcard_shimmer.dart';
import 'package:mobile/pages/postcards_page/widgets/postcard_details.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/pages/profile_page/profile_page_widgets/favourite_postcards_grid.dart';
import 'package:mobile/pages/profile_page/profile_page_widgets/personal_info_section/personal_info_section_widgets/about_me_section.dart';
import 'package:mobile/pages/profile_page/profile_page_widgets/personal_info_section/personal_info_section_widgets/row_with_icon.dart';
import 'package:mobile/pages/profile_page/profile_page_widgets/personal_info_section/personal_info_section_widgets/user_name_section/shimmer.dart';
import 'package:mobile/pages/profile_page/profile_page_widgets/personal_info_section/personal_info_section_widgets/user_name_section/user_name_section.dart';
import 'package:mobile/pages/profile_page/profile_page_widgets/statistics_section/statistic_section_data.dart';
import 'package:mobile/pages/profile_page/profile_page_widgets/statistics_section/statistics_shimmer.dart';

class FriendDetails extends StatefulWidget {
  final int friendID;

  FriendDetails({
    Key? key,
    required this.friendID,
  }) : super(key: key);

  @override
  _FriendDetailsState createState() => _FriendDetailsState();
}

class _FriendDetailsState extends State<FriendDetails> {
  String? dateFormatPreference;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cubit = context.read<FriendsCubit>();
      cubit.getFriendDetails(widget.friendID);
      dateFormatPreference = await AppSharedPreferences.getDatePreference();
    });
  }

  Future _refresh() async {
    context.read<FriendsCubit>().getFriendDetails(widget.friendID);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final imageSize = (deviceSize.width - 60) * 0.4;
    final borderRadius = BorderRadius.circular((imageSize - 10) * 0.5);

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
      body: BlocConsumer<FriendsCubit, FriendsState>(
        listener: (context, state) {
          if (state is ErrorState) {
            showErrorSnackBar(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: _refresh,
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: ListView(
              children: [
                Container(
                  constraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                    maxWidth: double.infinity,
                    maxHeight: double.infinity,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: [

                      if(state is LoadedState)...[
                        AspectRatio(
                          aspectRatio: 2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child:

                            isBase64Valid(state.friendResponse.backgroundBase64)
                              ? Image.memory(
                            base64Decode(state.friendResponse.backgroundBase64!),
                            fit: BoxFit.cover,
                          )
                              : Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Theme.of(context).colorScheme.surface,
                                  Theme.of(context).colorScheme.secondaryContainer,
                                ],
                              ),
                            ),
                          ),
                          ),
                        ),
                      ]
                      else...[
              AspectRatio(
              aspectRatio: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CustomShimmer(
                  context: context,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            )
                      ],





              if(state is LoadedState)...[
                Positioned(
                  top: (deviceSize.width - 40) * 0.3,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: imageSize,
                        width: imageSize,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          shape: BoxShape.circle,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: borderRadius,
                        child:
                        SizedBox(
                          height: imageSize - 10,
                          width: imageSize - 10,
                          child: (isBase64Valid(state.friendResponse.avatarBase64))
                              ? Image.memory(
                            base64Decode(state.friendResponse.avatarBase64!),
                            fit: BoxFit.cover,
                          )
                              : Image.asset(
                            'assets/profile_background_placeholder.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]
          else...[
                Positioned(
                  top: (deviceSize.width - 40) * 0.3,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: imageSize,
                        width: imageSize,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          shape: BoxShape.circle,
                        ),
                      ),
          ClipRRect(
          borderRadius: borderRadius,
          child: SizedBox(
          width: imageSize - 10,
          height: imageSize - 10,
          child: CustomShimmer(
          context: context,
          ),
          ),
          ),
                    ],
                  ),
                ),
              ],








                      if (state is LoadedState)...[
                        SizedBox(width: 15,),
                        Positioned(
                          top: 20,
                          child: SubmitButton(
                            buttonText: state.isFollowing ? "unfollow": "follow",
                            height: 40,
                            onButtonPressed: () => {
                              refreshFriends(state, context)
                            },
                          ),
                        ),
                        SizedBox(width: 15,),
                      ],

                    ],
                  ),













              SizedBox(height: 70,),



              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (state is LoadedState) ...[
                    UserNamesSection(
                      nickName: state.friendResponse.nickName ?? "",
                      firstName: state.friendResponse.firstName ?? null,
                      lastName: state.friendResponse.lastName ?? null,
                    ),
                  ]
                  else ...[
                    UserNamesSectionShimmer(context: context)
                  ],




                  const SizedBox(
                    height: 12,
                  ),
              if (state is LoadedState) ...[
                    if (state.friendResponse.birthDate != null && dateFormatPreference != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: RowWithIcon(
                          icon: Icons.cake_outlined,
                          text: formatDateString(
                              dateExtractor(state.friendResponse.birthDate.toString())!,
                              dateFormatPreference!),
                        ),
                      ),
                    if (state.friendResponse.country != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: RowWithIcon(
                          icon: Icons.flag,
                          text: state.friendResponse.country!,
                        ),
                      ),
                    if (state.friendResponse.description != null && state.friendResponse.description!.isNotEmpty)
                      AboutMeSection(description: state.friendResponse.description!)
                ],
          ],
              ),



              if (state is LoadedState) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 28,0,12),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatisticsSectionData(
                            dataTitle: AppLocalizations.of(context).postcards,
                            dataValue: state.friendResponse.postcardsCount ?? 0,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          StatisticsSectionData(
                            dataTitle: AppLocalizations.of(context).followers,
                            dataValue: state.friendResponse.followersCount ?? 0,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          StatisticsSectionData(
                            dataTitle: AppLocalizations.of(context).following,
                            dataValue: state.friendResponse.followingCount ?? 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
]
                  else...[
          UserStatisticsShimmer(context: context)
                    ],


                    ],
                  ),
                ),

                if (state is! LoadedState)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Favourite postcards",
                              style: GoogleFonts.rubik(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child:
                                PostcardShimmer(showDescriptionShimmer: false),
                          );
                        },
                        shrinkWrap: true,
                        physics:
                            NeverScrollableScrollPhysics(), // Disable scrolling
                      ),
                    ],
                  ),


                if (state is LoadedState &&
                    state.favouritePostcards.content!.length > 0)...[
                  Container(
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context).favouritePostcards,
                              style: GoogleFonts.rubik(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  FavouritePostcardsGrid(
                    postcardsData: state.favouritePostcards.content,
                    refreshCallback: _refresh,
                    parentContext: context,
                    postcardPopup: (postcard) {
                      showPostcardDialog(context, postcard,
                          isFriendPostcard: true);
                    },
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> refreshFriends(state, BuildContext context) async {
    await context
        .read<FriendsCubit>()
        .updateFollowing(!state.isFollowing, state.friendResponse.id, state.favouritePostcards, state.friendResponse);

    context.read<FollowedByCubit>().clearFollowedBy();
    context.read<FollowedByCubit>().currentPage = 1;
    context
        .read<FollowedByCubit>()
        .getFollowedBy("", "nickName");

    context.read<FollowingCubit>().clearFollowing();
    context.read<FollowingCubit>().currentPage = 1;
    context
        .read<FollowingCubit>()
        .getFollowing("", "nickName");
  }
}
