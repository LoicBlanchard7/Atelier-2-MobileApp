import 'package:flutter/material.dart';
import 'package:reunionou/models/event.dart';

class EventProvider extends ChangeNotifier {
  Future<List<Event>> getEvents() async {
    List<Event> eventList = [];
    notifyListeners();
    return eventList;
  }
}
