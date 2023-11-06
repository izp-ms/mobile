import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/api/response/postcard_response.dart';
import 'package:mobile/cubit/postcards_cubits/unsent_postcards_cubit/unsent_postcards_cubit.dart';
import 'package:mobile/cubit/postcards_cubits/unsent_postcards_cubit/unsent_postcards_state.dart';
import 'package:mobile/helpers/show_error_snack_bar.dart';
import 'package:mobile/pages/collection_page/user_postcards_collection_page/widgets/postcards_list_shimmer.dart';
import 'package:mobile/pages/postcards_page/widgets/postcard_details.dart';
import 'package:mobile/pages/postcards_page/widgets/postcards_grid.dart';

class UnsentPostcardsPage extends StatefulWidget {

  const UnsentPostcardsPage({Key? key})
      : super(key: key);

  @override
  State<UnsentPostcardsPage> createState() =>
      _UnsentPostcardsPageState();
}

class _UnsentPostcardsPageState extends State<UnsentPostcardsPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context.read<UnsentPostcardsCubit>().clearUnsentPostcards();
    context.read<UnsentPostcardsCubit>().currentPage = 1;
    context.read<UnsentPostcardsCubit>().getPostcards(false);
  }

  Future _refresh() async {
    context.read<UnsentPostcardsCubit>().clearUnsentPostcards();
    context.read<UnsentPostcardsCubit>().currentPage = 1;
    context.read<UnsentPostcardsCubit>().getPostcards(false);
  }

  bool isLoadingMore = false;
  final listScrollController = ScrollController();

  void setupScrollController(bool isSent) {
    listScrollController.addListener(() {
      if (listScrollController.position.atEdge) {
        if (listScrollController.position.pixels != 0) {
          BlocProvider.of<UnsentPostcardsCubit>(context).getPostcards(isSent);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    setupScrollController(false);
    return BlocConsumer<UnsentPostcardsCubit, UnsentPostcardsState>(
      listener: (context, state) {
        if (state is ErrorState) {
          showErrorSnackBar(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        if (state is LoadingState && state.isFirstFetch) {
          return PostcardsListShimmer(itemCount: 12, crossAxisCount: 3 ,showDescription: true,);
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
        }

        return PostcardsGrid(
          listScrollController: listScrollController,
          postcardsData: postcardsData,
          refreshCallback: _refresh,
          parentContext: context,
          isLoadingMore: isLoadingMore,
          postcardPopup: (postcard) {
            showPostcardDialog(context, postcard!);
          },
        );
      },
    );
  }
}