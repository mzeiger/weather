import 'package:geocoding/geocoding.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GeoModel {
  String? administrativeArea; //state
  String? country; // i.e. United stateds of america
  String? isoCountryCode; // i.e. US
  String? locality; // city name
  String? street; // whole house number and street
  String? postalCode;
  String? subAdministrativeArea; // i.e. county
  String? thoroughfare; // street without house numner
  String? sunrise, sunset; // these come from a different query

  GeoModel(
      {administrativeArea, //state
      country, // i.e. United stateds of america
      isoCountryCode, // i.e. US
      locality, // city name
      street, // whole house number and street
      postalCode,
      subAdministrativeArea, // i.e. county
      thoroughfare,
      sunrise,
      sunset});

  Future<Placemark> getLocationByLatLon(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      return placemarks[0];
    } catch (e) {
      //throw (Exception(e.toString()));
      return populateUnknownPlacemark();
    }
  }

  Placemark populateUnknownPlacemark() {
    return const Placemark(
        administrativeArea: "",
        country: "",
        isoCountryCode: "",
        locality: "",
        name: "",
        postalCode: "",
        street: "",
        subAdministrativeArea: "",
        subLocality: "",
        subThoroughfare: "",
        thoroughfare: "");
  }

  Future<Map<String, dynamic>> getSunriseSunset(double lat, double lon) async {
    try {
      String url = 'https://api.sunrisesunset.io/json?lat=$lat&lng=$lon';
      final response = await http.get(Uri.parse(url));
      Map<String, dynamic> sun = jsonDecode(response.body);
      return sun;
    } catch (e) {
      throw Exception(e);
    }
  }
}
