import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/api/request/collect_postcard_request.dart';
import 'package:mobile/api/request/coordinates_request.dart';
import 'package:mobile/api/response/postcard_data_response.dart';
import 'package:mobile/cubit/postcards_cubits/collect_postcard_cubit/collect_postcard_cubit.dart';
import 'package:mobile/cubit/postcards_cubits/collect_postcard_cubit/collect_postcard_state.dart';
import 'package:mobile/custom_widgets/submit_button.dart';
import 'package:mobile/helpers/get_image_Uint8List.dart';
import 'package:mobile/helpers/show_error_snack_bar.dart';
import 'package:mobile/pages/collect_postcard_list_page/collect_postcard_page_widgets/postcard_added_modal.dart';

class PostcardCardToCollect extends StatelessWidget {
  const PostcardCardToCollect({super.key, required this.postcard});

  final PostcardsDataResponse postcard;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CollectPostcardCubit, CollectPostcardState>(
        listener: (context, state) {
      if (state is ErrorState) {
        showErrorSnackBar(context, state.errorMessage);
      }
      if (state is SuccessState) {
        _scaleDialog(context);
      }
    }, builder: (context, state) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: [
            ListTile(
              key: Key(postcard.id.toString()),
              contentPadding: const EdgeInsets.all(20),
              leading: Container(
                color: Colors.white,
                height: 60,
                width: 45,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CachedMemoryImage(
                    uniqueKey: postcard.id.toString(),
                    errorWidget: const Text('Error'),
                    bytes: getImageUint8List(postcard.imageBase64),
                    placeholder: const CircularProgressIndicator(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                postcard.title ?? "Postcard id: ${postcard.id}",
                style: GoogleFonts.rubik(
                  fontSize: 20,
                ),
              ),
              subtitle: Text(
                "Long: ${postcard.longitude}\nLat: ${postcard.latitude}",
                style: GoogleFonts.rubik(
                  fontSize: 15,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: SubmitButton(
                  buttonText: "Redeem Postcard",
                  onButtonPressed: () {
                    redeemPostcard(context);
                  },
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  void redeemPostcard(BuildContext context) {
    final collectCubit = context.read<CollectPostcardCubit>();

    final collectDto = CollectPostcardRequest(
      coordinatesRequest: CoordinatesRequest(
        longitude: postcard.longitude!,
        latitude: postcard.latitude!,
        postcardNotificationRangeInMeters: 1000,
      ),
      postcardDataId: postcard.id!,
    );

    collectCubit.collectPostcard(collectDto);
  }

  void _scaleDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: const PostcardAddedModal(),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
