import 'package:flutter/material.dart';
import 'package:clima_flutter/utilities/constants.dart';
import 'package:clima_flutter/services/weather.dart';
import 'package:clima_flutter/services/location.dart';
import 'package:clima_flutter/services/networking.dart';
import 'city_screen.dart';

const String api = '4a444c7584ae8a1aff8e2b622b8ce16a';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.weatherData});
  final dynamic weatherData;
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  int temperature;
  String weatherIcon;
  String weatherDescription;
  String cityName;
  void updateUI(var data) {
    setState(() {
      if (data['cod'] == '404') {
        temperature = 0;
        weatherIcon = 'error';
        weatherDescription = 'Given name is not a city';
        cityName = 'my world!';
        return;
      }
      // print(data);
      var temp = data['main']['temp'];
      temperature = temp.toInt();
      WeatherModel model = WeatherModel();
      int weatherID = data['weather'][0]['id'];
      weatherIcon = model.getWeatherIcon(weatherID);
      weatherDescription = model.getMessage(temperature);
      cityName = data['name'];
    });
  }

  @override
  void initState() {
    super.initState();
    updateUI(widget.weatherData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      // setState(() async {
                      Location location = Location();
                      await location.getCurrentLocation();
                      NetworkHelper networkHelper = NetworkHelper(
                          'https://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&appid=$api&units=metric');
                      var weatherData1 = await networkHelper.getData();
                      updateUI(weatherData1);
                      // });
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      String typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return CityScreen();
                        }),
                      );
                      NetworkHelper networkHelper = NetworkHelper(
                          'http://api.openweathermap.org/data/2.5/weather?q=$typedName&appid=$api&units=metric');
                      var weatherData1 = await networkHelper.getData();
                      updateUI(weatherData1);
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  '$weatherDescription in $cityName!',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
