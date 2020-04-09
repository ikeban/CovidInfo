import 'package:flutter/material.dart';

class CityPickerScreen extends StatefulWidget {
  final List<String> _cityHistory;

  CityPickerScreen(this._cityHistory);

  @override
  _CityPickerScreenState createState() => _CityPickerScreenState();
}

class _CityPickerScreenState extends State<CityPickerScreen> {
  String _cityName;
  //Navigator.pop(context, _cityName);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('COVID-19 City picker'),
        centerTitle: true,
      ),
    );
  }
}
