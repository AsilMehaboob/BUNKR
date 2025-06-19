import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _targetPercentageKey = 'target_percentage';
  final ValueNotifier<int> targetPercentageNotifier = ValueNotifier<int>(75);

  SettingsService() {
    _loadTargetPercentage();
  }

  Future<void> _loadTargetPercentage() async {
    final prefs = await SharedPreferences.getInstance();
    final percentage = prefs.getInt(_targetPercentageKey) ?? 75;
    targetPercentageNotifier.value = percentage;
  }

  Future<void> setTargetPercentage(int percentage) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_targetPercentageKey, percentage);
    targetPercentageNotifier.value = percentage;
  }
}