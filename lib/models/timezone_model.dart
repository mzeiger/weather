import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather/api/api.dart';

class TimeZoneModel {
  String? timeZone, currentLocalTime;
  bool? hasDaylightSaving, isDayLightSavingActive;

  TimeZoneModel(
      {timeZone, currentLocalTime, hasDaylightSaving, isDayLightSavingActive});

  Future<Map<String, dynamic>> getTimeZoneDateTime(
      double lat, double lon) async {
    try {
      String url = '${timeZoneUrl}latitude=${lat}&longitude=${lon}';
      final response = await http.get(Uri.parse(url));

      Map<String, dynamic> dataMap = jsonDecode(response.body);
      return dataMap;
    } catch (e) {
      return populateUnknownTimeZoneModel();
    }
  }
}

populateUnknownTimeZoneModel() {
  return {"timeZone": "", "currentLocalTime": ""};
}
