import 'dart:convert';
import 'package:intern_flutter/models/internModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class shared_preferences_service {
  Future<void> saveIntern(internModel intern) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String internJson = jsonEncode(intern.toJson()); // Convert model to JSON string
    await prefs.setString('intern_data', internJson); // Save JSON string
  }
}