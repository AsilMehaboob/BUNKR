// settings_service.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _targetPercentageKey = 'target_percentage';
  static const String _semesterKey = 'selected_semester';
  static const String _yearKey = 'selected_year';
  
  final ValueNotifier<int> targetPercentageNotifier = ValueNotifier<int>(75);
  final ValueNotifier<String> semesterNotifier = ValueNotifier<String>('even');
  final ValueNotifier<String> yearNotifier = ValueNotifier<String>('');

  SettingsService() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load target percentage
    targetPercentageNotifier.value = prefs.getInt(_targetPercentageKey) ?? 75;
    
    // Load semester with fallback
    semesterNotifier.value = prefs.getString(_semesterKey) ?? 'even';
    
    // Calculate and load academic year
    final storedYear = prefs.getString(_yearKey);
    yearNotifier.value = storedYear ?? _getCurrentAcademicYear();
  }

  String _getCurrentAcademicYear() {
    final now = DateTime.now();
    int startYear, endYear;
    
    if (now.month < 8) { // January to July
      startYear = now.year - 1;
      endYear = now.year;
    } else { // August to December
      startYear = now.year;
      endYear = now.year + 1;
    }
    return '$startYear-${endYear.toString().substring(2)}';
  }

  Future<void> setTargetPercentage(int percentage) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_targetPercentageKey, percentage);
    targetPercentageNotifier.value = percentage;
  }

  Future<void> setSemester(String semester) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_semesterKey, semester);
    semesterNotifier.value = semester;
  }

  Future<void> setYear(String year) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_yearKey, year);
    yearNotifier.value = year;
  }
}