import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as gl;
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/custom_widgets/custom_drawer/custom_drawer.dart';
import 'package:mobile/custom_widgets/main_page_app_bar.dart';
import 'package:mobile/custom_widgets/settings_switch.dart';
import 'package:mobile/repositories/location_service_repository/file_manager.dart';
import 'package:mobile/repositories/location_service_repository/location_callback_handler.dart';
import 'package:mobile/repositories/location_service_repository/location_service_repository.dart';
import 'package:permission_handler/permission_handler.dart';

class CollectPostcardPage extends StatefulWidget {
  const CollectPostcardPage({super.key});

  @override
  State<CollectPostcardPage> createState() => _CollectPostcardPageState();
}

class _CollectPostcardPageState extends State<CollectPostcardPage> {
  ReceivePort port = ReceivePort();

  String logStr = '';
  bool isRunning = false;
  LocationDto? lastLocation;
  StreamController<String> streamController = StreamController();
  late StreamSubscription<gl.ServiceStatus> serviceStatusStream;

  @override
  void initState() {
    super.initState();

    serviceStatusStream = gl.Geolocator.getServiceStatusStream()
        .listen((gl.ServiceStatus status) {
      setState(() {});
    });

    if (IsolateNameServer.lookupPortByName(
            LocationServiceRepository.isolateName) !=
        null) {
      IsolateNameServer.removePortNameMapping(
          LocationServiceRepository.isolateName);
    }

    IsolateNameServer.registerPortWithName(
        port.sendPort, LocationServiceRepository.isolateName);

    port.listen(
      (dynamic data) async {
        await updateUI(data);
      },
    );
    initPlatformState();
  }

  Future<void> updateUI(dynamic data) async {
    final log = await FileManager.readLogFile();

    LocationDto? locationDto =
        (data != null) ? LocationDto.fromJson(data) : null;

    if (locationDto != null) {
      await _updateNotificationText(locationDto);
    }

    setState(() {
      if (data != null) {
        lastLocation = locationDto;
      }
      logStr = log;
    });
  }

  Future<void> _updateNotificationText(LocationDto data) async {
    await BackgroundLocator.updateNotificationText(
        title: "new location received",
        msg: "${DateTime.now()}",
        bigMsg: "${data.latitude}, ${data.longitude}");
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

  Future<bool> checkGpsStatus() async {
    var isEnabled = await Permission.location.serviceStatus.isEnabled;
    return isEnabled;
  }

  @override
  Widget build(BuildContext context) {
    // final log = Text( //Keep just in case if something went wrong
    //   logStr,
    // );
    return Scaffold(
      appBar: const MainPageAppBar(),
      drawer: CustomDrawer(context),
      body: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(22),
        child: FutureBuilder<bool>(
          future: checkGpsStatus(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data == false) {
              return const Text('Please turn on GPS to use this feature.');
            } else {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Status ${isRunning ? "Runing" : "Not runing"}",
                          style: GoogleFonts.rubik(
                            fontSize: 20,
                          ),
                        ),
                        SwitchWidget(
                          value: isRunning,
                          onChanged: (bool value) {
                            setState(() {
                              isRunning = value;
                              if (isRunning) {
                                _onStart();
                              } else {
                                _onStop();
                              }
                            });
                          },
                        )
                      ],
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _onStop() async {
    await BackgroundLocator.unRegisterLocationUpdate();
    final _isRunning = await BackgroundLocator.isServiceRunning();
    setState(() {
      FileManager.clearLogFile();
      isRunning = _isRunning;
    });
  }

  void _onStart() async {
    if (await _checkLocationPermission()) {
      await _startLocator();
      final _isRunning = await BackgroundLocator.isServiceRunning();

      setState(() {
        isRunning = _isRunning;
        lastLocation = null;
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
