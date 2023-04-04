import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class WeatherProvider extends ChangeNotifier {
  Future<List<double>> getWeather(String lat, String lng) async {
    final url = Uri.parse(
        'https://api.open-meteo.com/v1/meteofrance?latitude=$lat&longitude=$lng&current_weather=true');
    final response = await get(url);
    notifyListeners();
    return [
      jsonDecode(response.body)['current_weather']['temperature'],
      jsonDecode(response.body)['current_weather']['windspeed']
    ];
  }
}
