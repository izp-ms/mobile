import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/api/request/favourite_postcard_request.dart';
import 'package:mobile/api/response/postcard_response.dart';
import 'package:mobile/api/response/user_detail_response.dart';
import 'package:mobile/cubit/postcards_cubits/received_postcards_cubit/received_postcards_cubit.dart';
import 'package:mobile/cubit/postcards_cubits/received_postcards_cubit/received_postcards_state.dart';
import 'package:mobile/cubit/user_cubit/user_cubit.dart';
import 'package:mobile/custom_widgets/submit_button.dart';
import 'package:mobile/helpers/base64Validator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/helpers/show_error_snack_bar.dart';

void showPostcardDialog(BuildContext context, PostcardsResponse? postcard,
    {bool obfuscateData = false, UserDetailResponse? response}) {
  double width = MediaQuery.of(context).size.width * 0.9;
  double height = MediaQuery.of(context).size.height * 0.75;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return PostcardDetails(
        width: width,
        height: height,
        postcard: postcard,
        obfuscateData: obfuscateData,
      );
    },
  ).then((value) {
    if (response != null) {
      context.read<UserCubit>().refreshFavouritePostcards(response);
    }
  });
}

class PostcardDetails extends StatelessWidget {
  final PostcardsResponse? postcard;
  final bool obfuscateData;
  final double height;
  final double width;

  PostcardDetails({
    super.key,
    required this.width,
    required this.height,
    required this.postcard,
    this.obfuscateData = false,
  });

  late String? postcardImageBase64 = postcard?.imageBase64?.substring(23);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        child: Column(
          children: <Widget>[
            Expanded(
              // Use expanded to make the image take all available space
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: double.infinity, // force to take full width
                  ),
                  child: (postcardImageBase64 != null &&
                          isBase64Valid(postcardImageBase64))
                      ? obfuscateData
                          ? ColorFiltered(
                              colorFilter: const ColorFilter.mode(
                                  Colors.grey, BlendMode.saturation),
                              child: Image.memory(
                                  base64Decode(postcardImageBase64!),
                                  fit: BoxFit.cover),
                            )
                          : Image.memory(base64Decode(postcardImageBase64!),
                              fit: BoxFit.cover)
                      : obfuscateData
                          ? ColorFiltered(
                              colorFilter: const ColorFilter.mode(
                                  Colors.grey, BlendMode.saturation),
                              child: SvgPicture.asset(
                                  "assets/postcards/Second.svg",
                                  fit: BoxFit.cover),
                            )
                          : SvgPicture.asset("assets/postcards/Second.svg",
                              fit: BoxFit.cover),
                ),
              ),
            ),
            AutoSizeText(
              obfuscateData
                  ? "????????????"
                  : postcard?.postcardDataTitle ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w300),
              maxLines: 2,
            ),
            const SizedBox(height: 15.0),
            if (postcard!.isSent)
              Text(
                postcard?.title ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            const SizedBox(height: 5.0),
            if (postcard!.isSent)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      "${postcard?.content ?? ''}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SubmitButton(
                  buttonText: AppLocalizations.of(context).close,
                  height: 40,
                  onButtonPressed: () => {Navigator.of(context).pop()},
                ),
                SizedBox(width: 10.0),
                if (!postcard!.isSent)
                  SubmitButton(
                    buttonText: AppLocalizations.of(context).send,
                    height: 40,
                    onButtonPressed: () => {Navigator.of(context).pop()},
                  ),
                if (postcard!.isSent)
                  BlocBuilder<ReceivedPostcardsCubit, ReceivedPostcardsState>(
                    builder: (context, state) {
                      if (postcard!.isSent && state is LoadedState) {
                        bool isFavourite = isPostcardInFavourite(
                            state.favouritePostcards.content ?? []);
                        return IconButton(
                          onPressed: () {
                            if (state.favouritePostcards.content!.length >= 6 &&
                                !isFavourite) {
                              showErrorSnackBar(context,
                                  "You can only have 6 favourite postcards.");
                              return;
                            }
                            EasyDebounce.debounce(
                                'locate-postcards-switch',
                                const Duration(milliseconds: 200),
                                () => updateFavourites(state, context));
                          },
                          icon: isFavourite
                              ? const Icon(Icons.favorite)
                              : const Icon(Icons.favorite_outline),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void updateFavourites(LoadedState state, BuildContext context) {
    List<PostcardIdsWithOrders> resultList = prepareFavourites(state);

    context.read<ReceivedPostcardsCubit>().putFavouritePostcards(
          state.postcardsData,
          FavouritePostcardRequest(
            postcardIdsWithOrders: resultList,
          ),
        );
  }

  bool isPostcardInFavourite(List<PostcardsResponse> postcardsList) {
    bool isIdPresent = false;
    for (PostcardsResponse postcardInList in postcardsList) {
      if (postcardInList.postcardId == (postcard?.postcardId ?? postcard?.id)) {
        isIdPresent = true;
        break;
      }
    }

    return isIdPresent;
  }

  List<PostcardIdsWithOrders> prepareFavourites(LoadedState state) {
    List<int?>? ids = state.favouritePostcards.content
        ?.map((postcard) => postcard.postcardId)
        .toList();
    List<PostcardIdsWithOrders> resultList = [];

    print(postcard?.postcardId);
    print(postcard?.id);

    if (isPostcardInFavourite(state.favouritePostcards.content ?? [])) {
      ids?.remove(postcard?.postcardId ?? postcard?.id);
    } else {
      ids?.add(postcard?.postcardId ?? postcard?.id);
    }

    if (ids != null && ids.isNotEmpty) {
      for (int i = 0; i < ids.length; i++) {
        resultList.add(PostcardIdsWithOrders(
          postcardId: ids[i] ?? 0,
          orderId: i + 1,
        ));
      }
    }
    return resultList;
  }
}
