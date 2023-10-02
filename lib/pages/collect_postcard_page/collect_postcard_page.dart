import 'dart:async';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/api/response/postcard_data_response.dart';
import 'package:mobile/custom_widgets/submit_button.dart';
import 'package:mobile/helpers/get_image_Uint8List.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart' as gl;
import 'package:url_launcher/url_launcher.dart';

class CollectPostcardPage extends StatefulWidget {
  const CollectPostcardPage({
    super.key,
    required this.postcard,
  });

  final PostcardsDataResponse postcard;

  @override
  State<CollectPostcardPage> createState() => _CollectPostcardPageState();
}

class _CollectPostcardPageState extends State<CollectPostcardPage> {
  late StreamSubscription<gl.ServiceStatus> serviceStatusStream;

  void initState() {
    super.initState();

    serviceStatusStream = gl.Geolocator.getServiceStatusStream()
        .listen((gl.ServiceStatus status) {
      Navigator.of(context).pop();
    });
  }

  Future<bool> checkGpsStatus() async {
    var isEnabled = await Permission.location.serviceStatus.isEnabled;
    return isEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          padding: const EdgeInsets.only(left: 30),
          iconSize: 30,
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.white,
              height: 240,
              width: 180,
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: CachedMemoryImage(
                  uniqueKey: widget.postcard.id.toString(),
                  errorWidget: const Text('Error'),
                  bytes: getImageUint8List(widget.postcard.imageBase64),
                  placeholder: const CircularProgressIndicator(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                widget.postcard.title ?? "Postcard id: ${widget.postcard.id}",
                style: GoogleFonts.rubik(
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Longitude: ${widget.postcard.longitude}",
                    style: GoogleFonts.rubik(
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Latitude: ${widget.postcard.latitude}",
                    style: GoogleFonts.rubik(
                      fontSize: 25,
                    ),
                  ),
                  if (widget.postcard.country != null) ...[
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Country: ${widget.postcard.country}",
                      style: GoogleFonts.rubik(
                        fontSize: 25,
                      ),
                    ),
                  ],
                  if (widget.postcard.city != null) ...[
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "City: ${widget.postcard.city}",
                      style: GoogleFonts.rubik(
                        fontSize: 25,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: SubmitButton(
                  buttonText: "Show me route",
                  onButtonPressed: () {
                    _launchGoogleMapsUrl();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchGoogleMapsUrl() async {
    Uri url = Uri.parse(
        "https://www.google.com/maps/dir/?api=1&destination=${widget.postcard.latitude},${widget.postcard.longitude}");
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
