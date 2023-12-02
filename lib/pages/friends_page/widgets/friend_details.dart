import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/api/response/friend_response.dart';
import 'package:mobile/cubit/friends_cubit/friend_favourite_postcards_cubit/friends_cubit.dart';
import 'package:mobile/cubit/friends_cubit/friend_favourite_postcards_cubit/friends_state.dart';
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
import 'package:mobile/pages/profile_page/profile_page_widgets/personal_info_section/personal_info_section_widgets/user_name_section/user_name_section.dart';
import 'package:mobile/pages/profile_page/profile_page_widgets/statistics_section/statistic_section_data.dart';

class FriendDetails extends StatefulWidget {
  final FriendResponse friend;

  FriendDetails({
    Key? key,
    required this.friend,
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
      cubit.getFriendFavouritePostcards(widget.friend.id);
      dateFormatPreference = await AppSharedPreferences.getDatePreference();
    });
  }

  Future _refresh() async {
    context.read<FriendsCubit>().getFriendFavouritePostcards(widget.friend.id);
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
                    AspectRatio(
                    aspectRatio: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
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
                            height: imageSize - 10,
                            width: imageSize - 10,
                            child: (isBase64Valid(widget.friend.avatarBase64))
                                ? Image.memory(
                              base64Decode(widget.friend.avatarBase64!),
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
                      if (state is LoadedState)...[
                        SizedBox(width: 15,),
                        Positioned(
                          top: 20,
                          child: SubmitButton(
                            buttonText: state.isFollowing ? "follow": "unfollow",
                            height: 40,
                            onButtonPressed: () => {
                              context
                                  .read<FriendsCubit>()
                                  .updateFollowing(!state.isFollowing, widget.friend.id, state.favouritePostcards)
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
                UserNamesSection(
                nickName: widget.friend.nickName ?? "",
                firstName: widget.friend.firstName ?? null,
                lastName: widget.friend.lastName ?? null,
              ),
                  const SizedBox(
                    height: 12,
                  ),

                    if (widget.friend.birthDate != null && dateFormatPreference != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: RowWithIcon(
                          icon: Icons.cake_outlined,
                          text: formatDateString(
                              dateExtractor(widget.friend.birthDate.toString())!,
                              dateFormatPreference!),
                        ),
                      ),
                    if (widget.friend.country != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: RowWithIcon(
                          icon: Icons.flag,
                          text: widget.friend.country!,
                        ),
                      ),
                    if (widget.friend.description != null && widget.friend.description!.isNotEmpty)
                      AboutMeSection(description: widget.friend.description!)
                ],
              ),




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
                            dataValue: widget.friend.postcardsCount ?? 0,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          StatisticsSectionData(
                            dataTitle: AppLocalizations.of(context).followers,
                            dataValue: widget.friend.followersCount ?? 0,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          StatisticsSectionData(
                            dataTitle: AppLocalizations.of(context).following,
                            dataValue: widget.friend.followingCount ?? 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),



                    ],
                  ),
                ),

                if (state is LoadingState)
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
}
