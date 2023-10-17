import 'package:permission_handler/permission_handler.dart';

Future<bool> checkGpsStatus() async {
  var isEnabled = await Permission.location.serviceStatus.isEnabled;
  return isEnabled;
}