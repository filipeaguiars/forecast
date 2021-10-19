import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

const apiKey = "a0a4c7961b224f3692436bf99649531c";

class Weather{
  var temp;
  var description;
  var currently;
  var humidity;
  double windSpeed;
  var tempMin;
  var tempMax;
  var errorCode;
  var errorMessage;
  DateTime now = DateTime.now();
  var formattedDate;
  var cityNameByIp = "";
  var city;


  Future getWeather(String city) async {
    http.Response response = await http.get(Uri.parse(
        "http://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey"));
    var results = jsonDecode(response.body);


    if(city.isEmpty || city == null){
      var cityByIpFromJson;
      http.Response cityByIpResponse =
      await http.get(Uri.parse("http://ip-api.com/json"));
      var jsonResponse = jsonDecode(cityByIpResponse.body);
      cityByIpFromJson = jsonResponse['city'];

      http.Response response = await http.get(Uri.parse(
          "http://api.openweathermap.org/data/2.5/weather?q=$cityByIpFromJson&units=metric&appid=$apiKey"));
      var results = jsonDecode(response.body);

      this.cityNameByIp = cityByIpFromJson;

      this.temp = results['main']['temp'].toStringAsFixed(1);
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];
      this.tempMin = results['main']['temp_min'];
      this.tempMax = results['main']['temp_max'];
      formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(now);

    } else if(response.statusCode == 200){
      print(response.statusCode);
      this.temp = results['main']['temp'].toStringAsFixed(1);
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];
      this.tempMin = results['main']['temp_min'];
      this.tempMax = results['main']['temp_max'];
      formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(now);

      cityNameByIp = "";
    }else {
      errorCode = results['cod'];
      this.errorMessage = results['message'];
      print(errorMessage);
      print(errorCode);
      this.temp = results['message'];
      this.description = "NaN";
      this.currently = "NaN";
      this.humidity = double.parse("NaN");
      this.windSpeed = double.parse("NaN");
      this.tempMin = double.parse("NaN");
      this.tempMax = double.parse("NaN");
    }
  }
}