import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

const apiKey = "a0a4c7961b224f3692436bf99649531c";

class CityByIp{
  String cityNameByIp = "";
  String temp;
  String description;
  String currently;
  double humidity;
  double windSpeed;
  double tempMin;
  double tempMax;
  var errorCode;
  var errorMessage;
  DateTime now = DateTime.now();
  var formattedDate;


  Future getCityByIp() async {
    var cityByIpFromJson;
    http.Response cityByIpResponse =
    await http.get(Uri.parse("http://ip-api.com/json"));
    var jsonResponse = jsonDecode(cityByIpResponse.body);
    cityByIpFromJson = jsonResponse['city'];


    if (this.cityNameByIp.isEmpty) {
      http.Response response = await http.get(Uri.parse(
          "http://api.openweathermap.org/data/2.5/weather?q=$cityByIpFromJson&units=metric&lang=pt_br&appid=$apiKey"));
      var results = jsonDecode(response.body);
      this.cityNameByIp = cityByIpFromJson;

      this.temp = results['main']['temp'];
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];
      this.tempMin = results['main']['temp_min'];
      this.tempMax = results['main']['temp_max'];
      formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(now);
    }
  }

}