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
      child: Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: const Text('Weather Details'),
          centerTitle: true,
          backgroundColor: Colors.lightBlue,
        ),
        body: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/pexels-pixabay-314726.jpg'),
                fit: BoxFit.cover),
          ),
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height,
            child: Column(
              spacing: 6,
              children: <Widget>[
                const SizedBox(height: 6),
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
    );
  }
}
