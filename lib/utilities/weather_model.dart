class WeatherModel {
  String getWeatherIcon(int weatherConditionId) {
    if (weatherConditionId < 300) {
      return '⛈️';
    } else if (weatherConditionId < 400) {
      return '☔️';
    } else if (weatherConditionId < 600) {
      return '☔️';
    } else if (weatherConditionId < 700) {
      return '☃️';
    } else if (weatherConditionId < 800) {
      return '🌁️';
    } else if (weatherConditionId == 800) {
      return '☀️';
    } else if (weatherConditionId <= 804) {
      return '☁️';
    } else {
      return '❓️‍';
    }
  }
}
