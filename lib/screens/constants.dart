import 'package:flutter/material.dart';

const kTextFieldInputDecorator = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  hintText: 'Enter City Name',
  hintStyle: TextStyle(
    color: Colors.grey,
  ),
  border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
      borderSide: BorderSide.none),
);

const kButtonTextStyle = TextStyle(
  fontSize: 30.0,
);

const kDisplayTextStyle = TextStyle(
  fontSize: 30.0,
);

const kBiggerFontTextStyle = TextStyle(
  fontSize: 20.0,
);

const kTempTextStyle = TextStyle(
  fontSize: 100.0,
);

const kWeatherIconTextStyle = TextStyle(
  fontSize: 100.0,
);
