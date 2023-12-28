import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/api/response/postcard_response.dart';
import 'package:mobile/cubit/postcards_cubits/received_postcards_cubit/received_postcards_cubit.dart';
import 'package:mobile/cubit/postcards_cubits/received_postcards_cubit/received_postcards_state.dart';
import 'package:mobile/custom_widgets/custom_form_filed/styled.dart';
import 'package:mobile/helpers/show_error_snack_bar.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/FilterDialog.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/SortDialog.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/postcards_list_shimmer.dart';
import 'package:mobile/pages/postcards_page/widgets/postcard_details.dart';
import 'package:mobile/pages/postcards_page/widgets/postcards_grid.dart';

class ReceivedPostcardsPage extends StatefulWidget {
  const ReceivedPostcardsPage({Key? key}) : super(key: key);

  @override
  State<ReceivedPostcardsPage> createState() => _ReceivedPostcardsPageState();
}

class _ReceivedPostcardsPageState extends State<ReceivedPostcardsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<int> favouritePostcards = [];

  @override
  void initState() {
    super.initState();
    context.read<ReceivedPostcardsCubit>().clearReceivedPostcards();
    context.read<ReceivedPostcardsCubit>().currentPage = 1;
    context
        .read<ReceivedPostcardsCubit>()
        .getPostcards(true, search, city, country, dateFrom, dateTo, orderBy);
  }

  Future _refresh() async {
    context.read<ReceivedPostcardsCubit>().clearReceivedPostcards();
    context.read<ReceivedPostcardsCubit>().currentPage = 1;
    context
        .read<ReceivedPostcardsCubit>()
        .getPostcards(true, search, city, country, dateFrom, dateTo, orderBy);
  }

  bool isLoadingMore = false;
  final listScrollController = ScrollController();

  void setupScrollController(bool isSent) {
    listScrollController.addListener(() {
      if (listScrollController.position.atEdge) {
        if (listScrollController.position.pixels != 0) {
          BlocProvider.of<ReceivedPostcardsCubit>(context).getPostcards(
              isSent, search, city, country, dateFrom, dateTo, orderBy);
        }
      }
    });
  }

  String search = ""; //Palmiarnia
  String city = ""; //Gliwice
  String country = ""; //Poland
  String dateFrom = ""; //2021-03-15T00:00:00
  String dateTo = ""; //2021-03-15T00:00:00
  String orderBy = "date"; //-city
  TextEditingController searchController = TextEditingController();

  void _showSortDialog(BuildContext context) {
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    };
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
            {'title': 'Newest', 'value': 'date'},
            {'title': 'Oldest', 'value': '-date'},
            {'title': 'City A-Z', 'value': 'city'},
            {'title': 'City Z-A', 'value': '-city'},
            {'title': 'Country A-Z', 'value': 'country'},
            {'title': 'Country Z-A', 'value': '-country'},
          ],
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    };
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return FilterDialog(
          city: city,
          country: country,
          dateFrom: dateFrom,
          dateTo: dateTo,
          onApply: (newCity, newCountry, newDateFrom, newDateTo) {
            setState(() {
              city = newCity;
              country = newCountry;
              dateFrom = newDateFrom;
              dateTo = newDateTo;
            });
            _refresh(); // Refresh the data with the new filters
          },
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
                    context, "Search something", Icons.search),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            GestureDetector(
              onTap: () {
                _showFilterDialog(context);
              },
              child: Icon(
                Icons.sort,
                color: Theme.of(context).colorScheme.secondary,
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
        const SizedBox(
          height: 15,
        ),
        BlocConsumer<ReceivedPostcardsCubit, ReceivedPostcardsState>(
          listener: (context, state) {
            if (state is ErrorState) {
              showErrorSnackBar(context, state.errorMessage);
            }
          },
          builder: (context, state) {
            if (state is ErrorState) {
              return Flexible(
                child: PostcardsListShimmer(
                  itemCount: 12,
                  crossAxisCount: 3,
                  showDescription: true,
                  title: "Received postcards",
                ),
              );
            }

            if (state is LoadingState && state.isFirstFetch) {
              return Flexible(
                child: PostcardsListShimmer(
                  itemCount: 12,
                  crossAxisCount: 3,
                  showDescription: true,
                  title: "Received postcards",
                ),
              );
            }

            List<PostcardsResponse>? postcardsData = [];
            isLoadingMore = false;

            if (state is LoadingState) {
              postcardsData = state.oldPostcardsData.content;
              if (postcardsData!.length <
                  (state.oldPostcardsData.totalCount ?? 0)) {
                isLoadingMore = true;
              }
            } else if (state is LoadedState) {
              postcardsData = state.postcardsData.content;
              favouritePostcards = state.favouritePostcards.content
                      ?.map((postcard) => postcard.postcardId ?? 0)
                      .toList() ??
                  [];
            }

            return Flexible(
              child: PostcardsGrid(
                listScrollController: listScrollController,
                postcardsData: postcardsData,
                refreshCallback: _refresh,
                parentContext: context,
                isLoadingMore: isLoadingMore,
                postcardPopup: (postcard) {
                  showPostcardDialog(context, postcard!);
                },
                title: "Received postcards",
                favouritePostcardsIds: favouritePostcards,
              ),
            );
          },
        ),
      ],
    );
  }
}
