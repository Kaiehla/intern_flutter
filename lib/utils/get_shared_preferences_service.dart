import 'dart:convert';
import 'package:intern_flutter/models/internModel.dart';
import 'package:shared_preferences/shared_preferences.dart';


class get_shared_preferences_service {
  Future<internModel?> getIntern() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? internJson = prefs.getString('intern_data'); // Retrieve JSON string

    if (internJson == null) return null; // Return null if no data exists

    Map<String, dynamic> userMap = jsonDecode(internJson); // Decode JSON string
    return internModel.fromJson(userMap); // Convert JSON to model
  }
}
