import 'package:flutter/material.dart';
import 'package:weather/Widgets/weather_widgets.dart';
import 'package:weather/helpers/time_formulars.dart';
import 'package:weather/models/forecast_model.dart';
import 'package:weather/models/weather_model.dart';

class WeatherPage extends StatelessWidget {
  final WeatherModel weather;

  WeatherPage({required this.weather, super.key});
  final ForecastModel forecastModel = ForecastModel();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Weather Details'),
              centerTitle: true,
              backgroundColor: Colors.lightBlue,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context)
                    ..pop()
                    ..pop();
                  FocusScope.of(context).unfocus();
                }, // This will dismiss the keyboard.
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
            ),
            body: Container(
              height: MediaQuery.sizeOf(context).height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(55, 110, 110, 241),
                      Color.fromARGB(120, 13, 13, 77),
                    ]),
              ),
              child: Column(
                spacing: 8,
                children: <Widget>[
                  header(weather),
                  imageFromOpenWeather(weather),
                  Text(
                    '${Formulas.getDate(weather)}  ${Formulas.getTime(weather)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  keyInfo(context, weather),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: 8,
                    children: [
                      forecastButton(context, weather.coordLatitude!,
                          weather.coordLongitude!),
                      mapboxButton(context, weather.coordLatitude!,
                          weather.coordLongitude!),
                    ],
                  )
                  // timeInfo(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
