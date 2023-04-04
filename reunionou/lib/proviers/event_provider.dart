import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:reunionou/models/comment.dart';
import 'package:reunionou/models/creator.dart';
import 'package:reunionou/models/event.dart';
import 'package:reunionou/models/participant.dart';

class EventProvider extends ChangeNotifier {
  String myUID = "";
  String myEmail = "";
  String myFirstname = "";
  String myName = "";
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
      final urlMe = Uri.parse('$urlPrefix/auth/userId/$myUID');
      final responseMe = await get(urlMe, headers: headers);
      final decodeMe = jsonDecode(responseMe.body);
      myEmail = decodeMe['user']['email'];
      myFirstname = decodeMe['user']['firstname'];
      myName = decodeMe['user']['name'];
    }
    return response.statusCode;
  }

  Future<int> updateName(String name, String firstname) async {
    final url = Uri.parse('$urlPrefix/auth/updateUser');
    final headers = {"Content-type": "application/json"};
    final json =
        '{"uid" : "$myUID", "name" : "$name", "firstname" : "$firstname"}';
    final response = await put(url, headers: headers, body: json);
    if (response.statusCode == 200) {
      myFirstname = firstname;
      myName = name;
    }
    return response.statusCode;
  }

  Future<int> updatePassword(String password) async {
    final url = Uri.parse('$urlPrefix/auth/updateUser');
    final headers = {"Content-type": "application/json"};
    final json =
        '{"uid" : "$myUID", "name" : "$myName", "firstname" : "$myFirstname", "password" : "$password"}';
    final response = await put(url, headers: headers, body: json);
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
        creator: Creator(
            firstname: 'Erwan', name: 'Bourlon', email: 'erwan@bourlon.fr'),
        title: event['title'],
        description: event['description'],
        time: DateTime.parse(event['date']),
        address: "${event['posX']}-${event['posY']}",
        status: 'creator',
        eid: event['eid'],
      ));
    }
    // get invited events
    final url2 = Uri.parse('$urlPrefix/Participants/user/$myUID');
    final response2 = await get(url2, headers: headers);
    for (var event in jsonDecode(response2.body)) {
      final urlCreator = Uri.parse('$urlPrefix/auth/userId/$myUID');
      final responseCreator = await get(urlCreator, headers: headers);
      final decodeResponseCreator = jsonDecode(responseCreator.body);
      Creator creator = Creator(
        firstname: decodeResponseCreator['user']['firstname'],
        name: decodeResponseCreator['user']['name'],
        email: decodeResponseCreator['user']['email'],
      );
      events.add(Event(
        creator: creator,
        title: event['event']['title'],
        description: event['event']['description'],
        time: DateTime.parse(event['event']['date']),
        address: "${event['event']['posX']}-${event['event']['posY']}",
        status: event['status'],
        eid: event['event']['eid'],
      ));
    }
    notifyListeners();
    return events;
  }

  void addEvents(Event event) async {
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

  void updateEvent(Event event) async {
    final url = Uri.parse('$urlPrefix/event/updateEvent');
    final headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $accessToken"
    };
    final json =
        '{"eid":"${event.eid}","title":"${event.title}","description":"${event.description}","date":"${event.time}","posX":${event.address.split('-')[0]},"posY":${event.address.split('-')[1]}}';
    await put(url, headers: headers, body: json);
    notifyListeners();
  }

  Future<List<Participant>> getParticipants(Event event) async {
    List<Participant> listParticipants = [];
    final url = Uri.parse('$urlPrefix/Participants/event/${event.eid}');
    final headers = {"Authorization": "Bearer $accessToken"};
    final response = await get(url, headers: headers);
    for (var participant in jsonDecode(response.body)['participants']) {
      listParticipants.add(Participant(
        state: participant['status'],
        name: "${participant['firstname']} ${participant['name']}",
        email: 'email',
        uid: participant['uid'],
      ));
    }
    notifyListeners();
    return listParticipants;
  }

  Future<List<Participant>> getAllParticipants(
      List<Participant> actuels) async {
    List<Participant> listParticipants = [];
    final url = Uri.parse('$urlPrefix/auth');
    final headers = {"Authorization": "Bearer $accessToken"};
    final response = await get(url, headers: headers);
    for (var user in jsonDecode(response.body)['users']) {
      if (myUID != user['uid']) {
        bool pasEncoreInvite = true;
        for (var invites in actuels) {
          if (invites.uid == user['uid']) {
            pasEncoreInvite = false;
          }
        }
        if (pasEncoreInvite) {
          listParticipants.add(Participant(
            email: user['email'],
            name: "${user['firstname']} ${user['name']}",
            state: '',
            uid: user['uid'],
          ));
        }
      }
    }
    notifyListeners();
    return listParticipants;
  }

  void responseToInvitation(Event event, String status) async {
    final url = Uri.parse('$urlPrefix/participants/accept');
    final headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $accessToken"
    };
    final json = '{"uid":"$myUID","eid":"${event.eid}","status":"$status"}';
    await put(url, headers: headers, body: json);
    notifyListeners();
  }

  void inviteToEvent(Event event, Participant userToInvite) async {
    final url = Uri.parse('$urlPrefix/participants/add');
    final headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $accessToken"
    };
    final json =
        '{"uid":"${userToInvite.uid}","eid":"${event.eid}","name":"${userToInvite.name}","firstname":"${userToInvite.name}"}';
    await post(url, headers: headers, body: json);
    notifyListeners();
  }

  Future<List<Comment>> getComments(Event event) async {
    final url =
        Uri.parse('$urlPrefix//participants/comment/getComment/${event.eid}');
    final response = await get(url);
    List<Comment> list = [];
    for (var comment in jsonDecode(response.body)['comments']) {
      list.add(Comment(
          author: "${comment['firstname']} ${comment['name']}",
          comment: comment['content']));
    }
    notifyListeners();
    return list.reversed.toList();
  }

  void addComment(Event event, Comment comment) async {
    final url = Uri.parse('$urlPrefix/Participants/comment/add');
    final headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $accessToken"
    };
    final json =
        '{"uid": "$myUID","name": "${comment.author.split(' ')[0]}","firstname": "${comment.author.split(' ')[1]}","eid": "${event.eid}","content": "${comment.comment}"}';
    await post(url, headers: headers, body: json);
    notifyListeners();
  }
}
