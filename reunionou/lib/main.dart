import 'package:flutter/material.dart';
import 'package:reunionou/providers/event_provider.dart';
import 'package:reunionou/providers/weather_provider.dart';
import 'package:reunionou/screens/signin.dart';

void main() async {
  runApp(const SignInApp());
}

EventProvider eventProvider = EventProvider();
WeatherProvider weatherProvider = WeatherProvider();
