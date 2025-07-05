import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _targetPercentageKey = 'target_percentage';
  static const String _defaultYearKey = 'default_academic_year';
  static const String _defaultSemesterKey = 'default_semester';

  final ValueNotifier<int> targetPercentageNotifier = ValueNotifier<int>(75);
  final ValueNotifier<String> yearNotifier = ValueNotifier<String>('2024-25');
  final ValueNotifier<String> semesterNotifier = ValueNotifier<String>('odd');

  // Make this public by removing the underscore
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    targetPercentageNotifier.value = prefs.getInt(_targetPercentageKey) ?? 75;
    yearNotifier.value = prefs.getString(_defaultYearKey) ?? '2024-25';
    semesterNotifier.value = prefs.getString(_defaultSemesterKey) ?? 'odd';
  }

  // Public getters
  String get year => yearNotifier.value;
  String get semester => semesterNotifier.value;
  int get targetPercentage => targetPercentageNotifier.value;

  Future<void> setTargetPercentage(int percentage) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_targetPercentageKey, percentage);
    targetPercentageNotifier.value = percentage;
  }

  Future<void> setAcademicYear(String year) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_defaultYearKey, year);
    yearNotifier.value = year;
  }

  Future<void> setSemester(String semester) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_defaultSemesterKey, semester);
    semesterNotifier.value = semester;
  }
}