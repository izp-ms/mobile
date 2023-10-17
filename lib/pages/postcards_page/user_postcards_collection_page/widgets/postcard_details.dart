import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/api/response/postcard_data_response.dart';
import 'package:mobile/custom_widgets/submit_button.dart';
import 'package:mobile/helpers/base64Validator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostcardDetails extends StatelessWidget {

  PostcardDetails({
    super.key,
    required this.width,
    required this.height,
    required this.postcard,
  });

  final PostcardsData? postcard;
  final double height;
  final double width;

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
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: double.infinity, // force to take full width
                ),
                child: (postcardImageBase64 != null &&
                    isBase64Valid(postcardImageBase64))
                    ? Image.memory(base64Decode(postcardImageBase64!),
                    fit: BoxFit.contain)
                    : SvgPicture.asset("assets/postcards/Second.svg",
                    fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              postcard?.title ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0, // Adjust the size as per your requirement
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.map_outlined),
                Text(
                  "${postcard?.country ?? ''}, ${postcard?.city ?? ''}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.pin_drop),
                Text(
                  "${postcard?.latitude ?? ''}, ${postcard?.longitude ?? ''}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            SubmitButton(
              buttonText: AppLocalizations.of(context).close,
              height: 40,
              onButtonPressed: () => {Navigator.of(context).pop()},
            ),
          ],
        ),
      ),
    );
  }
}