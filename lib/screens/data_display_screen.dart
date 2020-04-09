import 'package:covidinfo/screens/city_picker_screen.dart';
import 'package:covidinfo/utilities/api_caller_model.dart';
import 'package:covidinfo/utilities/weather_model.dart';
import 'package:flutter/material.dart';

class DataDisplayScreen extends StatefulWidget {
  DataDisplayScreen({@required locationWeather, @required covidData})
      : assert(locationWeather != null, 'You have to specify locationWeather'),
        assert(covidData != null, 'You have to specify covidData'),
        _locationWeather = locationWeather,
        _covidData = covidData;

  final _locationWeather;
  final _covidData;

  @override
  _DataDisplayScreenState createState() => _DataDisplayScreenState();
}

class CovidDataParser {
  int totalConfirmedCases = 0;
  int newlyConfirmedCases = 0;
  int totalDeaths = 0;
  int newDeaths = 0;
  int totalRecoveredCases = 0;
  int newlyRecoveredCases = 0;
  String countryName = "";
  String updatedDateTime = "";

  void parse(dynamic covidDataJson) {
    countryName = covidDataJson['location']['countryOrRegion'];
    updatedDateTime = covidDataJson['updatedDateTime'];
    totalConfirmedCases = covidDataJson['stats']['totalConfirmedCases'];
    newlyConfirmedCases = covidDataJson['stats']['newlyConfirmedCases'];
    totalDeaths = covidDataJson['stats']['totalDeaths'];
    newDeaths = covidDataJson['stats']['newDeaths'];
    totalRecoveredCases = covidDataJson['stats']['totalRecoveredCases'];
    newlyRecoveredCases = covidDataJson['stats']['newlyRecoveredCases'];
  }
}

class _DataDisplayScreenState extends State<DataDisplayScreen> {
  int _temperature;
  String _cityName;
  String _weatherIcon;
  CovidDataParser _covidDataParser;
  List<String> _cityNamesHistory = ["London", "New York", "New Delhi"];

  void updateUiFromData(dynamic weatherDataJson, dynamic covidDataJson) {
    setState(() {
      _covidDataParser = CovidDataParser();
      if (weatherDataJson == null || covidDataJson == null) {
        _temperature = 0;
        _cityName = "";
        _weatherIcon = '🚫️';
        return;
      }
      _covidDataParser.parse(covidDataJson);
      _temperature = weatherDataJson['main']['temp'].toInt();
      _cityName = weatherDataJson['name'];
      int weatherConditionId = weatherDataJson['weather'][0]['id'];
      _weatherIcon = WeatherModel().getWeatherIcon(weatherConditionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () async {
                    List<dynamic> weatherAndCovidData = await ApiCallerModel()
                        .getWeatherAndCovidForCurrentLocation();
                    updateUiFromData(
                        weatherAndCovidData[0], weatherAndCovidData[1]);
                  },
                  child: Icon(
                    Icons.near_me,
                    size: 50.0,
                  ),
                ),
                FlatButton(
                  onPressed: () async {
                    var typedName = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CityPickerScreen(_cityNamesHistory);
                    }));
                    if (typedName != null) {
                      //var weatherDataJson =
                      //await WeatherModel().getCityWeather(typedName);
                      //updateUi(weatherDataJson);
                    }
                  },
                  child: Icon(
                    Icons.location_city,
                    size: 50.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
