import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/custom_widgets/custom_drawer/custom_drawer.dart';
import 'package:mobile/custom_widgets/main_page_app_bar.dart';
import 'package:mobile/pages/profile_page/profile_page_widgets/personal_info_section.dart';
import 'package:mobile/pages/profile_page/profile_page_widgets/profile_pictures_stack/profile_pictures_stack.dart';
import 'package:mobile/pages/profile_page/profile_page_widgets/statistics_section/statistics_section.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainPageAppBar(),
      drawer: CustomDrawer(context),
      body: ListView(
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
            padding: const EdgeInsets.fromLTRB(30,10,30,30),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ProfilePicturesStack(),
                SizedBox(
                  height: 70,
                ),
                PersonalInfoSection(),
                StatisticsSection(),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context).favouritePostcards,
                  style: GoogleFonts.rubik(
                    fontSize: 18,
                  ),
                ),
                GestureDetector(
                  onTap: () => {
                    print("Navigacja do modala do edytowania pocztówek")
                  },
                  child: Row(
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
                )
              ],
            ),
          ),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Number of columns in the GridView
              crossAxisSpacing: 32,
              mainAxisSpacing: 20,
              childAspectRatio: 3/4,

            ),
            padding: const EdgeInsets.symmetric(horizontal: 30),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 9,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                color: Colors.white,
                child:
                  Padding(
                    padding: const EdgeInsets.all(7),
                    child: SvgPicture.asset('assets/postcards/First.svg'),
                  )
              );
            },
          ),
        ],
      ),
    );
  }
}
