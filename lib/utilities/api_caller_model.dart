import 'package:covidinfo/utilities/current_location.dart';
import 'package:covidinfo/utilities/smartable_ai_api_caller.dart';
import 'package:covidinfo/utilities/weather_api_caller.dart';

class ApiCallerModel {
  Future<List<dynamic>> getWeatherAndCovidForCurrentLocation() async {
    LatLongCoordinates coords = await Location().getCurrentLocation();
    var weatherDataJson = await WeatherApiCaller()
        .getWeatherForLatLong(coords.latitude, coords.longitude);
    var covidDataJson = await SmartableAiApiCaller()
        .getCovidStatsForCountryTag(weatherDataJson["sys"]["country"]);
    return [weatherDataJson, covidDataJson];
  }
}