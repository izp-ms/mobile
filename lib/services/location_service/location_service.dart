import 'dart:async';

import 'package:location/location.dart';
import 'package:mobile/services/location_service/user_location.dart';

class LocationService {
  late UserLocation _currentLocation;
  var location = Location();

  Future<UserLocation> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
        latitude: userLocation.latitude ?? 0,
        longitude: userLocation.longitude ?? 0,
      );
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }
    return _currentLocation;
  }

  final StreamController<UserLocation> _locationController =
  StreamController<UserLocation>();

  Stream<UserLocation> get locationStream => _locationController.stream;

  LocationService() {
    location.enableBackgroundMode(enable: true);
    location.requestPermission().then((permissionStatus) {
      if (permissionStatus == PermissionStatus.granted) {
        var previousLocationData = UserLocation(
          latitude: 0.0,
          longitude: 0.0,
        );
        location.onLocationChanged.listen((locationData) {
          if (locationData.latitude != previousLocationData.latitude ||
              locationData.longitude != previousLocationData.longitude) {
            print("Location changed");
            _locationController.add(UserLocation(
              latitude: locationData.latitude ?? 0,
              longitude: locationData.longitude ?? 0,
            ));
            previousLocationData = UserLocation(
              latitude: locationData.latitude ?? 0,
              longitude: locationData.longitude ?? 0,
            );
          }
        });
      }
    });
  }
}