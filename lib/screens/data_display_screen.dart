import 'package:covidinfo/screens/city_picker_screen.dart';
import 'package:covidinfo/utilities/api_caller_model.dart';
import 'package:covidinfo/utilities/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

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

class CommaAdder {
  String addComma(int number) {
    String num = number.toString();
    String result = "";
    for (int i = 0; i < num.length; i++) {
      int index = num.length - 1 - i;
      if (i > 0 && i % 3 == 0) {
        result = ',' + result;
      }
      result = num[index] + result;
    }
    return result;
  }
}

class _DataDisplayScreenState extends State<DataDisplayScreen> {
  bool _spinningWheelVisible = false;
  int _temperature;
  String _cityName;
  String _weatherIcon;

  String _statsForString;
  String _weatherForString;

  CovidDataParser _covidDataParser;
  // Maximum only 7 elements in the city names list
  Set<String> _cityNamesHistory = Set.from(["London", "New York", "New Delhi"]);

  @override
  void initState() {
    super.initState();
    _restoreCityNamesFromPreferences();
    updateUiFromData(widget._locationWeather, widget._covidData);
  }

  void updateUiFromData(dynamic weatherDataJson, dynamic covidDataJson) {
    setState(() {
      _covidDataParser = CovidDataParser();
      if (weatherDataJson == null || covidDataJson == null) {
        _temperature = 0;
        _cityName = "";
        _weatherIcon = '🚫️';
        _statsForString = "Error while getting stats";
        _weatherForString = "Error";
        _spinningWheelVisible = false;
        return;
      }
      _statsForString = "Stats for ";
      _weatherForString = "Weather in ";
      _covidDataParser.parse(covidDataJson);
      _temperature = weatherDataJson['main']['temp'].toInt();
      _cityName = weatherDataJson['name'];
      int weatherConditionId = weatherDataJson['weather'][0]['id'];
      _weatherIcon = WeatherModel().getWeatherIcon(weatherConditionId);
      _spinningWheelVisible = false;
    });
  }

  void _refreshCurrentPosition() async {
    setState(() {
      _spinningWheelVisible = true;
    });
    List<dynamic> weatherAndCovidData =
        await ApiCallerModel().getWeatherAndCovidForCurrentLocation();
    updateUiFromData(weatherAndCovidData[0], weatherAndCovidData[1]);
  }

  void _moveToCityPickerScreen() async {
    var typedName =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CityPickerScreen(_cityNamesHistory);
    }));
    if (typedName != null) {
      setState(() {
        _spinningWheelVisible = true;
      });
      addCityNameToSet(typedName);
      List<dynamic> weatherAndCovidData =
          await ApiCallerModel().getWeatherAndCovidForCityName(typedName);
      updateUiFromData(weatherAndCovidData[0], weatherAndCovidData[1]);
    }
  }

  void addCityNameToSet(String typedName) {
    _cityNamesHistory.add(typedName);
    if (_cityNamesHistory.length > 7) {
      _cityNamesHistory.remove(_cityNamesHistory.first);
    }
    _saveCityNamesInPreferences(_cityNamesHistory);
  }

  void _saveCityNamesInPreferences(Set<String> cityNames) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cityNameList = cityNames.toList();
    await prefs.setStringList("CityNamesList", cityNameList);
  }

  void _restoreCityNamesFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cityNameList = prefs.getStringList("CityNamesList");
    if (cityNameList != null) {
      _cityNamesHistory = cityNameList.toSet();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        //To block back button from data display screen
        return new Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('COVID-19 info'),
          centerTitle: true,
          leading: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.near_me),
                onPressed: _refreshCurrentPosition,
              ),
              Visibility(
                visible: _spinningWheelVisible,
                child: SpinKitDoubleBounce(
                  color: Colors.white,
                  size: 8.0,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.location_city),
              onPressed: _moveToCityPickerScreen,
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/city.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          constraints: BoxConstraints.expand(),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: '$_statsForString',
                      style: kDisplayTextStyle,
                      children: <TextSpan>[
                        TextSpan(
                            text: '${_covidDataParser.countryName}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: kDisplayTextStyle,
                    children: <TextSpan>[
                      TextSpan(
                          text: "Confirmed\n",
                          style: TextStyle(color: Colors.redAccent)),
                      TextSpan(
                          text: CommaAdder().addComma(
                                  _covidDataParser.totalConfirmedCases) +
                              " (" +
                              CommaAdder().addComma(
                                  _covidDataParser.newlyConfirmedCases) +
                              " new)\n",
                          style: TextStyle(color: Colors.redAccent)),
                      TextSpan(
                          text: "Deaths\n",
                          style: TextStyle(color: Colors.grey)),
                      TextSpan(
                          text: CommaAdder()
                                  .addComma(_covidDataParser.totalDeaths) +
                              " (" +
                              CommaAdder()
                                  .addComma(_covidDataParser.newDeaths) +
                              " new)\n",
                          style: TextStyle(color: Colors.grey)),
                      TextSpan(
                          text: "Recovered\n",
                          style: TextStyle(color: Colors.lightGreen)),
                      TextSpan(
                          text: CommaAdder().addComma(
                                  _covidDataParser.totalRecoveredCases) +
                              " (" +
                              CommaAdder().addComma(
                                  _covidDataParser.newlyRecoveredCases) +
                              " new)",
                          style: TextStyle(color: Colors.lightGreen)),
                    ],
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: kDisplayTextStyle,
                    children: <TextSpan>[
                      TextSpan(text: '$_weatherForString'),
                      TextSpan(
                          text: '$_cityName',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        '$_temperature°',
                        style: kTempTextStyle,
                      ),
                      Text(
                        '$_weatherIcon️',
                        style: kWeatherIconTextStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
