import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/helpers/time_formulars.dart';
import 'package:weather/models/forecast_model.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/pages/forecast_day_details_page.dart';
import 'package:weather/pages/forecast_page.dart';
import 'package:weather/pages/map_page.dart';

Widget imageFromOpenWeather(WeatherModel weather) {
  return Column(
    children: [
      Container(
        color: Colors.lightBlue.withValues(alpha: .4),
        child: ClipRect(
          child: Align(
            widthFactor: 0.5,
            heightFactor: 0.5,
            child: weather.weatherIcon == null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(80),
                      child: Image.asset(
                        'assets/images/all_weather.jpg',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Image.asset(
                    'assets/images/${weather.weatherIcon}.png',
                    width: 200,
                    height: 100,
                    // fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
      Text(
        textAlign: TextAlign.center,
        '${weather.weatherDescription}',
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 10, 104, 13)),
      ),
    ],
  );
}

Widget keyInfo(BuildContext context, WeatherModel weather) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Temperature: ${weather.mainTemmp}°F',
              style: TextStyle(
                fontSize: 25,
                color: Formulas.temperatureColor(weather.mainTemmp),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Feels Like: ${weather.mainFeelsLike}°',
              style: textStyle(18),
            ),
            // Text(
            //   '${weather.weatherDescription}',
            //   style: textStyle(18),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _moreTemperatureInfo(context, weather),
                _windInfo(context, weather),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _sunriseInfo(context, weather),
                _sunsetInfo(context, weather),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _moreTemperatureInfo(BuildContext context, WeatherModel weather) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.15,
    width: MediaQuery.of(context).size.width * .4,
    padding: const EdgeInsets.only(top: 5),
    decoration: boxDecoration(),
    child: Column(
      children: <Widget>[
        Text(
          'Min: ${weather.mainTempMin}°F',
          style: textStyle(15),
        ),
        Text(
          'Max: ${weather.mainTempMax}°F',
          style: textStyle(15),
        ),
        Text(
          'Humidity: ${weather.mainHumidity}',
          style: textStyle(15),
        ),
      ],
    ),
  );
}

Widget _windInfo(BuildContext context, WeatherModel weather) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.15,
    width: MediaQuery.of(context).size.width * .4,
    padding: const EdgeInsets.only(top: 3),
    decoration: boxDecoration(),
    child: Column(
      children: [
        Text(
          'Wind: ${weather.windSpeed} mph',
          style: textStyle(14),
        ),
        Text(
          'Gust: ${weather.windGust} mph',
          style: textStyle(14),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Direction: ${weather.windDeg}°',
              style: textStyle(14),
            ),
            windDirectionPointer(weather),
          ],
        )
      ],
    ),
  );
}

Widget _sunriseInfo(BuildContext context, WeatherModel weather) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.15,
    width: MediaQuery.of(context).size.width * .4,
    decoration: boxDecoration(),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(
              'Sunrise',
              style: textStyle(15),
            ),
            Image.asset('assets/images/sunrise.png', height: 60, width: 60),
            Text(
              weather.sunrise == null ? 'Not Specified' : '${weather.sunrise}',
              style: textStyle(15),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _sunsetInfo(BuildContext context, WeatherModel weather) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.15,
    width: MediaQuery.of(context).size.width * .4,
    decoration: boxDecoration(),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(
              'Sunset',
              style: textStyle(15),
            ),
            Image.asset('assets/images/sunset.png', height: 60, width: 60),
            Text(
              weather.sunset == null ? 'Not Specified' : '${weather.sunset}',
              style: textStyle(15),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget header(WeatherModel weather) {
  return Text(
    textAlign: TextAlign.center,
    '${weather.name!} ${weather.sysCountry}',
    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  );
}

Widget timeInfo(WeatherModel weather) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Center(
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Date: ${Formulas.getDate(weather)}', style: textStyle(10)),
              Text('Time: ${Formulas.getTime(weather)}', style: textStyle(10)),
            ],
          ),
        ),
      ),
    ),
  );
}

TextStyle textStyle(double size) {
  return TextStyle(
    fontSize: size,
    color: const Color.fromARGB(255, 8, 95, 85),
  );
}

BoxDecoration boxDecoration() {
  return BoxDecoration(
    color: const Color.fromARGB(255, 201, 212, 210),
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
          color: const Color.fromARGB(255, 67, 70, 69).withValues(alpha: .5),
          offset: const Offset(15, 15),
          blurRadius: 3,
          spreadRadius: -10)
    ],
  );
}

Widget windDirectionPointer(WeatherModel weather) {
  return Container(
    width: 25,
    height: 25,
    color: Colors.grey.withValues(alpha: .2),
    child: CustomPaint(
      foregroundPainter: CirclePainter(weather: weather),
    ),
  );
}

class CirclePainter extends CustomPainter {
  final WeatherModel weather;
  CirclePainter({required this.weather});

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2;

