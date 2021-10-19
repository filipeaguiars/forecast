import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bromp_forecast/controller/controller.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _cityName = TextEditingController();
  var currentCity;

  Weather weather = Weather();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    weather.getWeather(_cityName.text);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: weather.getWeather(_cityName.text),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  );
                default:
                  if (snapshot.hasError)
                    return Container();
                  else
                    return _buildLayout(context, snapshot);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLayout(BuildContext context, AsyncSnapshot snapshot) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(weather.description.contains('rain')
                  ? "Assets/images/rain.jpg"
                  : weather.description.contains('clouds')
                      ? "Assets/images/overcast_clouds.jpg"
                      : weather.description.contains('sun') ||
                              weather.description.contains('clear')
                          ? "Assets/images/sun.jpg"
                          : "Assets/images/background-3d348b.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                child: Text(
                  "Brompton Forecast",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 1),
                child: Container(
                  constraints: BoxConstraints(minWidth: 100, maxWidth: 300),
                  height: 50,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    textAlign: TextAlign.center,
                    controller: _cityName,
                    onSubmitted: (typedCity) {
                      if (typedCity.isNotEmpty &&
                          typedCity != currentCity) {
                        setState(() {
                          weather.getWeather(typedCity);
                        });
                      }
                    },
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 30),
                    decoration: InputDecoration(
                      // labelStyle: TextStyle(
                      //     color: Colors.blueAccent, fontWeight: FontWeight.w700),
                      hintText: weather.cityNameByIp,
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 30),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide:
                            BorderSide(color: Colors.white70, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "${weather.formattedDate.toString()}",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
              RichText(
                text: TextSpan(
                    text:
                        weather.temp != null ? "${weather.temp}\u00B0" : "NaN",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 70,
                          fontWeight: FontWeight.w700),
                    ),
                    children: [
                      TextSpan(
                          text: "c",
                          style: TextStyle(fontWeight: FontWeight.w100))
                    ]),
              ),
              Text(
                "--------------------",
                style: TextStyle(color: Colors.white),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  weather.currently != null ? weather.currently : "NaN ",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  weather.tempMin != null && weather.tempMax != null
                      ? "${weather.tempMin}°c / ${weather.tempMax}°c"
                      : "NaN",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView(
                      children: [
                        ListTile(
                          leading: FaIcon(
                            FontAwesomeIcons.thermometerHalf,
                            color: Colors.white,
                          ),
                          title: Text(
                            "Temperatura",
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Text(
                              weather.temp != null
                                  ? "${weather.temp}\u00B0c"
                                  : "NaN",
                              style: TextStyle(color: Colors.white)),
                        ),
                        const Divider(
                          color: Colors.white,
                        ),
                        ListTile(
                          leading: FaIcon(
                            FontAwesomeIcons.cloud,
                            color: Colors.white,
                          ),
                          title: Text("Clima",
                              style: TextStyle(color: Colors.white)),
                          trailing: Text(
                              weather.description != null
                                  ? weather.description
                                  : "NaN",
                              style: TextStyle(color: Colors.white)),
                        ),
                        const Divider(
                          color: Colors.white,
                        ),
                        ListTile(
                          leading: FaIcon(
                            FontAwesomeIcons.sun,
                            color: Colors.white,
                          ),
                          title: Text("Umidade",
                              style: TextStyle(color: Colors.white)),
                          trailing: Text(
                              weather.humidity != null
                                  ? weather.humidity.toString()
                                  : "NaN",
                              style: TextStyle(color: Colors.white)),
                        ),
                        const Divider(
                          color: Colors.white,
                        ),
                        ListTile(
                          leading: FaIcon(
                            FontAwesomeIcons.wind,
                            color: Colors.white,
                          ),
                          title: Text("Velocidade do Vento",
                              style: TextStyle(color: Colors.white)),
                          trailing: Text(
                              weather.windSpeed != null
                                  ? weather.windSpeed.toString()
                                  : "NaN",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
