import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/helpers/appid_singleton.dart';
import 'package:weather/helpers/location_permission.dart';
import 'package:weather/models/geo_model.dart';
import 'package:weather/models/timezone_model.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/pages/gps_page.dart';
import 'package:weather/pages/help_pages/main_help_page.dart';
import 'package:weather/pages/set_appid_page.dart';
import 'package:weather/pages/weather_from_map_page.dart';
import 'package:weather/pages/weather_lon_lat_page.dart';
import 'package:weather/pages/weather_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _zipFormKey = GlobalKey<FormState>();
  final _cityFormKey = GlobalKey<FormState>();
  final _zipRegExp = RegExp(r'\d\d\d\d\d');
  WeatherModel weatherModel = WeatherModel();
  GeoModel geoModel = GeoModel();
  TimeZoneModel timeZoneModel = TimeZoneModel();
  bool _canGetWeatherByCurrentLocation = true;

  @override
  void initState() {
    super.initState();
    requestLocationPermission().then((val) {
      setState(() {
        if (val) {
          _canGetWeatherByCurrentLocation = true;
        } else {
          _canGetWeatherByCurrentLocation = false;
        }
      });
    });
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.dualRing
      ..indicatorSize = 45.0
      ..radius = 10
      ..backgroundColor = Colors.yellow;
    putAppIdInAppIdSingleton();
  }

  Future<void> putAppIdInAppIdSingleton() async {
    final prefs = await SharedPreferences.getInstance();
    String appId = prefs.getString('appId')!;
    AppIdSingleton.instance.setAppId(appId);
  }

  @override
  void dispose() {
    _cityZipController.dispose();
    zipController.dispose();
    super.dispose();
  }

  final TextEditingController _cityZipController = TextEditingController();
  final TextEditingController zipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Column(children: <Widget>[
            Text('OmniWeather'),
            Text(
              'Data courtesy of VisualCrossing.com',
              style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.white),
              textAlign: TextAlign.left,
            )
          ]),
          backgroundColor: Colors.lightBlue,
        ),
        endDrawer: _buildEndDraw(),
        body: SingleChildScrollView(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/pexels-pixabay-314726.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: Column(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 15),
                  // City/Address Entry
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Color.fromRGBO(156, 156, 199, 0.37)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                          child: Column(
                            children: [
                              const Text(
                                textAlign: TextAlign.center,
                                'Enter a location (city or address)\nand press ENTER',
                                style: TextStyle(fontSize: 18),
                              ),
                              cityInput(),
                            ],
                          ),
                        )),
                  ),

                  const SizedBox(height: 10),
                  // Zipcode entry

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color.fromRGBO(156, 156, 199, 0.37)),
                      child: Column(
                        children: [
                          const Text(
                            textAlign: TextAlign.center,
                            'Enter a U.S. Zipcode\nand press ENTER',
                            style: TextStyle(fontSize: 18),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                            child: zipcodeInput(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(thickness: 5),
                  ),
                  weatherByCurrentLocation(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(thickness: 5),
                  ),
                  clickOnMapToGetWeather(),
                  gpsButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget cityInput() {
    return Form(
      key: _cityFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a city or address';
                } else {
                  return null;
                }
              },
              controller: _cityZipController,
              decoration: InputDecoration(
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                suffixIcon: IconButton(
                  onPressed: () => _cityZipController.text = '',
                  icon: const Icon(Icons.clear),
                ),
              ),
              onEditingComplete: () {
                if (_cityFormKey.currentState!.validate()) {
                  _performCityPressed(_cityZipController.text);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _performCityPressed(String location) {
    {
      FocusScope.of(context).unfocus();
      EasyLoading.show(status: 'Loading...');
      weatherModel.getVisualCrossingWeather(location).then(
        (weatherResponse) {
          //  if (weatherResponse['cod'] != 200) {
          if (weatherResponse['queryCost'] == null) {
            if (mounted) {
              EasyLoading.dismiss();
              showErrorDialog(context,
                  "${weatherResponse['cod']}: ${weatherResponse['message']}");
            }
          } else {
            geoModel
                .getSunriseSunset(
                    weatherResponse['latitude'], weatherResponse['longitude'])
                .then(
              (geo) {
                timeZoneModel
                    .getTimeZoneDateTime(weatherResponse['latitude'],
                        weatherResponse['longitude'])
                    .then(
                  (tz) {
                    WeatherModel weather = populateWeatherModel(
                        weatherModel, weatherResponse, geo, tz);
                    if (mounted) {
                      EasyLoading.dismiss();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WeatherPage(weather: weather),
                        ),
                      ).whenComplete(
                          () => FocusManager.instance.primaryFocus!.unfocus());
                    }
                  },
                );
              },
            );
          }
        },
      );
    }
  }

  Widget zipcodeInput() {
    // TextEditingController zipController = TextEditingController();
    return Form(
      key: _zipFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              validator: (value) {
                if (_zipRegExp.hasMatch(value!)) {
                  return null;
                } else {
                  return 'Enter a valid 5-digit zip code';
                }
              },
              controller: zipController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                // label: const Text('Enter a U.S. Zipcode'),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                suffixIcon: IconButton(
                  onPressed: () => zipController.clear(),
                  icon: const Icon(Icons.clear),
                ),
              ),
              maxLength: 5,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              onEditingComplete: () {
                if (_zipFormKey.currentState!.validate()) {
                  performZipPressed(zipController.text);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void performZipPressed(String zipCode) {
    {
      FocusScope.of(context).unfocus();
      EasyLoading.show(status: 'Loading...');
      weatherModel.getVisualCrossingWeather(zipCode).then(
        (weatherResponse) {
          if (weatherResponse['queryCost'] == null) {
            if (mounted) {
              EasyLoading.dismiss();
              showErrorDialog(context,
                  "${weatherResponse['cod']}: ${weatherResponse['message']}");
            }
          } else {
            weatherModel.getLocationFromZipCode(zipCode).then(
              (zipCodeResponse) {
                geoModel
                    .getSunriseSunset(weatherResponse['latitude'],
                        weatherResponse['longitude'])
                    .then(
                  (geo) {
                    timeZoneModel
                        .getTimeZoneDateTime(weatherResponse['latitude'],
                            weatherResponse['longitude'])
                        .then(
                      (tz) {
                        WeatherModel weather = populateWeatherModel(
                            weatherModel,
                            weatherResponse,
                            geo,
                            tz,
                            zipCodeResponse);
                        if (mounted) {
                          EasyLoading.dismiss();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WeatherPage(weather: weather),
                            ),
                          ).whenComplete(() =>
                              FocusManager.instance.primaryFocus!.unfocus());
                        }
                      },
                    );
                  },
                );
              },
            );
          }
        },
      );
    }
  }

  Widget weatherByCurrentLocation() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue)),
            child: Text(
              _canGetWeatherByCurrentLocation
                  ? 'Get Current Weather at this Location'
                  : 'Location services are disabled',
              style: const TextStyle(color: Colors.white),
            ),
            onPressed: () {
              if (!_canGetWeatherByCurrentLocation) {
                return;
              }
              EasyLoading.show(status: 'Loading...');
              Geolocator.getCurrentPosition().then(
                (currentPosition) {
                  // now have lat and long
                  timeZoneModel
                      .getTimeZoneDateTime(
                          currentPosition.latitude, currentPosition.longitude)
                      .then(
                    (tz) {
                      geoModel
                          .getLocationByLatLon(currentPosition.latitude,
                              currentPosition.longitude)
                          .then(
                        (geoMap) {
                          geoModel
                              .getSunriseSunset(currentPosition.latitude,
                                  currentPosition.longitude)
                              .then(
                            (sun) {
                              GeoModel geo =
                                  populateGeoModel(geoModel, geoMap, sun);

                              weatherModel
                                  .getVisualCrossingWeather(
                                      '${currentPosition.latitude},${currentPosition.longitude}')
                                  // .getWeatherByCurrentLoaction(
                                  //     currentPosition.latitude,
                                  //     currentPosition.longitude)
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
                                          builder: (_) => WeatherLLPage(
                                              geoModel: geo, weather: weather),
                                        ),
                                      ).whenComplete(() => FocusManager
                                          .instance.primaryFocus!
                                          .unfocus());
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
                },
              );
            },
          )
        ],
      ),
    );
  }

  Widget clickOnMapToGetWeather() {
    return TextButton(
      onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const WeatherFromMapPage())),
      style: const ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.blue),
      ),
      child: const Text(
        'Get Weather From Map',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget gpsButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const GpsPage()));
      },
      style: const ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.blue),
      ),
      child: const Text(
        'GPS Page',
        style: TextStyle(color: Colors.white),
      ),
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

  Widget _buildEndDraw() {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.5,
      backgroundColor: const Color.fromARGB(192, 180, 192, 224),
      child: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .09,
            child: const DrawerHeader(
              child: Text(
                'Settings',
                style: TextStyle(
                  color: Color.fromARGB(255, 4, 45, 78),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('Delete AppId'),
            onTap: () {
              deleteAppId();
              Navigator.pop(context);
              FocusManager.instance.primaryFocus!.unfocus();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const SetAppIdPage()));
            },
          ),
          ListTile(
              title: const Text('Help Pages'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const HelpSession()));
              })
        ],
      ),
    );
  }

  Future<void> deleteAppId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('appId');
  }
}
