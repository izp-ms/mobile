import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/api/response/postcard_data_response.dart';
import 'package:mobile/custom_widgets/submit_button.dart';
import 'package:mobile/helpers/get_image_Uint8List.dart';

class PostcardCardToCollect extends StatelessWidget {
  const PostcardCardToCollect({super.key, required this.postcard});

  final PostcardsDataResponse postcard;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          ListTile(
            key: Key(postcard.id.toString()),
            contentPadding: EdgeInsets.all(20),
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
              "Long: ${postcard.longitude} Lat: ${postcard.latitude}",
              style: GoogleFonts.rubik(
                fontSize: 15,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10,0,10,10),
              child: SubmitButton(
                buttonText: "Redeem Postcard",
                onButtonPressed: () {
                  //TODO sending request
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
