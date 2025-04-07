import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:weather/api/api.dart';

class WeatherModel {
  double? coordLongitude, coordLatitude;
  String? weatherMain, weatherDescription, weatherIcon;
  double? mainTemmp, mainFeelsLike, mainTempMin, mainTempMax;
  double? mainPressure, mainHumidity;
  double? windSpeed, windGust;
  double? windDeg;
  int? sysSunrise, sysSunSet;
  String? sysCountry;
  String? name; // the city name
  double? timezone;
  int? date;
  // the next come from GeoModel
  String? sunrise, sunset;
  // the next come from the TimeZone API and TimeZoneModel
  String? currentLocalTime;
  bool? hasDaylightSaving, isDayLightSavingActive;

  WeatherModel(
      {weatherMain,
      weatherDescription,
      weatherIcon,
      mainTemmp,
      mainFeelsLike,
      mainTempMin,
      mainTempMax,
      mainPressure,
      mainHumidity,
      windSpeed,
      windDeg,
      windGust,
      sysSunrise, // not used
      sysSunSet, // not used
      sysCountry,
      name,
      timezone,
      coordLatitude,
      coordLongitude,
      date,
      // the next come from GeoModel
      sunrise,
      sunset,
      // the next come from the TimeZone API and TimeZoneModel
      currentLocalTime,
      hasDayLightSavingTime,
      isDayLightSavingTimeActive});

  Future<Map<String, dynamic>> getVisualCrossingWeather(String cityCode) async {
    try {
      Map<String, dynamic> queryParams = {
        "unitGroup": "us",
        "include": "current,days",
        "key": vcKey1, //AppIdSingleton.instance.getAppId(), // appId,
        "contentType": "json"
      };
      String url = '$vcCurrentConditions$cityCode';
      final response =
          await http.get(Uri.parse(url).replace(queryParameters: queryParams));
      String decodedBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> dataMap = jsonDecode(decodedBody);
      return dataMap;
    } catch (e) {
      if (kDebugMode) {
        print('Exception: $e');
      }
      // throw Exception('Bad request parameters');
      return <String, dynamic>{
        'cod': 'Bad request',
        "message": 'Location not found'
      };
    }
  }

  Future<Map<String, dynamic>> getLocationFromZipCode(String zipCode) async {
    String url = 'https://api.zippopotam.us/us/$zipCode';
    final response = await http.get(Uri.parse(url));
    Map<String, dynamic> location = jsonDecode(response.body);
    return location;
  }

  // Future<Map<String, dynamic>> getWeatherByCurrentLoaction(
  //     double latitude, double longitude) async {
  //   try {
  //     //String url = '${urlPrefix}lat=$latitude&lon=$longitude&appid=$appId';
  //     Map<String, dynamic> queryParams = {
  //       "units": "imperial",
  //       "appid": AppIdSingleton.instance.getAppId(), //appId,
  //       "lat": latitude.toString(),
  //       "lon": longitude.toString()
  //     };
  //     String url = urlPrefix2;
  //     final response =
  //         await http.get(Uri.parse(url).replace(queryParameters: queryParams));
  //     Map<String, dynamic> dataMap = jsonDecode(response.body);
  //     return dataMap;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Exception: $e');
  //     }
  //     return {'x', e} as Map<String, dynamic>;
  //   }
  // }
}
