import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:reunionou/models/comment.dart';
import 'package:reunionou/models/event.dart';
import 'package:reunionou/models/participant.dart';

class EventProvider extends ChangeNotifier {
  List<Event> eventList = [];
  // List<Event> eventList = [
  //   Event(
  //     creator: 'loic@blanchard.fr',
  //     title: "Disparition de Lilian",
  //     description:
  //         "Mais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilianMais dis donc où est lilian",
  //     time: DateTime(2023, 03, 29, 12, 00, 00),
  //     address: "12.34-13.78",
  //     participants: [
  //       Participant(
  //           name: 'Léa Jarosz', state: 'Absent(e)', email: 'lea@jarosz.fr'),
  //       Participant(
  //           name: 'Loïc Blanchard',
  //           state: 'Présent(e)',
  //           email: 'loic@blanchard.fr'),
  //     ],
  //   ),
  //   Event(
  //     creator: 'loic@blanchard.fr',
  //     title: "Avis de recherche sur Lilian",
  //     description: "Lilian ne reviendra jamais",
  //     time: DateTime(2023, 03, 29, 12, 00, 00),
  //     address: "12.34-13.78",
  //     participants: [
  //       Participant(
  //           name: 'Léa Jarosz', state: 'Absent(e)', email: 'lea@jarosz.fr'),
  //       Participant(
  //           name: 'Erwan Bourlon',
  //           state: 'Absent(e)',
  //           email: 'erwan@bourlon.fr'),
  //       Participant(
  //           name: 'Loïc Blanchard',
  //           state: 'Présent(e)',
  //           email: 'loic@blanchard.fr'),
  //     ],
  //   ),
  //   Event(
  //     creator: 'loic@blanchard.fr',
  //     title: "Retour de Lilian",
  //     description: "Wa lilian revient",
  //     time: DateTime(2023, 03, 29, 12, 00, 00),
  //     address: "12.34-13.78",
  //     participants: [
  //       Participant(
  //           name: 'Léa Jarosz', state: 'Absent(e)', email: 'lea@jarosz.fr'),
  //       Participant(
  //           name: 'Erwan Bourlon',
  //           state: 'Présent(e)',
  //           email: 'erwan@bourlon.fr'),
  //       Participant(
  //           name: 'Loïc Blanchard',
  //           state: 'Présent(e)',
  //           email: 'loic@blanchard.fr'),
  //     ],
  //   ),
  //   Event(
  //     creator: 'erwan@bourlon.fr',
  //     title: "Fête en l'honneur de Lilian",
  //     description: "Fetons tous ensemble la Saint-Lilian",
  //     time: DateTime(2023, 03, 29, 12, 00, 00),
  //     address: "12.34-13.78",
  //     participants: [
  //       Participant(
  //           name: 'Léa Jarosz', state: 'Absent(e)', email: 'lea@jarosz.fr'),
  //       Participant(
  //           name: 'Loïc Blanchard',
  //           state: 'Présent(e)',
  //           email: 'loic@blanchard.fr'),
  //     ],
  //   )
  // ];
  String myUID = "";
  String accessToken = "";
  static const urlPrefix = 'http://iut.netlor.fr';

  Future<int> connect(String email, String password) async {
    final url = Uri.parse('$urlPrefix/auth/signin');
    final headers = {"Content-type": "application/json"};
    final json = '{"email" : "$email", "password" : "$password"}';
    final response = await post(url, headers: headers, body: json);
    if (response.statusCode == 200) {
      myUID = jsonDecode(response.body)['uid'];
      accessToken = jsonDecode(response.body)['access_token'];
    }
    return response.statusCode;
  }

  Future<List<Event>> getEvents() async {
    List<Event> events = [];
    // get created events
    final url = Uri.parse('$urlPrefix/event/getEventByUser/$myUID');
    final headers = {"Authorization": "Bearer $accessToken"};
    final response = await get(url, headers: headers);
    for (var event in jsonDecode(response.body)['events']) {
      events.add(Event(
        creator: 'erwan@bourlon.fr',
        title: event['title'],
        description: event['description'],
        time: DateTime.parse(event['date']),
        address: "${event['posX']}-${event['posY']}",
        participants: [],
      ));
    }
    // get invited events
    final url2 = Uri.parse('$urlPrefix/Participants/user/$myUID');
    final response2 = await get(url2, headers: headers);
    for (var event in jsonDecode(response2.body)) {
      print(event);
      events.add(Event(
        creator: event['creator'],
        title: event['event']['title'],
        description: event['event']['description'],
        time: DateTime.parse(event['event']['date']),
        address: "${event['event']['posX']}-${event['event']['posY']}",
        participants: [],
      ));
    }
    eventList = events;
    notifyListeners();
    return eventList;
  }

  // TODO : set String creator -> json Creator
  // TODO : add eid + status
  void addEvents(Event event) async {
    eventList.add(event);
    final url = Uri.parse('$urlPrefix/event/createEvent');
    final headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $accessToken"
    };
    final json =
        '{"title":"${event.title}","description":"${event.description}","date":"${event.time}","posX":${event.address.split('"')[1]},"posY":${event.address.split('"')[3]},"uid": "$myUID"}';
    await post(url, headers: headers, body: json);
    notifyListeners();
  }

  Future<List<Participant>> getParticipants(Event event) async {
    List<Participant> listParticipants = [];
    const eventID = "1390284e-dac8-4a79-a050-c0f89f63c915";
    final url = Uri.parse('$urlPrefix/Participants/event/$eventID');
    final headers = {"Authorization": "Bearer $accessToken"};
    final response = await get(url, headers: headers);
    for (var participant in jsonDecode(response.body)['participants']) {
      listParticipants.add(Participant(
        name: "${participant['firstname']} ${participant['name']}",
        state: participant['status'],
        email: 'email',
      ));
    }
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
    const eventID = "1390284e-dac8-4a79-a050-c0f89f63c915";
    final url = Uri.parse('$urlPrefix//participants/comment/$eventID');
    final response = await get(url);
    List<Comment> list = [];
    for (var comment in jsonDecode(response.body)['comments']) {
      list.add(Comment(
          author: "${comment['firstname']} ${comment['name']}",
          comment: comment['content']));
    }
    notifyListeners();
    return list;
  }

  void addComment(String eventId, Comment comment) async {
    final url = Uri.parse('$urlPrefix/Participants/comment/add');
    final headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $accessToken"
    };
    final json =
        '{"uid": "$myUID","name": "${comment.author.split(' ')[0]}","firstname": "${comment.author.split(' ')[1]}","eid": "$eventId","content": "${comment.comment}"}';
    await post(url, headers: headers, body: json);
    notifyListeners();
  }
}
