import 'package:flutter/material.dart';

import 'constants.dart';

class CityPickerScreen extends StatefulWidget {
  // Print this list backward
  final Set<String> _cityHistory;

  CityPickerScreen(this._cityHistory);

  @override
  _CityPickerScreenState createState() => _CityPickerScreenState();
}

class _CityPickerScreenState extends State<CityPickerScreen> {
  String _cityName;
  final TextEditingController _textEditController = TextEditingController();

  Function _getButtonsOfRecentBuilder() {
    return (BuildContext _context, int i) {
      if (i.isOdd) {
        return Divider();
      }
      final int index = i ~/ 2;
      return _buildRow(widget._cityHistory
          .elementAt(widget._cityHistory.length - 1 - index));
    };
  }

  Widget _buildRow(String cityName) {
    return ListTile(
      title: Text(
        cityName,
        style: kBiggerFontTextStyle,
      ),
      trailing: Icon(
        Icons.location_city,
      ),
      onTap: () {
        setState(() {
          _textEditController.text = cityName;
          _cityName = cityName;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('COVID-19 City picker'),
        centerTitle: true,
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
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Get statistics:",
                style: kButtonTextStyle,
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          _cityName = value;
                        },
                        decoration: kTextFieldInputDecorator,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                        controller: _textEditController,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context, _cityName);
                      },
                      icon: Icon(
                        Icons.search,
                        size: 40.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Recent:",
                style: kBiggerFontTextStyle,
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: widget._cityHistory.length * 2,
                  separatorBuilder: (context, item) => Divider(
                    height: 1.0,
                  ),
                  itemBuilder: _getButtonsOfRecentBuilder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
