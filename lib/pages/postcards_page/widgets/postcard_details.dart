import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/api/response/postcard_data_response.dart';
import 'package:mobile/api/response/postcard_response.dart';
import 'package:mobile/custom_widgets/submit_button.dart';
import 'package:mobile/helpers/base64Validator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showPostcardDialog(BuildContext context, PostcardsResponse? postcard,
    {bool obfuscateData = false}) {
  double width = MediaQuery.of(context).size.width * 0.9;
  double height = MediaQuery.of(context).size.height * 0.75;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return PostcardDetails(
          width: width,
          height: height,
          postcard: postcard,
          obfuscateData: obfuscateData);
    },
  );
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
                                fit: BoxFit.contain),
                          )
                        : Image.memory(base64Decode(postcardImageBase64!),
                            fit: BoxFit.contain)
                    : obfuscateData
                        ? ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                                Colors.grey, BlendMode.saturation),
                            child: SvgPicture.asset(
                                "assets/postcards/Second.svg",
                                fit: BoxFit.contain),
                          )
                        : SvgPicture.asset("assets/postcards/Second.svg",
                            fit: BoxFit.contain),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  obfuscateData
                      ? "????????????"
                      : "${postcard?.postcardDataTitle ?? ''}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w300),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            if (postcard!.isSent)
            Text(
              postcard?.title ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0, // Adjust the size as per your requirement
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
                if (!postcard!.isSent) const SizedBox(width: 10.0),
                if (!postcard!.isSent)
                  SubmitButton(
                    buttonText: AppLocalizations.of(context).send,
                    height: 40,
                    onButtonPressed: () => {Navigator.of(context).pop()},
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
