import 'dart:convert';

import 'package:http/http.dart' as http;

class SmartableAiApiCaller {
  static const _smartableAiKey = "652294c415744a8aa9059fc934613900";
  static const _smartableAiUrl = "https://api.smartable.ai/coronavirus";

  Future<dynamic> getCovidStatsForCountryTag(String countryTag) async {
    http.Response res = await http.get("$_smartableAiUrl/stats/$countryTag",
        headers: {"Subscription-Key": _smartableAiKey});
    if (res.statusCode == 200) {
      String data = res.body;
      return json.decode(data);
    } else {
      print(res.statusCode);
    }
  }
}
