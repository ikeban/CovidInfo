import 'package:geolocator/geolocator.dart';

class LatLongCoordinates {
  double _longitude;
  double _latitude;

  double get latitude => _latitude;
  double get longitude => _longitude;

  LatLongCoordinates(this._latitude, this._longitude);
}

class Location {
  LatLongCoordinates _coordinates;

  LatLongCoordinates get coordinates => _coordinates;

  Future<LatLongCoordinates> getCurrentLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      _coordinates = LatLongCoordinates(position.latitude, position.longitude);
      return _coordinates;
    } catch (e) {
      // TODO Add proper error message, maybe message box?
      print(e);
    }
    return null;
  }
}
