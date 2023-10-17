import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator_2/background_locator.dart';
import 'package:cached_memory_image/cached_image_base64_manager.dart';
import 'package:cached_memory_image/cached_image_manager.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as gl;
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/api/response/post_coordinates_response.dart';
import 'package:mobile/custom_widgets/custom_drawer/custom_drawer.dart';
import 'package:mobile/custom_widgets/custom_appbars/main_page_app_bar.dart';
import 'package:mobile/custom_widgets/submit_button.dart';
import 'package:mobile/helpers/check_gps_status.dart';
import 'package:mobile/helpers/shared_preferences.dart';
import 'package:mobile/pages/collect_postcard_list_page/collect_postcard_page_widgets/animation_section.dart';
import 'package:mobile/pages/collect_postcard_list_page/collect_postcard_page_widgets/location_disabled_content.dart';
import 'package:mobile/pages/collect_postcard_list_page/collect_postcard_page_widgets/postcard_list_shimmer.dart';
import 'package:mobile/pages/collect_postcard_list_page/collect_postcard_page_widgets/postcard_list_with_title.dart';
import 'package:mobile/pages/settings_page/settings_page.dart';
import 'package:mobile/services/location_service/file_manager.dart';
import 'package:mobile/services/location_service/location_service.dart';

class CollectPostcardListPage extends StatefulWidget {
  const CollectPostcardListPage(
      {super.key, required this.postcardLocationValue});

  final bool postcardLocationValue;

  @override
  State<CollectPostcardListPage> createState() =>
      _CollectPostcardListPageState();
}

class _CollectPostcardListPageState extends State<CollectPostcardListPage> {
  ReceivePort port = ReceivePort();
  final CachedImageManager _cachedImageManager =
      CachedImageBase64Manager.instance();

  String logStr = '';
  bool isRunning = false;
  StreamController<String> streamController = StreamController();
  PostCoordinatesResponse? lastReceivedPostcards;
  late StreamSubscription<gl.ServiceStatus> serviceStatusStream;

  @override
  void initState() {
    super.initState();

    isRunning = widget.postcardLocationValue;

    serviceStatusStream = gl.Geolocator.getServiceStatusStream()
        .listen((gl.ServiceStatus status) {
      setState(() {});
    });

    if (IsolateNameServer.lookupPortByName(LocationService.isolateName) !=
        null) {
      IsolateNameServer.removePortNameMapping(LocationService.isolateName);
    }

    IsolateNameServer.registerPortWithName(
        port.sendPort, LocationService.isolateName);

    port.listen(
      (dynamic data) async {
        await updateUI(data);
      },
    );
    initPlatformState();
  }

  Future<void> updateUI(dynamic data) async {
    PostCoordinatesResponse? postCoordinatesResponse =
        (data != null) ? PostCoordinatesResponse.fromJson(data) : null;

    if (postCoordinatesResponse != null) {
      print("Received new postcards");
    }

    if (mounted) {
      setState(() {
        lastReceivedPostcards = postCoordinatesResponse;
      });
    }
  }

  Future<void> initPlatformState() async {
    print('Initializing...');
    await BackgroundLocator.initialize();
    logStr = await FileManager.readLogFile();
    print('Initialization done');
    final _isRunning = await BackgroundLocator.isServiceRunning();
    setState(() {
      isRunning = _isRunning;
    });
    print('Running ${isRunning.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainPageAppBar(),
      drawer: CustomDrawer(context),
      body: FutureBuilder<bool>(
        future: checkGpsStatus(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data == false) {
            return const LocationDisabledContent();
          } else {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _renderPageHeader(context),
                      if (isRunning) ...[
                        _pageContent(),
                      ] else ...[
                        _noPostcardsContent()
                      ]
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Expanded _noPostcardsContent() {
    return Expanded(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 100,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                "You have to enable location in settings",
                style: GoogleFonts.rubik(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: SubmitButton(
                buttonText: "Go to settings",
                onButtonPressed: () {
                  _goToSettings();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded _pageContent() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: [
            if (lastReceivedPostcards == null && isRunning)
              const PostcardListShimmer(),
            if (lastReceivedPostcards != null && isRunning)
              Column(
                children: [
                  if (lastReceivedPostcards?.postcardsCollected != null)
                    PostcardListWithTitle(
                      title: "Postcards collected",
                      postcards: lastReceivedPostcards!.postcardsCollected!,
                      isReadyToCollect: true,
                    ),
                  if (lastReceivedPostcards?.postcardsNearby != null)
                    PostcardListWithTitle(
                      title: "Postcards nearby",
                      postcards: lastReceivedPostcards!.postcardsNearby!,
                    ),
                ],
              )
          ],
        ),
      ),
    );
  }

  Material _renderPageHeader(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
      child: Column(
        children: [
          if (!isRunning)
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Text(
                  "Locate postcards: Off",
                  style: GoogleFonts.rubik(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          if (isRunning) const AnimationSection(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    serviceStatusStream.cancel();
    super.dispose();
  }

  void _goToSettings() async {
    bool metricSystemValue =
        await AppSharedPreferences.getMetricSystemPreference();
    bool themeValue = await AppSharedPreferences.getThemePreference();
    String dateFormatValue = await AppSharedPreferences.getDatePreference();
    String languageValue = await AppSharedPreferences.getLanguagePreference();
    bool postcardLocationValue =
        await AppSharedPreferences.getLocationPreference();
    double notificationRangeValue =
        await AppSharedPreferences.getNotificationRange();

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsPage(
            metricSystemValue: metricSystemValue,
            themeValue: themeValue,
            dateFormatValue: dateFormatValue,
            languageValue: languageValue,
            postcardLocationValue: postcardLocationValue,
            notificationRangeValue: notificationRangeValue,
          ),
        ),
      );
    }
  }
}
