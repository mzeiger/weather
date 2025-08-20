import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather/models/geo_model.dart';
import 'package:weather/models/timezone_model.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/pages/weather_lon_lat_page.dart';

class WeatherFromMapPage extends StatefulWidget {
  const WeatherFromMapPage({super.key});

  @override
  State<WeatherFromMapPage> createState() => _WeatherFromMapPageState();
}

class _WeatherFromMapPageState extends State<WeatherFromMapPage> {
  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  WeatherModel weatherModel = WeatherModel();
  GeoModel geoModel = GeoModel();
  TimeZoneModel timeZoneModel = TimeZoneModel();
  final MapController _mapController = MapController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Map Search'),
          backgroundColor: Colors.lightBlue,
        ),
        body: Column(
          children: [
            Expanded(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: const LatLng(0, 0),
                  initialZoom: 400,
                  maxZoom: 500,
                  minZoom: 10,
                  onTap: (pos, point) {
                    // String pointText =
                    //     "Longitude: ${point.longitude} Latitude: ${point.latitude}";
                    // print(pointText);
                    showWeather(point);
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  const CurrentLocationLayer(
                    style: LocationMarkerStyle(
                        marker: DefaultLocationMarker(
                          child: Icon(
                            Icons.location_pin,
                            color: Colors.white,
                          ),
                        ),
                        markerSize: Size(35, 35),
                        markerDirection: MarkerDirection.heading),
                  ),
                ],
              ),
            ),
            const Text('Tap on map to get weather at that location')
          ],
        ),
      ),
    );
  }

  void showWeather(LatLng currentPosition) {
    EasyLoading.show(status: 'Loading...');

    timeZoneModel
        .getTimeZoneDateTime(
            currentPosition.latitude, currentPosition.longitude)
        .then(
      (tz) {
        geoModel
            .getLocationByLatLon(
                currentPosition.latitude, currentPosition.longitude)
            .then(
          (geoMap) {
            geoModel
                .getSunriseSunset(
                    currentPosition.latitude, currentPosition.longitude)
                .then(
              (sun) {
                GeoModel geo = populateGeoModel(geoModel, geoMap, sun);

                weatherModel
                    .getVisualCrossingWeather(
                        '${currentPosition.latitude},${currentPosition.longitude}')
                    .then(
                  (weatherResponse) {
                    if (weatherResponse['queryCost'] == null) {
                      if (mounted) {
                        EasyLoading.dismiss();
                        showErrorDialog(context,
                            "${weatherResponse['cod']}: ${weatherResponse['message']}");
                      }
                    } else {
                      WeatherModel weather = populateWeatherModel(
                          weatherModel, weatherResponse, sun, tz);
                      if (mounted) {
                        EasyLoading.dismiss();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                WeatherLLPage(geoModel: geo, weather: weather),
                          ),
                        ).whenComplete(() =>
                            FocusManager.instance.primaryFocus!.unfocus());
                      }
                    }
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  WeatherModel populateWeatherModel(
      WeatherModel model,
      Map<String, dynamic> data,
      Map<String, dynamic> geo,
      Map<String, dynamic> tz,
      [Map<String, dynamic>? zip]) {
    try {
      Map<String, dynamic> dataCurrent = data['days'][0];
      model.weatherDescription = dataCurrent['description'] ?? '';
      model.weatherIcon = dataCurrent['icon'] ?? '';
      model.mainTemmp = dataCurrent['temp'] ?? -1000000000000.0;
      model.mainFeelsLike = dataCurrent['feelslike'] ?? -0.0;
      model.mainTempMin = dataCurrent['tempmin'] ?? -1000000000000.0;
      model.mainTempMax = dataCurrent['tempmax'] ?? -1000000000000.0;
      model.mainPressure = dataCurrent['pressure'] ?? -1000000000000;
      model.mainHumidity = dataCurrent['humidity'] ?? -1000000000000;
      model.windSpeed = dataCurrent['windspeed'] ?? -10000.0;
      model.windDeg = dataCurrent['winddir'] ?? 0;
      model.windGust = dataCurrent['windgust'] ?? -1000000000000.0;
      model.sysSunrise = dataCurrent['sunriseEpoch'] ?? -1000000000000;
      model.sysSunSet = dataCurrent['sunsetEpoch'] ?? -1000000000000;
      model.sysCountry = '';
      if (zip == null) {
        model.name = data['resolvedAddress'] ?? '---';
      } else {
        model.name =
            "${zip['places'][0]['place name']}, ${zip['places'][0]['state abbreviation']} ${zip['country abbreviation']}";
      }
      model.timezone = data['tzoffset'] ?? -1000000000000;
      model.coordLatitude = data['latitude'] ?? -1000000000000.0;
      model.coordLongitude = data['longitude'] ?? -1000000000000.0;
      model.date = dataCurrent['datetimeEpoch'] ?? -1000000000000;
      model.sunrise = geo['results']['sunrise'];
      model.sunset = geo['results']['sunset'];
      model.currentLocalTime = tz['currentLocalTime'];
      model.hasDaylightSaving = tz['hasDayLightSaving'];
      model.isDayLightSavingActive = tz['isDayLightSavingActive'];
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return model;
  }

  GeoModel populateGeoModel(
      GeoModel model, Placemark placeMark, Map<String, dynamic> sun) {
    model.administrativeArea = placeMark.administrativeArea ?? '';
    model.country = placeMark.country ?? '';
    model.isoCountryCode = placeMark.isoCountryCode ?? '';
    model.locality = placeMark.locality ?? '';
    model.postalCode = placeMark.postalCode ?? '';
    model.street = placeMark.street ?? '';
    model.subAdministrativeArea = placeMark.subAdministrativeArea ?? '';
    model.thoroughfare = placeMark.thoroughfare ?? '';
    model.sunrise = sun['results']['sunrise'] ?? '';
    model.sunset = sun['results']['sunset'] ?? '';
    return model;
  }

  void showErrorDialog(context, String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => PopScope(
        canPop: false,
        child: SimpleDialog(
          title: const Text(
            'ERROR',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.all(60.0),
              child: TextButton(
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.lightBlue)),
                onPressed: () {
                  Navigator.of(context).pop();

                  FocusScope.of(context)
                      .unfocus(); // This will dismiss the keyboard.
                },
                child: const Text(
                  'Close',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
