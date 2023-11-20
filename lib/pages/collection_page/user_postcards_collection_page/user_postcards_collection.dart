import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/api/response/postcard_data_response.dart';
import 'package:mobile/cubit/postcards_cubits/postcards_data_collection_cubit/postcards_data_cubit.dart';
import 'package:mobile/cubit/postcards_cubits/postcards_data_collection_cubit/postcards_data_state.dart';
import 'package:mobile/custom_widgets/custom_form_filed/styled.dart';
import 'package:mobile/helpers/show_error_snack_bar.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/FilterDialog.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/SortDialog.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/postcard_data_details.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/postcards_data_grid.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/postcards_list_shimmer.dart';

class UserPostcardsCollectionPage extends StatefulWidget {
  const UserPostcardsCollectionPage({Key? key}) : super(key: key);

  @override
  State<UserPostcardsCollectionPage> createState() =>
      _UserPostcardsCollectionPageState();
}

class _UserPostcardsCollectionPageState
    extends State<UserPostcardsCollectionPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context.read<PostcardsDataCubit>().clearUserPostcardsData();
    context.read<PostcardsDataCubit>().currentPage = 1;
    context.read<PostcardsDataCubit>().getPostcardData(
        false, search, city, country, dateFrom, dateTo, orderBy);
  }

  Future _refresh() async {
    context.read<PostcardsDataCubit>().clearUserPostcardsData();
    context.read<PostcardsDataCubit>().currentPage = 1;
    context.read<PostcardsDataCubit>().getPostcardData(
        false, search, city, country, dateFrom, dateTo, orderBy);
  }

  bool isLoadingMore = false;
  final listScrollController = ScrollController();

  void setupScrollController(bool showAllPostcardsCollection) {
    listScrollController.addListener(() {
      if (listScrollController.position.atEdge) {
        if (listScrollController.position.pixels != 0) {
          BlocProvider.of<PostcardsDataCubit>(context)
            ..getPostcardData(showAllPostcardsCollection, search, city, country,
                dateFrom, dateTo, orderBy);
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
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return SortDialog(
          initialOrderBy: orderBy,
          onApply: (selectedOrderBy) {
            setState(() {
              orderBy = selectedOrderBy;
            });
            _refresh();
          },
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
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
            _refresh();
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
        SizedBox(
          height: 15,
        ),
        BlocConsumer<PostcardsDataCubit, PostcardsDataState>(
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
                title: "Your postcards",
              ));
            }

            if (state is LoadingState && state.isFirstFetch) {
              return Flexible(
                  child: PostcardsListShimmer(
                itemCount: 12,
                crossAxisCount: 3,
                showDescription: true,
                title: "Your postcards",
              ));
            }

            List<PostcardsDataResponse>? postcardsData = [];
            isLoadingMore = false;

            if (state is LoadingState) {
              postcardsData = state.oldPostcardsData.content;
              if (postcardsData!.length <
                  (state.oldPostcardsData.totalCount ?? 0)) {
                isLoadingMore = true;
              }
            } else if (state is LoadedState) {
              postcardsData = state.postcardsData.content;
            }

            return Flexible(
              child: PostcardsDataGrid(
                listScrollController: listScrollController,
                postcardsData: postcardsData,
                refreshCallback: _refresh,
                parentContext: context,
                isLoadingMore: isLoadingMore,
                postcardPopup: (postcard) {
                  showImageDialog(context, postcard!);
                },
                title: "Your postcards",
              ),
            );
          },
        ),
      ],
    );
  }
}
