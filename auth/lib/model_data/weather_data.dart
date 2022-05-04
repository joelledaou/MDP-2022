import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Weather {
  final int? max;
  final int? min;
  final int? current;
  final String? name;
  final String? day;
  final String? image;
  final String? location;

  Weather(
      {this.max,
      this.min,
      this.name,
      this.day,
      this.image,
      this.current,
      this.location});
}

String appId = "46df538bf61d0d37a465003ebcf0df6c";

Future<List> fetchData(String lat, String lon, String city) async {
  var url =
      "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&units=metric&appid=$appId";
  var response = await http.get(Uri.parse(url));
  DateTime date = DateTime.now();
  if (response.statusCode == 200) {
    print(response.statusCode);
    var res = json.decode(response.body);

    //current Temp
    var current = res["current"];
    Weather currentTemp = Weather(
      //current: current["temp"]?.round() ?? 0,
      //max: current["temp"]["max"]?.round() ?? 0,
      //min: current["temp"]["min"]?.round() ?? 0,
      //name: current["weather"][0]["main"].toString(),
      //day: DateFormat("EEEE dd MMMM").format(date),
      location: city,
      //image: findIcon(current["weather"][0]["main"].toString(), true)
    );

    //Four Day Weather
    List<Weather> fourDay = [];
    for (var i = 1; i < 5; i++) {
      String day = DateFormat("EEEE")
          .format(DateTime(date.year, date.month, date.day + i))
          .substring(0, 3);
      var temp = res["daily"][i];
      var hourly = Weather(
          max: temp["temp"]["max"]?.round() ?? 0,
          min: temp["temp"]["min"]?.round() ?? 0,
          image: findIcon(temp["weather"][0]["main"].toString(), false),
          name: temp["weather"][0]["main"].toString(),
          day: day);
      fourDay.add(hourly);
    }

    //return [currentTemp, todayWeather, tomorrowTemp, fourDay];
    return [currentTemp, fourDay];
  }
  //return [null, null, null];
  return [null, null, null, null];
}

String findIcon(String name, bool type) {
  if (type) {
    switch (name) {
      case "Clouds":
        return "assets/sunny.png";
      case "Rain":
        return "assets/rainy.png";
      case "Drizzle":
        return "assets/rainy.png";
      case "Thunderstorm":
        return "assets/thunder.png";
      case "Snow":
        return "assets/snow.png";
      default:
        return "assets/sunny.png";
    }
  } else {
    switch (name) {
      case "Clouds":
        return "assets/sunny_2d.png";
      case "Rain":
        return "assets/rainy_2d.png";
      case "Drizzle":
        return "assets/rainy_2d.png";
      case "Thunderstorm":
        return "assets/thunder_2d.png";
      case "Snow":
        return "assets/snow_2d.png";
      default:
        return "assets/sunny_2d.png";
    }
  }
}

class CityModel {
  final String? name;
  final String? lat;
  final String? lon;
  CityModel({this.name, this.lat, this.lon});
}

var cityJSON;

Future<CityModel?> fetchCity(String cityName) async {
  if (cityJSON == null) {
    String link =
        "https://raw.githubusercontent.com/dr5hn/countries-states-cities-database/master/cities.json";
    var response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      cityJSON = json.decode(response.body);
    }
  }
  for (var i = 0; i < cityJSON.length; i++) {
    if (cityJSON[i]["name"].toString().toLowerCase() ==
        cityName.toLowerCase()) {
      return CityModel(
          name: cityJSON[i]["name"].toString(),
          lat: cityJSON[i]["latitude"].toString(),
          lon: cityJSON[i]["longitude"].toString());
    }
  }
  return null;
}
