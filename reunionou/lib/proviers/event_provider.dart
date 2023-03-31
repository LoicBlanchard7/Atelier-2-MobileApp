import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:reunionou/models/comment.dart';
import 'package:reunionou/models/event.dart';
import 'package:reunionou/models/participant.dart';

class EventProvider extends ChangeNotifier {
  List<Event> eventList = [
    Event(
      creator: 'loic@blanchard.fr',
      title: "Disparition de Lilian",
      description:
          "Mais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilian",
      time: DateTime(2023, 03, 29, 12, 00, 00),
      address: "12.34-13.78",
      participants: [
        Participant(
            name: 'Léa Jarosz', state: 'Absent(e)', email: 'lea@jarosz.fr'),
        Participant(
            name: 'Loïc Blanchard',
            state: 'Présent(e)',
            email: 'loic@blanchard.fr'),
      ],
    ),
    Event(
      creator: 'loic@blanchard.fr',
      title: "Avis de recherche sur Lilian",
      description: "Lilian ne reviendra jamais",
      time: DateTime(2023, 03, 29, 12, 00, 00),
      address: "12.34-13.78",
      participants: [
        Participant(
            name: 'Léa Jarosz', state: 'Absent(e)', email: 'lea@jarosz.fr'),
        Participant(
            name: 'Erwan Bourlon',
            state: 'Absent(e)',
            email: 'erwan@bourlon.fr'),
        Participant(
            name: 'Loïc Blanchard',
            state: 'Présent(e)',
            email: 'loic@blanchard.fr'),
      ],
    ),
    Event(
      creator: 'loic@blanchard.fr',
      title: "Retour de Lilian",
      description: "Wa lilian revient",
      time: DateTime(2023, 03, 29, 12, 00, 00),
      address: "12.34-13.78",
      participants: [
        Participant(
            name: 'Léa Jarosz', state: 'Absent(e)', email: 'lea@jarosz.fr'),
        Participant(
            name: 'Erwan Bourlon',
            state: 'Présent(e)',
            email: 'erwan@bourlon.fr'),
        Participant(
            name: 'Loïc Blanchard',
            state: 'Présent(e)',
            email: 'loic@blanchard.fr'),
      ],
    ),
    Event(
      creator: 'erwan@bourlon.fr',
      title: "Fête en l'honneur de Lilian",
      description: "Fetons tous ensemble la Saint-Lilian",
      time: DateTime(2023, 03, 29, 12, 00, 00),
      address: "12.34-13.78",
      participants: [
        Participant(
            name: 'Léa Jarosz', state: 'Absent(e)', email: 'lea@jarosz.fr'),
        Participant(
            name: 'Loïc Blanchard',
            state: 'Présent(e)',
            email: 'loic@blanchard.fr'),
      ],
    )
  ];
  String myUID = "";
  String accessToken = "";
  static const urlPrefix = 'http://iut.netlor.fr';
  // static const urlPrefix = 'https://jsonplaceholder.typicode.com';

  void setUpToken(String newUid, String newToken) {
    myUID = newUid;
    accessToken = newToken;
  }

  Future<int> connect(String email, String password) async {
    final url = Uri.parse('$urlPrefix/auth/signin');
    final headers = {"Content-type": "application/json"};
    final json = '{"email" : "$email", "password" : "$password"}';
    final response = await post(url, headers: headers, body: json);
    print('Status code: ${response.statusCode}');
    if (response.statusCode == 200) {
      myUID = jsonDecode(response.body)['uid'];
      accessToken = jsonDecode(response.body)['access_token'];
    }
    return response.statusCode;
  }

  Future<List<Event>> getEvents() async {
    notifyListeners();
    return eventList;
  }

  void addEvents(Event event) async {
    eventList.add(event);
    notifyListeners();
  }

  Future<List<Participant>> getParticipants(Event event) async {
    List<Participant> listParticipants = event.participants;
    notifyListeners();
    return listParticipants;
  }

  Future<List<String>> getAllParticipants() async {
    List<String> listParticipants = [
      'Léa Jazosz',
      'Lilian Leblanc',
      'Loïc Blanchard'
    ];
    notifyListeners();
    return listParticipants;
  }

  void addParticipant(Event event, Participant participant) async {
    event.participants.add(participant);
    notifyListeners();
  }

  Future<List<Comment>> getComments(Event event) async {
    notifyListeners();
    return event.comments;
  }

  void addComment(Event event, Comment comment) async {
    event.comments.add(comment);
    notifyListeners();
  }
}
