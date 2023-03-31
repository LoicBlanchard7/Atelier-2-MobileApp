import 'package:flutter/material.dart';
import 'package:reunionou/proviers/event_provider.dart';
import 'package:reunionou/screens/signin.dart';

void main() async {
  // TODO : sécuriser les entrées (connection/création/chat)
  runApp(const SignInApp());
}

EventProvider eventProvider = EventProvider();
