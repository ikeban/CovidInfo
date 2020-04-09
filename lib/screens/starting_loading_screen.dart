import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class StartingLoadingScreen extends StatefulWidget {
  @override
  _StartingLoadingScreenState createState() => _StartingLoadingScreenState();
}

class _StartingLoadingScreenState extends State<StartingLoadingScreen> {
  void getCurrentLocation() async {}

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
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
