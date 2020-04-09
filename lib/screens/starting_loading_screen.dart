import 'package:covidinfo/utilities/api_caller_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'data_display_screen.dart';

class StartingLoadingScreen extends StatefulWidget {
  @override
  _StartingLoadingScreenState createState() => _StartingLoadingScreenState();
}

class _StartingLoadingScreenState extends State<StartingLoadingScreen> {
  void getDataAndShowDataDisplayScreen() async {
    List<dynamic> weatherAndCovidData =
        await ApiCallerModel().getWeatherAndCovidForCurrentLocation();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DataDisplayScreen(
          locationWeather: weatherAndCovidData[0],
          covidData: weatherAndCovidData[1]);
    }));
  }

  @override
  void initState() {
    super.initState();
    getDataAndShowDataDisplayScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 100.0,
        ),
      ),
    );
  }
}
