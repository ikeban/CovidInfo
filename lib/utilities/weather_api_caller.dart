import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherApiCaller {
  static const _openWeatherKey = "3c09e33885894a5ef4f314b3c43f1220";
  static const _openWeatherUrl =
      "https://api.openweathermap.org/data/2.5/weather";

  Future<dynamic> getWeatherForCity(String cityName) async {
    http.Response res = await http.get(
        "$_openWeatherUrl?q=$cityName&appid=$_openWeatherKey&units=metric");
    if (res.statusCode == 200) {
      String data = res.body;
      return json.decode(data);
    } else {
      print(res.statusCode);
    }
  }

  Future getWeatherForLatLong(double lat, double long) async {
    http.Response res = await http.get(
        "$_openWeatherUrl?lat=$lat&lon=$long&appid=$_openWeatherKey&units=metric");
    if (res.statusCode == 200) {
      String data = res.body;
      return json.decode(data);
    } else {
      print(res.statusCode);
    }
  }
}
