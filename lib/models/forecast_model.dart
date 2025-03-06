import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:weather/api/api.dart';

class ForecastModel {
  String? datetime, description, sunrise, sunset, source, hour, conditions;
  double? tempmax,
      tempmin,
      cloudcover,
      humidity,
      latitude,
      longitude,
      precipprob,
      uvindex,
      temp;

  ForecastModel({
    source,
    datetime,
    description,
    sunrise,
    sunset,
    tempmax,
    tempmin,
    cloudcover,
    precipprob,
    humidity,
    latitude,
    longitude,
    hour, //hour not used for daily forecasts, only hourly forecasts
    temp, // only used for hourlym forecasts
    conditions, // only used in hours
  }); //hour not used for daily forecasts, only hourly forecasts

  Future<Map<String, dynamic>> getDailyForecasts(
      double latitude, double longitude) async {
    try {
      String url =
          '${vcLatLonUrl_1}${latitude},${longitude}${vcLatLonUrl_2Days}$vcKey';
      final response = await http.get(Uri.parse(url));
      Map<String, dynamic> dataMap = jsonDecode(response.body);
      logResponse(dataMap['currentConditions']);
      return dataMap;
    } catch (e) {
      if (kDebugMode) {
        print('Exception: $e');
      }
      return {'x', e} as Map<String, dynamic>;
    }
  }

  void logResponse(Map<String, dynamic> response) {
    final logger = Logger();
    final prettyString = const JsonEncoder.withIndent('  ').convert(response);
    logger.d(prettyString);
  }

  Future<Map<String, dynamic>> getHourlyForecasts(
      double latitude, double longitude, String date) async {
    try {
      String url =
          '${vcLatLonUrl_1}${latitude},${longitude}/${date}${vcLatLonUrl_2Hours}$vcKey';
      final response = await http.get(Uri.parse(url));
      Map<String, dynamic> dataMap = jsonDecode(response.body);
      return dataMap;
    } catch (e) {
      if (kDebugMode) {
        print('Exception: $e');
      }
      return {'x', e} as Map<String, dynamic>;
    }
  }
}
