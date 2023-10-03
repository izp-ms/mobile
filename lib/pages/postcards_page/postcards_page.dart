import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/cubit/postcard_cubit/postcard_cubit.dart';
import 'package:mobile/cubit/postcard_cubit/postcard_state.dart';
import 'package:mobile/custom_widgets/custom_drawer/custom_drawer.dart';
import 'package:mobile/custom_widgets/custom_appbars/main_page_app_bar.dart';
import 'package:mobile/custom_widgets/text_icon_button.dart';
import 'package:mobile/helpers/show_error_snack_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostcardsPage extends StatefulWidget {
  const PostcardsPage({super.key});

  @override
  State<PostcardsPage> createState() => _PostcardsPageState();
}

class _PostcardsPageState extends State<PostcardsPage> {
  bool showFirstPage = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<PostcardCubit>();
      cubit.getPostcardData();
    });
  }

  Future _refresh() async {
    context.read<PostcardCubit>().getPostcardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainPageAppBar(),
      drawer: CustomDrawer(context),
      body: BlocConsumer<PostcardCubit, PostcardState>(
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
                Text(
                  showFirstPage
                ? 'First'
                : 'Second',
                  //AppLocalizations.of(context).favouritePostcards,
                  style: GoogleFonts.rubik(
                    fontSize: 18,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextIconButton(
                        text: AppLocalizations.of(context).sortBy,
                        shouldHaveIcon: true,
                        iconData: Icons.sort,
                        iconSide: IconSide.left,
                        onTap: () {
                          print("Sort");
                        },
                        fontSize: 15.0,
                        iconSize: 20.0,
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                      TextIconButton(
                        text: AppLocalizations.of(context).filters,
                        shouldHaveIcon: true,
                        iconData: Icons.filter_alt_outlined,
                        iconSide: IconSide.right,
                        onTap: () {
                          print("filter");
                        },
                        fontSize: 15.0,
                        iconSize: 20.0,
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showFirstPage = true;
                    });
                  },
                  child: Text('First Page', style: TextStyle(color: Colors.black),),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showFirstPage = false;
                    });
                  },
                  child: Text('Second Page', style: TextStyle(color: Colors.black),),
                ),
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 32,
                    mainAxisSpacing: 20,
                    childAspectRatio: 3 / 4,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: showFirstPage ? 12 : 6,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(7),
                        child: SvgPicture.asset(showFirstPage
                            ? 'assets/postcards/First.svg'
                            : 'assets/postcards/Second.svg'),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
