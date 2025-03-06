import 'package:flutter/material.dart';
import 'package:weather/Widgets/weather_widgets.dart';
import 'package:weather/helpers/state_abreviations.dart';
import 'package:weather/helpers/time_formulars.dart';
import 'package:weather/models/geo_model.dart';
import 'package:weather/models/weather_model.dart';

class WeatherLLPage extends StatelessWidget {
  const WeatherLLPage(
      {required this.geoModel, super.key, required this.weather});

  final GeoModel geoModel;
  final WeatherModel weather;

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
                  fit: BoxFit.cover)),
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 5,
                children: [
                  const SizedBox(height: 10),
                  _location(),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _location() {
    return Column(
      children: [
        Text('${geoModel.street}', style: textStyle(20)),
        Text(
          '${geoModel.locality}, ${StateAbreviations.getStateAbrevaition(geoModel.administrativeArea!)} ${geoModel.postalCode}',
          style: textStyle(20),
        ),
        Text(
          '${geoModel.country}',
          style: textStyle(20),
        )
      ],
    );
  }
}
