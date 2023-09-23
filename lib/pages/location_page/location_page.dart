import 'package:flutter/material.dart';
import 'package:mobile/services/location_service/user_location.dart';
import 'package:provider/provider.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  Widget build(BuildContext context) {
    var userLocation = Provider.of<UserLocation>(context);
    return Scaffold(
      body: Center(
        child: Text(
          'Location: \nLat: ${userLocation.latitude}, \nLong: ${userLocation.longitude}',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
