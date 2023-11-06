import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/api/response/postcard_data_response.dart';
import 'package:mobile/cubit/postcards_cubits/postcards_data_cubit/postcards_data_collection_cubit.dart';
import 'package:mobile/cubit/postcards_cubits/postcards_data_cubit/postcards_data_collection_state.dart';
import 'package:mobile/helpers/show_error_snack_bar.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/postcard_data_details.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/postcards_data_grid.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/postcards_list_shimmer.dart';

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
    context.read<PostcardsDataCollectionCubit>().clearUserPostcardsDataCollection();
    context.read<PostcardsDataCollectionCubit>().currentPage = 1;
    context.read<PostcardsDataCollectionCubit>().getPostcardData(true);
  }

  Future _refresh() async {
    context.read<PostcardsDataCollectionCubit>().clearUserPostcardsDataCollection();
    context.read<PostcardsDataCollectionCubit>().currentPage = 1;
    context.read<PostcardsDataCollectionCubit>().getPostcardData(true);
  }

  bool isLoadingMore = false;
  final listScrollController = ScrollController();

  void setupScrollController(bool showAllPostcardsCollection) {
    listScrollController.addListener(() {
      if (listScrollController.position.atEdge) {
        if (listScrollController.position.pixels != 0) {
          BlocProvider.of<PostcardsDataCollectionCubit>(context).getPostcardData(showAllPostcardsCollection);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    setupScrollController(true);
    return BlocConsumer<PostcardsDataCollectionCubit, PostcardsDataCollectionState>(
      listener: (context, state) {
        if (state is ErrorState) {
          showErrorSnackBar(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        if (state is LoadingState && state.isFirstFetch) {
          return PostcardsListShimmer(itemCount: 12, crossAxisCount: 3 ,showDescription: true,);
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

        return PostcardsDataGrid(
          listScrollController: listScrollController,
          postcardsData: postcardsData,
          refreshCallback: _refresh,
          parentContext: context,
          isLoadingMore: isLoadingMore,
          postcardPopup: (postcard) {
            showImageDialog(context, postcard!, obfuscateData: true);
          },
          obfuscateData: true,
        );
      },
    );
  }
}

