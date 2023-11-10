import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/cubit/user_cubit/user_cubit.dart';
import 'package:mobile/cubit/user_cubit/user_state.dart';
import 'package:mobile/custom_widgets/custom_drawer/custom_drawer.dart';
import 'package:mobile/custom_widgets/custom_appbars/main_page_app_bar.dart';
import 'package:mobile/helpers/show_error_snack_bar.dart';
import 'package:mobile/pages/edit_user_details_page/edit_user_details_page.dart';
import 'package:mobile/pages/profile_page/profile_page_widgets/personal_info_section/personal_info_section.dart';
import 'package:mobile/pages/profile_page/profile_page_widgets/profile_pictures_stack/profile_pictures_stack.dart';
import 'package:mobile/pages/profile_page/profile_page_widgets/statistics_section/statistics_section.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<UserCubit>();
      cubit.getUserDetail();
    });
  }

  Future _refresh() async {
    context.read<UserCubit>().getUserDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainPageAppBar(),
      drawer: CustomDrawer(context),
      body: BlocConsumer<UserCubit, UserState>(
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
                      const ProfilePicturesStack(),
                      GestureDetector(
                        onTap: () => {
                          if (state is LoadedState)
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditUserDetailsPage(
                                    userDetail: state.userDetail,
                                  ),
                                ),
                              ),
                            }
                          else
                            {print("State is not loaded")}
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 15, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                Icons.mode_edit_outlined,
                                size: 15,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                AppLocalizations.of(context).editProfile,
                                style: GoogleFonts.rubik(
                                  fontSize: 10,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      const PersonalInfoSection(),
                      const StatisticsSection(),
                    ],
                  ),
                ),
                // Container(
                //   padding: const EdgeInsets.all(30),
                //   child: Column(
                //     children: [
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(
                //             AppLocalizations.of(context).favouritePostcards,
                //             style: GoogleFonts.rubik(
                //               fontSize: 18,
                //             ),
                //           ),
                //           GestureDetector(
                //             onTap: () {
                //               if (state is LoadedState) {
                //                 final favouritePostcards =
                //                     state.favouritePostcards;
                //                 final content = favouritePostcards.content;
                //                 if (content != null && content.isNotEmpty) {
                //                   for (var postcard in content) {
                //                     print(postcard.toString());
                //                   }
                //                 } else {
                //                   print("Favorite postcards content is empty.");
                //                 }
                //               }
                //             },
                //             child: Row(
                //               children: [
                //                 const Icon(
                //                   Icons.mode_edit_outlined,
                //                   size: 15,
                //                 ),
                //                 const SizedBox(
                //                   width: 3,
                //                 ),
                //                 Text(
                //                   AppLocalizations.of(context).editFavourite,
                //                   style: GoogleFonts.rubik(
                //                     fontSize: 10,
                //                   ),
                //                 )
                //               ],
                //             ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                // if (state is LoadedState)
                //   FavouritePostcardsGrid(
                //       postcardsData: state.favouritePostcards.content,
                //       refreshCallback: _refresh,
                //       parentContext: context,
                //       postcardPopup: (postcard) {
                //         showPostcardDialog(context, postcard!);
                //       },)
                // else
                //   PostcardsListShimmer(
                //     itemCount: 6,
                //     crossAxisCount: 3,
                //     showDescription: false,
                //   )
              ],
            ),
          );
        },
      ),
    );
  }
}
