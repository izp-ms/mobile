import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
import 'package:background_locator_2/location_dto.dart';
import 'package:mobile/api/request/coordinates_request.dart';
import 'package:mobile/api/response/post_coordinates_response.dart';
import 'package:mobile/helpers/shared_preferences.dart';
import 'package:mobile/services/collect_postcard_service.dart';
import 'package:mobile/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'file_manager.dart';

class LocationService {
  static LocationService _instance = LocationService._();
  CollectPostcardService collectPostcardService = CollectPostcardService();

  LocationService._();

  factory LocationService() {
    return _instance;
  }

  static const String isolateName = 'LocatorIsolate';

  int _count = -1;
  int _cyclesCount = 0;

  Future<void> init(Map<dynamic, dynamic> params) async {
    //TODO change logs
    print("***********Init callback handler");
    if (params.containsKey('countInit')) {
      dynamic tmpCount = params['countInit'];
      if (tmpCount is double) {
        _count = tmpCount.toInt();
      } else if (tmpCount is String) {
        _count = int.parse(tmpCount);
      } else if (tmpCount is int) {
        _count = tmpCount;
      } else {
        _count = -2;
      }
    } else {
      _count = 0;
    }
    print("$_count");
    await setLogLabel("start");
    final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(null);
  }

  Future<void> dispose() async {
    print("***********Dispose callback handler");
    print("$_count");
    await setLogLabel("end");
    final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(null);
  }

  Future<void> callback(LocationDto locationDto) async {
    print('$_count location in dart: ${locationDto.toString()}');
    await setLogPosition(_count, locationDto);
    final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    _count++;

    final postcardNotificationRange =
        await AppSharedPreferences.getNotificationRange();

    print("odległość: $postcardNotificationRange");

    CoordinatesRequest coordinatesRequest = CoordinatesRequest(
      longitude: locationDto.longitude.toString(),
      latitude: locationDto.latitude.toString(),
      postcardNotificationRangeInMeters: postcardNotificationRange.toInt(),
    );

    PostCoordinatesResponse response =
        await collectPostcardService.postCoordinates(coordinatesRequest);

    print(
        "Recived: ${response.postcardsCollected?.length}, and ${response.postcardsNearby?.length}");

    _cyclesCount += 1;

    final List<int> storedPostcardsNearbyIds =
        await AppSharedPreferences.getPostcardsNearbyIdList();

    List<int> newPostcardIds = (response.postcardsCollected
            ?.map((postcard) => postcard.id)
            .whereType<int>()
            .where((id) => !storedPostcardsNearbyIds.contains(id))
            .toList()) ??
        [];

    if (newPostcardIds.isNotEmpty) {
      NotificationService().showNotification(
          title: "New Postcard",
          body: "There are new postcards ready to collect!");

      storedPostcardsNearbyIds.addAll(newPostcardIds);
      await AppSharedPreferences.savePostcardsNearbyIdList(
          storedPostcardsNearbyIds);
    }

    if (_cyclesCount > 360) {
      _cyclesCount = 0;
      await AppSharedPreferences.savePostcardsNearbyIdList([]);
    }

    send?.send(response.toJson());
  }

  static Future<void> setLogLabel(String label) async {
    final date = DateTime.now();
    await FileManager.writeToLogFile(
        '------------\n$label: ${formatDateLog(date)}\n------------\n');
  }

  static Future<void> setLogPosition(int count, LocationDto data) async {
    final date = DateTime.now();
    await FileManager.writeToLogFile(
        '$count : ${formatDateLog(date)} --> ${formatLog(data)} --- isMocked: ${data.isMocked}\n');
  }

  static double dp(double val, int places) {
    num mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  static String formatDateLog(DateTime date) {
    return "${date.hour}:${date.minute}:${date.second}";
  }

  static String formatLog(LocationDto locationDto) {
    return "${dp(locationDto.latitude, 4)} ${dp(locationDto.longitude, 4)}";
  }
}
