import 'dart:convert';
import 'package:intern_flutter/models/internModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  // Save InternModel to SharedPreferences
Future<void> saveInternModel(internModel intern) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String internJson = jsonEncode(intern.toJson()
    ..update('birthday', (value) => value?.toIso8601String())
    ..update('startDate', (value) => value?.toIso8601String()));
  await prefs.setString('internModel', internJson);
}

// Retrieve a specific value from InternModel JSON in SharedPreferences
  Future<String?> getInternData(String fieldKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? internJson = prefs.getString('internModel');
    if (internJson != null) {
      Map<String, dynamic> internMap = jsonDecode(internJson);
      return internMap[fieldKey]; // Access the value using the provided key
    }
    return null;
  }
}