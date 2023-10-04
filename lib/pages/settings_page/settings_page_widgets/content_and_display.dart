import 'package:app_settings/app_settings.dart';
import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/custom_widgets/settings_switch.dart';
import 'package:mobile/helpers/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/services/location_service/file_manager.dart';
import 'package:mobile/services/location_service/location_callback_handler.dart';
import 'package:permission_handler/permission_handler.dart';

class ContentAndDisplay extends StatefulWidget {
  const ContentAndDisplay(
      {Key? key,
      required this.themeValue,
      required this.languageValue,
      required this.postcardLocationValue})
      : super(key: key);

  final String languageValue;
  final bool themeValue;
  final bool postcardLocationValue;

  @override
  State<ContentAndDisplay> createState() => _ContentAndDisplayState();
}

class _ContentAndDisplayState extends State<ContentAndDisplay> {
  bool switchThemeValue = false;
  bool postcardLocationValue = false;

  @override
  void initState() {
    super.initState();
    switchThemeValue = widget.themeValue;
    postcardLocationValue = widget.postcardLocationValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
          child: Text(
            AppLocalizations.of(context).contentAndDisplay,
            style: GoogleFonts.rubik(
              fontSize: 18,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context).switchTheme,
                    style: GoogleFonts.rubik(
                      fontSize: 18,
                    ),
                  ),
                  SwitchWidget(
                    value: switchThemeValue,
                    onChanged: (bool themeValue) {
                      setState(() {
                        switchThemeValue = themeValue;
                      });
                      AppSharedPreferences.saveThemePreference(themeValue);
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Locate postcards: ${postcardLocationValue ? "On" : "Off"}",
                    style: GoogleFonts.rubik(
                      fontSize: 18,
                    ),
                  ),
                  SwitchWidget(
                    value: postcardLocationValue,
                    onChanged: (bool locationValue) {
                      setState(() {
                        postcardLocationValue = locationValue;
                      });
                      _onLocationSwitchChanged(locationValue);
                    },
                  )
                ],
              ),
              const SizedBox(height: 3),
              GestureDetector(
                onTap: () => {print("app language")},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).appLanguage,
                      style: GoogleFonts.rubik(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "${widget.languageValue} >",
                      style: GoogleFonts.rubik(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: openNotificationSettings,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).notifications,
                      style: GoogleFonts.rubik(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context).settings_details,
                      style: GoogleFonts.rubik(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void openNotificationSettings() {
    AppSettings.openAppSettings(type: AppSettingsType.notification);
  }

  void _onLocationSwitchChanged(bool value) {
    EasyDebounce.debounce(
      'locate-postcards-switch',
      const Duration(milliseconds: 500),
      () => setState(() {
        if (postcardLocationValue) {
          _onStart();
        } else {
          _onStop();
        }
        AppSharedPreferences.saveLocationPreference(postcardLocationValue);
      }),
    );
  }

  void _onStop() async {
    await BackgroundLocator.unRegisterLocationUpdate();
    setState(() {
      FileManager.clearLogFile();
    });
  }

  void _onStart() async {
    if (await _checkLocationPermission()) {
      await _startLocator();

      setState(() {});
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
        interval: 10,
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
}
