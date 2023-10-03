import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:cached_memory_image/cached_image_base64_manager.dart';
import 'package:cached_memory_image/cached_image_manager.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as gl;
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/api/response/post_coordinates_response.dart';
import 'package:mobile/custom_widgets/custom_drawer/custom_drawer.dart';
import 'package:mobile/custom_widgets/custom_appbars/main_page_app_bar.dart';
import 'package:mobile/custom_widgets/settings_switch.dart';
import 'package:mobile/helpers/check_gps_status.dart';
import 'package:mobile/pages/collect_postcard_list_page/collect_postcard_page_widgets/animation_section.dart';
import 'package:mobile/pages/collect_postcard_list_page/collect_postcard_page_widgets/location_disabled_content.dart';
import 'package:mobile/pages/collect_postcard_list_page/collect_postcard_page_widgets/postcard_list_shimmer.dart';
import 'package:mobile/pages/collect_postcard_list_page/collect_postcard_page_widgets/postcard_list_with_title.dart';
import 'package:mobile/services/location_service/file_manager.dart';
import 'package:mobile/services/location_service/location_callback_handler.dart';
import 'package:mobile/services/location_service/location_service.dart';
import 'package:permission_handler/permission_handler.dart';

class CollectPostcardListPage extends StatefulWidget {
  const CollectPostcardListPage({super.key});

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
    // final log = Text( //Keep just in case if something went wrong
    //   logStr,
    // );
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: ListView(
                            children: [
                              if (lastReceivedPostcards == null && isRunning)
                                const PostcardListShimmer(),
                              if (lastReceivedPostcards != null && isRunning)
                                Column(
                                  children: [
                                    if (lastReceivedPostcards
                                            ?.postcardsCollected !=
                                        null)
                                      PostcardListWithTitle(
                                        title: "Postcards collected",
                                        postcards: lastReceivedPostcards!
                                            .postcardsCollected!,
                                        isReadyToCollect: true,
                                      ),
                                    if (lastReceivedPostcards
                                            ?.postcardsNearby !=
                                        null)
                                      PostcardListWithTitle(
                                        title: "Postcards nearby",
                                        postcards: lastReceivedPostcards!
                                            .postcardsNearby!,
                                      ),
                                  ],
                                )
                            ],
                          ),
                        ),
                      )
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

  Material _renderPageHeader(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Locate postcards: ${isRunning ? "On" : "Off"}",
                  style: GoogleFonts.rubik(
                    fontSize: 20,
                  ),
                ),
                SwitchWidget(
                  value: isRunning,
                  onChanged: (bool value) {
                    onSwitchChanged(value);
                  },
                )
              ],
            ),
          ),
          if (isRunning) const AnimationSection(),
        ],
      ),
    );
  }

  void onSwitchChanged(bool value) {
    setState(() {
      isRunning = value;
    });
    EasyDebounce.debounce(
      'locate-postcards-switch',
      const Duration(milliseconds: 500),
      () => setState(() {
        if (isRunning) {
          _onStart();
        } else {
          _onStop();
        }
      }),
    );
  }

  void _onStop() async {
    await BackgroundLocator.unRegisterLocationUpdate();
    final _isRunning = await BackgroundLocator.isServiceRunning();
    setState(() {
      FileManager.clearLogFile();
      lastReceivedPostcards = null;
      isRunning = _isRunning;
    });
  }

  void _onStart() async {
    if (await _checkLocationPermission()) {
      await _startLocator();
      final _isRunning = await BackgroundLocator.isServiceRunning();

      setState(() {
        isRunning = _isRunning;
        lastReceivedPostcards = null;
        logStr = '';
      });
    } else {
      // show error
    }
  }

  Future<bool> _checkLocationPermission() async {
    var permission = await Permission.location.request().isGranted;
    if (permission) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _startLocator() async {
    Map<String, dynamic> data = {'countInit': 1};
    return await BackgroundLocator.registerLocationUpdate(
      LocationCallbackHandler.callback,
      initCallback: LocationCallbackHandler.initCallback,
      initDataCallback: data,
      disposeCallback: LocationCallbackHandler.disposeCallback,
      iosSettings: const IOSSettings(
        accuracy: LocationAccuracy.NAVIGATION,
        distanceFilter: 0,
        stopWithTerminate: true,
      ),
      autoStop: false,
      androidSettings: const AndroidSettings(
        accuracy: LocationAccuracy.NAVIGATION,
        interval: 5,
        distanceFilter: 0,
        client: LocationClient.google,
        androidNotificationSettings: AndroidNotificationSettings(
          notificationChannelName: 'Location tracking',
          notificationTitle: 'Start Location Tracking',
          notificationMsg: 'Track location in background',
          notificationBigMsg:
              'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
          notificationIconColor: Colors.grey,
          notificationTapCallback: LocationCallbackHandler.notificationCallback,
        ),
      ),
    );
  }

  @override
  void dispose() {
    serviceStatusStream.cancel();
    super.dispose();
  }
}
