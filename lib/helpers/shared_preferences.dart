import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  static Future<void> saveMetricSystemPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('switchMetricSystemValue', value);
  }

  static Future<bool> getMetricSystemPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('switchMetricSystemValue') ?? false;
  }

  static Future<void> saveThemePreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('switchThemeValue', value);
  }

  static Future<bool> getThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('switchThemeValue') ?? false;
  }

  static Future<void> saveDatePreference(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('toggleDateValue', value);
  }

  static Future<String> getDatePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('toggleDateValue') ?? "DD.MM.YYYY";
  }

  static Future<void> saveLanguagePreference(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageValue', value);
  }

  static Future<String> getLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('languageValue') ?? "English";
  }

  static Future<void> saveLocationPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('locationValue', value);
  }

  static Future<bool> getLocationPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('locationValue') ?? false;
  }

  static Future<void> saveNotificationRange(double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('notificationRange', value);
  }

  static Future<double> getNotificationRange() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    return prefs.getDouble('notificationRange') ?? 1000;
  }

  static Future<void> savePostcardsNearbyIdList(List<int> postcardIds) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('postcardsNearbyList', postcardIds.map((id) => id.toString()).toList());
  }

  static Future<List<int>> getPostcardsNearbyIdList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? postcardIdsAsString = prefs.getStringList('postcardsNearbyList');
    if (postcardIdsAsString != null) {
      return postcardIdsAsString.map((id) => int.parse(id)).toList();
    } else {
      return [];
    }
  }
}
