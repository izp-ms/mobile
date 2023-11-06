import 'package:flutter/material.dart';
import 'package:mobile/helpers/shared_preferences.dart';

class MetricSystemProvider extends ChangeNotifier {
  late bool _isMetric;
  bool get isMetric => _isMetric;

  MetricSystemProvider() {
    _isMetric = false;
    getPreferences();
  }

  set isMetric(bool value) {
    _isMetric = value;
    AppSharedPreferences.saveMetricSystemPreference(value);
    notifyListeners();
  }

  getPreferences() async {
    _isMetric = await AppSharedPreferences.getMetricSystemPreference();
    notifyListeners();
  }
}