    final Paint circlePaint = Paint()
      ..strokeWidth = 2
      ..color = Colors.blue
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, circlePaint);

    final Paint pointPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final Paint linePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3;

    final Paint axesPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2;

    // the next four draw the N/S and E/W lines
    double angle = (90.0 - 90.0) * (pi / 180.0);
    double pointX = center.dx + radius * cos(angle);
    double pointY = center.dy + radius * sin(angle);
    canvas.drawLine(center, Offset(pointX, pointY), axesPaint);

    angle = (180.0 - 90.0) * (pi / 180.0);
    pointX = center.dx + radius * cos(angle);
    pointY = center.dy + radius * sin(angle);
    canvas.drawLine(center, Offset(pointX, pointY), axesPaint);

    angle = (270.0 - 90.0) * (pi / 180.0);
    pointX = center.dx + radius * cos(angle);
    pointY = center.dy + radius * sin(angle);
    canvas.drawLine(center, Offset(pointX, pointY), axesPaint);

    angle = (360.0 - 90.0) * (pi / 180.0);
    pointX = center.dx + radius * cos(angle);
    pointY = center.dy + radius * sin(angle);
    canvas.drawLine(center, Offset(pointX, pointY), axesPaint);

    // now we draw the arrow signifying the wind direction
    angle = (weather.windDeg!.toDouble() - 90) * (pi / 180.0);
    pointX = center.dx + radius * cos(angle);
    pointY = center.dy + radius * sin(angle);

    canvas.drawCircle(Offset(pointX, pointY), 2.0, pointPaint);
    canvas.drawLine(center, Offset(pointX, pointY), linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

Widget forecastButton(context, double lat, double lon) {
  return ElevatedButton(
      onPressed: () {
        ForecastModel forecastModel = ForecastModel();
        forecastModel.getDailyForecasts(lat, lon).then(
          (data) {
            List<ForecastModel> forecasts =
                forecastDayCollector(data, lat, lon);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ForecastPage(
                  forecasts: forecasts,
                  lat: lat,
                  lon: lon,
                ),
              ),
            );
          },
        );
      },
      child: const Text(
        'Fifteen Day Forecast',
        style: TextStyle(
          fontSize: 12,
        ),
      ));
}

Widget mapboxButton(context, double lat, double lon) {
  return ElevatedButton(
    onPressed: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => MapPage(
                    latitude: lat,
                    longitude: lon,
                  )));
    },
    child: const Text(
      'Show Map Location',
      style: TextStyle(
        fontSize: 12,
      ),
    ),
  );
}

String datetimeStringToNewFormat(String date) {
  DateTime dt = DateTime.parse(date);
  return DateFormat('EEEE MMM d, yyyy').format(dt).toString();
}

String timeStringToNewFormat(String timeString) {
  var formatter = DateFormat('jm');
  DateTime time = DateTime.parse(timeString);
  return formatter.format(time);
}

List<ForecastModel> forecastDayCollector(
    Map<String, dynamic> data, double lat, double lon) {
  List<ForecastModel> forecasts = [];
  for (var day in data['days']) {
    ForecastModel singleForecast = ForecastModel();
    singleForecast.source = day['source'];
    singleForecast.datetime = day['datetime'];
    singleForecast.description = day['description'];
    singleForecast.sunrise = day['sunrise'];
    singleForecast.sunset = day['sunset'];
    singleForecast.tempmax = day['tempmax'] as double;
    singleForecast.tempmin = day['tempmin'] as double;
    singleForecast.cloudcover = day['cloudcover'] as double;
    singleForecast.humidity = day['humidity'] as double;
    singleForecast.precipprob = day['precipprob'] as double;
    singleForecast.uvindex = day['uvindex'] as double;
    singleForecast.latitude = lat;
    singleForecast.longitude = lon;
    singleForecast.hour = ''; // not used for daily, only hourly
    forecasts.add(singleForecast);
  }
  return forecasts;
}

void hourlyForecastsGestureDoubleTap(
    context, double lat, double lon, String date) {
  ForecastModel forecastModel = ForecastModel();
  forecastModel.getHourlyForecasts(lat, lon, date).then((data) {
    List<ForecastModel> forecasts = forecastHourCollector(data, date);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                DayDetailsForForecast(dayForecasts: forecasts, date: date)));
  });
}

List<ForecastModel> forecastHourCollector(
    Map<String, dynamic> data, String date) {
  List<ForecastModel> forecasts = [];
  for (Map<String, dynamic> hour in data['days'][0]['hours']) {
    ForecastModel singleForecast = ForecastModel();
    if (hour['source'] == 'fcst') {
      singleForecast.temp = hour['temp'] as double;
      singleForecast.humidity = hour['humidity'] as double;
      singleForecast.conditions = hour['conditions'];
      singleForecast.datetime =
          '$date ${hour["datetime"]}'; // even for hour formatting we need real datetimne string

      forecasts.add(singleForecast);
    }
  }
  return forecasts;
}
