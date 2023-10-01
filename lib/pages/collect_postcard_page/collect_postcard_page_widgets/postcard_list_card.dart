import 'dart:typed_data';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/api/response/postcard_data_response.dart';

class PostcardListCard extends StatelessWidget {
  const PostcardListCard({super.key, required this.postcard});

  final PostcardsDataResponse postcard;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: ListTile(
        key: Key(postcard.id.toString()),
        contentPadding: EdgeInsets.all(20),
        leading: Container(
          color: Colors.white,
          height: 60,
          width: 45,
          child: CachedMemoryImage(
            uniqueKey: postcard.id.toString(),
            errorWidget: const Text('Error'),
            bytes: _getImageUint8List(postcard.imageBase64),
            placeholder: const CircularProgressIndicator(),
            fit: BoxFit.cover,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios_outlined),
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
    );
  }

  Uint8List? _getImageUint8List(imageBase64) {
    final imageData = imageBase64!;
    final UriData? data = Uri.parse(imageData).data;
    return data?.contentAsBytes();
  }
}
