import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationDisabledContent extends StatelessWidget {
  const LocationDisabledContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 800,
            ),
            child: isPhoneInLandscape(context)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Flexible(
                        flex: 2,
                        child: Center(
                          child: Icon(
                            Icons.location_off_outlined,
                            size: 200,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Text(
                                  "Location is disabled",
                                  style: GoogleFonts.rubik(
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                              AutoSizeText(
                                "If you want to collect postcards you need to turn on your location to determine which postcards are near you.",
                                style: GoogleFonts.rubik(
                                  fontSize: 22,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                        child: Text(
                          "Location is disabled",
                          style: GoogleFonts.rubik(
                            fontSize: 30,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.location_off_outlined,
                        size: 200,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: AutoSizeText(
                          "If you want to collect postcards you need to turn on your location to determine which postcards are near you.",
                          style: GoogleFonts.rubik(
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 5,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  bool isPhoneInLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape ||
        MediaQuery.of(context).size.width > 600;
  }
}
