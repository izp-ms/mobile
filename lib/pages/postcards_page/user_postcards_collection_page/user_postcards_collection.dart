import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/api/response/postcard_data_response.dart';
import 'package:mobile/cubit/postcard_cubit/postcard_cubit.dart';
import 'package:mobile/cubit/postcard_cubit/postcard_state.dart';
import 'package:mobile/helpers/show_error_snack_bar.dart';
import 'package:mobile/pages/postcards_page/user_postcards_collection_page/widgets/postcards_grid.dart';
import 'package:mobile/pages/postcards_page/user_postcards_collection_page/widgets/postcards_list_shimmer.dart';

class UserPostcardsCollectionPage extends StatefulWidget {
  const UserPostcardsCollectionPage({super.key});

  @override
  State<UserPostcardsCollectionPage> createState() =>
      _UserPostcardsCollectionPageState();
}

class _UserPostcardsCollectionPageState
    extends State<UserPostcardsCollectionPage> {
  @override
  void initState() {
    super.initState();
    context.read<PostcardCubit>().clearPostcardData();
    context.read<PostcardCubit>().currentPage = 1;
    context.read<PostcardCubit>().getPostcardData();
  }

  Future _refresh() async {
    context.read<PostcardCubit>().clearPostcardData();
    context.read<PostcardCubit>().currentPage = 1;
    context.read<PostcardCubit>().getPostcardData();
  }

  bool isLoadingMore = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostcardCubit, PostcardState>(
      listener: (context, state) {
        if (state is ErrorState) {
          showErrorSnackBar(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        if (state is LoadingState && state.isFirstFetch) {
          return PostcardsListShimmer();
        }

        List<PostcardsData>? postcardsData = [];
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

        return PostcardsGrid(
          postcardsData: postcardsData,
          refreshCallback: _refresh,
          parentContext: context,
          isLoadingMore: isLoadingMore,
        );
      },
    );
  }
}