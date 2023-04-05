// ignore_for_file: slash_for_doc_comments
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

/**
 * Classe de provider permettant de récupérer la météo avec une API
 * @author : ErwanBourlon
 */
class WeatherProvider extends ChangeNotifier {
  /**
   * Méthode permettant de récupérer température et vitesse du vent actuel pour une position précise
   * @param lat Latitude du point dont on demande la météo  
   * @param lng Longitude du point dont on demande la météo  
   * @return un tableau contenant la température et le vitesse du vent
   */
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
