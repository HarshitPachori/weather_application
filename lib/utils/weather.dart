import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:weather_application/constants.dart';
import 'package:weather_application/utils/location.dart';

class WeatherDisplayData {
  Icon weatherIcon;
  AssetImage weatherImage;

  WeatherDisplayData({required this.weatherIcon, required this.weatherImage});
}

class WeatherData {
  var apiKey = "43e8532d62934fd7a1598dfea28c7f05";

  late LocationHelper locationData;
  late double currentTemperature;
  late int currentCondition;
  WeatherData({
    required this.locationData,
  });

  Future<void> getCurrentTemperature() async {
    Response response = await get(Uri.parse(
        "http://api.openweathermap.org/data/2.5/weather?lat=${locationData.latitude}&lon=${locationData.longitude}&appid=${apiKey}&units=metric"));

    if (response.statusCode == 200) {
      String data = response.body;
      var currentWeather = jsonDecode(data);
      print(currentWeather);

      try {
        currentTemperature = currentWeather['main']['temp'];
        currentCondition = currentWeather['weather'][0]['id'];
      } catch (e) {
        print(e);
      }
    } else {
      print('Could not fetch temperature!');
    }
  }

  WeatherDisplayData getWeatherDisplayData() {
    if (currentCondition < 600) {
      return WeatherDisplayData(
        weatherIcon: kCloudIcon,
        weatherImage: const AssetImage('assets/cloud.png'),
      );
    } else {
      var now = DateTime.now();

      if (now.hour >= 15) {
        return WeatherDisplayData(
          weatherImage: const AssetImage('assets/night.png'),
          weatherIcon: kMoonIcon,
        );
      } else {
        return WeatherDisplayData(
          weatherIcon: kSunIcon,
          weatherImage: const AssetImage('assets/sunny.png'),
        );
      }
    }
  }
}
