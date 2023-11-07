import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/api/response/postcard_data_response.dart';
import 'package:mobile/cubit/postcards_cubits/postcards_data_cubit/postcards_data_collection_cubit.dart';
import 'package:mobile/cubit/postcards_cubits/postcards_data_cubit/postcards_data_collection_state.dart';
import 'package:mobile/custom_widgets/CustomRadioBox.dart';
import 'package:mobile/custom_widgets/custom_form_filed/custom_form_field.dart';
import 'package:mobile/custom_widgets/custom_form_filed/styled.dart';
import 'package:mobile/helpers/show_error_snack_bar.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/FilterDialog.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/SortDialog.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/postcard_data_details.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/postcards_data_grid.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/postcards_list_shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllPostcardsCollectionPage extends StatefulWidget {
  const AllPostcardsCollectionPage({Key? key})
      : super(key: key);

  @override
  State<AllPostcardsCollectionPage> createState() =>
      _AllPostcardsCollectionPageState();
}

class _AllPostcardsCollectionPageState extends State<AllPostcardsCollectionPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context.read<PostcardsDataCollectionCubit>()
        .clearUserPostcardsDataCollection();
    context
        .read<PostcardsDataCollectionCubit>()
        .currentPage = 1;
    context.read<PostcardsDataCollectionCubit>().getPostcardData(true, search, city, country, dateFrom, dateTo, orderBy);
  }

  Future _refresh() async {
    FocusScope.of(context).unfocus();
    context.read<PostcardsDataCollectionCubit>()
        .clearUserPostcardsDataCollection();
    context
        .read<PostcardsDataCollectionCubit>()
        .currentPage = 1;
    context.read<PostcardsDataCollectionCubit>().getPostcardData(true, search, city, country, dateFrom, dateTo, orderBy);
    print("=============");
    print(search);
    print(city);
    print(country);
    print(dateFrom);
    print(dateTo);
    print(orderBy);
    print("=============");
  }

  bool isLoadingMore = false;
  final listScrollController = ScrollController();

  void setupScrollController(bool showAllPostcardsCollection) {
    listScrollController.addListener(() {
      if (listScrollController.position.atEdge) {
        if (listScrollController.position.pixels != 0) {
          BlocProvider.of<PostcardsDataCollectionCubit>(context)
              .getPostcardData(showAllPostcardsCollection, search, city, country, dateFrom, dateTo, orderBy);
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
          initialOrderBy: orderBy, // Pass the initial sorting option
          onApply: (selectedOrderBy) {
            setState(() {
              orderBy = selectedOrderBy; // Update the orderBy variable
            });
            _refresh(); // Refresh the data with the new sorting option
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
            _refresh(); // Refresh the data with the new filters
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    setupScrollController(true);
    return Column(
      children: [
        SizedBox(height: 15,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(width: 15,),
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
                decoration: customTextFieldDecoration(context, "Search something", Icons.search),
              ),
            ),
            SizedBox(width: 15,),
            GestureDetector(
              onTap: () {
                _showFilterDialog(context);
              },
              child: Icon(Icons.sort, color: Theme.of(context).colorScheme.secondary,),
            ),
            SizedBox(width: 15,),
            GestureDetector(
              onTap: () {
                _showSortDialog(context);
              },
              child: Icon(Icons.sort_by_alpha, color: Theme.of(context).colorScheme.secondary,),
            ),
            SizedBox(width: 15,),
          ],
        ),

        SizedBox(height: 15,),

        BlocConsumer<PostcardsDataCollectionCubit, PostcardsDataCollectionState>(
          listener: (context, state) {
            if (state is ErrorState) {
              showErrorSnackBar(context, state.errorMessage);
            }
          },
          builder: (context, state) {
            if (state is LoadingState && state.isFirstFetch) {
              return Flexible(
                child: PostcardsListShimmer(
                  itemCount: 12, crossAxisCount: 3, showDescription: true, title: "All postcards",),
              );
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
                  showImageDialog(context, postcard!, obfuscateData: true);
                },
                obfuscateData: true,
                title: "All postcards",
              ),
            );
          },
        ),
      ],
    );
  }
}
