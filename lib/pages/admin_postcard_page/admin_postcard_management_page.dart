import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/api/response/postcard_data_response.dart';
import 'package:mobile/cubit/postcards_cubits/postcards_data_cubit/postcards_data_cubit.dart';
import 'package:mobile/cubit/postcards_cubits/postcards_data_cubit/postcards_data_state.dart';
import 'package:mobile/custom_widgets/custom_appbars/main_page_app_bar.dart';
import 'package:mobile/custom_widgets/custom_drawer/custom_drawer.dart';
import 'package:mobile/custom_widgets/custom_form_filed/styled.dart';
import 'package:mobile/helpers/show_error_snack_bar.dart';
import 'package:mobile/pages/admin_postcard_edit_page/admin_postcard_edit_page.dart';
import 'package:mobile/pages/admin_postcard_page/widgets/admin_postcards_data_grid.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/FilterDialog.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/SortDialog.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/postcards_list_shimmer.dart';

class AdminPostcardManagementPage extends StatefulWidget {
  const AdminPostcardManagementPage({super.key});

  @override
  State<AdminPostcardManagementPage> createState() =>
      _AdminPostcardManagementPageState();
}

class _AdminPostcardManagementPageState
    extends State<AdminPostcardManagementPage> {
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context
        .read<PostcardsDataCubit>()
        .clearUserPostcardsData();
    context.read<PostcardsDataCubit>().currentPage = 1;
    context.read<PostcardsDataCubit>().getPostcardData(
        true, search, city, country, dateFrom, dateTo, orderBy);
  }

  Future _refresh() async {
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    };
    context
        .read<PostcardsDataCubit>()
        .clearUserPostcardsData();
    context.read<PostcardsDataCubit>().currentPage = 1;
    context.read<PostcardsDataCubit>().getPostcardData(
        true, search, city, country, dateFrom, dateTo, orderBy);
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
          BlocProvider.of<PostcardsDataCubit>(context)
              .getPostcardData(showAllPostcardsCollection, search, city,
                  country, dateFrom, dateTo, orderBy);
        }
      }
    });
  }

  String search = "";
  String city = "";
  String country = "";
  String dateFrom = "";
  String dateTo = "";
  String orderBy = "date";

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
          initialOrderBy: orderBy,
          onApply: (selectedOrderBy) {
            setState(() {
              orderBy = selectedOrderBy;
            });
            _refresh();
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
            _refresh();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    setupScrollController(true);
    return Scaffold(
      appBar: const MainPageAppBar(),
      drawer: CustomDrawer(context),
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(
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
              const SizedBox(
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
              const SizedBox(
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
              const SizedBox(
                width: 15,
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          BlocConsumer<PostcardsDataCubit,
              PostcardsDataState>(
            listener: (context, state) {
              if (state is ErrorState) {
                showErrorSnackBar(context, state.errorMessage);
              }
            },
            builder: (context, state) {
              if (state is LoadingState && state.isFirstFetch) {
                return Flexible(
                  child: PostcardsListShimmer(
                    itemCount: 12,
                    crossAxisCount: 3,
                    showDescription: true,
                    title: "Admin Panel",
                  ),
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
                child: AdminPostcardsDataGrid(
                  listScrollController: listScrollController,
                  postcardsData: postcardsData,
                  refreshCallback: _refresh,
                  parentContext: context,
                  isLoadingMore: isLoadingMore,
                  postcardPopup: (postcard) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminPostcardEditPage(
                          postcard: postcard,
                          isEditingMode: true,
                        ),
                      ),
                    ).then((value) => _refresh());
                  },
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminPostcardEditPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
