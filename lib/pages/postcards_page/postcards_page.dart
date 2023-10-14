import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/api/response/postcard_data_response.dart';
import 'package:mobile/cubit/postcard_cubit/postcard_cubit.dart';
import 'package:mobile/cubit/postcard_cubit/postcard_state.dart';
import 'package:mobile/custom_widgets/custom_drawer/custom_drawer.dart';
import 'package:mobile/custom_widgets/custom_shimmer/custom_shimmer.dart';
import 'package:mobile/custom_widgets/main_page_app_bar.dart';
import 'package:mobile/helpers/base64Validator.dart';
import 'package:mobile/helpers/show_error_snack_bar.dart';

class PostcardsPage extends StatefulWidget {
  const PostcardsPage({super.key});

  @override
  State<PostcardsPage> createState() => _PostcardsPageState();
}

class _PostcardsPageState extends State<PostcardsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<PostcardCubit>();
      cubit.getPostcardData();
    });
  }

  Future _refresh() async {
    context.read<PostcardCubit>().clearPostcardData();
    context.read<PostcardCubit>().currentPage = 1;
    context.read<PostcardCubit>().getPostcardData();
  }

  bool isLoadingMore = false;

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
          if (state is LoadingState && state.isFirstFetch) {
            return ShimmerPlaceholderWidget();
          }

          List<PostcardsData>? postcardsData = [];
          isLoadingMore = false;


          if (state is LoadingState) {
            postcardsData = state.oldPostcardsData.content;
            print(state.oldPostcardsData.totalCount);
            if(postcardsData!.length < (state.oldPostcardsData.totalCount ?? 0))
              {
                isLoadingMore = true;
              }
          } else if (state is LoadedState) {
            postcardsData = state.postcardsData.content;
          }


          return PostcardGridWidget(
            postcardsData: postcardsData,
            refreshCallback: _refresh,
            parentContext: context,
            isLoadingMore: isLoadingMore,
          );
        },
      ),
    );
  }
}

void _showImageDialog(BuildContext context, String? base64Image) {
  double width = MediaQuery.of(context).size.width * 0.8; // 80% of screen width
  double height =
      MediaQuery.of(context).size.height * 0.6; // 60% of screen height

  Widget imageWidget;

  if (base64Image != null && isBase64Valid(base64Image)) {
    imageWidget = Image.memory(base64Decode(base64Image), fit: BoxFit.cover);
  } else {
    imageWidget = Expanded(
        child: SvgPicture.asset("assets/postcards/Second.svg",
            fit: BoxFit.contain));
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(child: imageWidget),
              SizedBox(height: 10.0),
              ElevatedButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),
      );
    },
  );
}

class ShimmerPlaceholderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 32,
        mainAxisSpacing: 20,
        childAspectRatio:
            0.7, // Adjust this value to ensure the shimmer doesn't overflow
      ),
      itemCount: 12,
      itemBuilder: (BuildContext context, int index) {
        return PostcardShimmerPlaceholder();
      },
    );
  }
}

class PostcardGridWidget extends StatelessWidget {
  final listScrollController = ScrollController();
  final List<PostcardsData>? postcardsData;
  final Function refreshCallback;
  final BuildContext parentContext;
  final bool isLoadingMore;

  PostcardGridWidget({
    required this.postcardsData,
    required this.refreshCallback,
    required this.parentContext,
    required this.isLoadingMore,

  }) {
    setupScrollController();
  }

  void setupScrollController() {
    listScrollController.addListener(() {
      if (listScrollController.position.atEdge) {
        if (listScrollController.position.pixels != 0) {
          print("DUPA");
          BlocProvider.of<PostcardCubit>(parentContext).getPostcardData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = postcardsData?.length ?? 0;
    if(isLoadingMore)
      {
        itemCount += 12;
      }

    return RefreshIndicator(
      onRefresh: () async {
        refreshCallback.call();
      },
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: GridView.builder(
        controller: listScrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.7,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (index < (postcardsData?.length ?? 0)) {
            final postcard = postcardsData?[index];
            return GestureDetector(
              onTap: () {
                _showImageDialog(context, postcard!.imageBase64!);
              },
              child: Column(
                children: <Widget>[
                  if (postcard?.imageBase64 != null &&
                      isBase64Valid(postcard?.imageBase64))
                    Expanded(
                      child: Image.memory(
                        base64Decode(postcard!.imageBase64!),
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    AspectRatio(
                      aspectRatio: 1, // 1:1 square
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: SvgPicture.asset("assets/postcards/First.svg",
                            fit: BoxFit.contain),
                      ),
                    ),
                  Flexible(
                    child: Text(
                      postcard?.title ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      "${postcard?.country ?? ''}, ${postcard?.city ?? ''}",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          } else {
            // If we've exceeded the number of postcards, show a shimmer placeholder
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 0,  10, 0),
              child: PostcardShimmerPlaceholder(),
            );
          }
        },
      ),
    );
  }
}


class PostcardShimmerPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Shimmer for image
        Padding(
          padding: const EdgeInsets.all(10),
          // Adjust the padding to make the shimmer smaller
          child: CustomShimmer(
            context: context,
            width: double.infinity, // to fill parent width
            height: 110, // Adjust this value if needed
          ),
        ),
        SizedBox(height: 5),

        // Shimmer for text
        CustomShimmer(
          context: context,
          width: double.infinity, // to fill parent width
          height: 20, // Adjusted this value a bit
        )
      ],
    );
  }
}