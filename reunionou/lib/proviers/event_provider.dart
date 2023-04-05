// ignore_for_file: slash_for_doc_comments
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:reunionou/models/comment.dart';
import 'package:reunionou/models/creator.dart';
import 'package:reunionou/models/event.dart';
import 'package:reunionou/models/participant.dart';

/**
 * Classe de provider permettant de discuter avec l'API créée pour gérer la base de donnée de Reunionou
 * @author : ErwanBourlon
 */
class EventProvider extends ChangeNotifier {
  String myUID = "";
  String myEmail = "";
  String myFirstname = "";
  String myName = "";
  String accessToken = "";
  List<Event> _listevent = [];
  static const urlPrefix = 'http://iut.netlor.fr';

  /**
   * Méthode permettant d'envoyer une demande de connection et de récupérer l'access_token
   * @param email Courriel du compte à connecter  
   * @param password Mot de passe du compte à connecter  
   * @return le code de retour de la requête
   */
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

  /**
   * Méthode permettant mettre à jour le nom et prénom du compte utilisateur
   * @param name Nom du compte mettre à jour  
   * @param firstname Préom du compte mettre à jour  
   * @return le code de retour de la requête
   */
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

  /**
   * Méthode permettant mettre à jour le mot de passe du compte utilisateur
   * @param password Mot de passe du compte mettre à jour  
   * @return le code de retour de la requête
   */
  Future<int> updatePassword(String password) async {
    final url = Uri.parse('$urlPrefix/auth/updateUser');
    final headers = {"Content-type": "application/json"};
    final json =
        '{"uid" : "$myUID", "name" : "$myName", "firstname" : "$myFirstname", "password" : "$password"}';
    final response = await put(url, headers: headers, body: json);
    return response.statusCode;
  }

  /**
   * Méthode permettant de récupérer la liste des évènements de l'utilisateur
   * @return la liste des évènements demandée
   */
  Future<List<Event>> getEvents() async {
    if (_listevent.isEmpty) {
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
      _listevent = events;
    }
    return _listevent;
  }

  /**
   * Méthode permettant de créer et d'ajouter un évènement
   * @param event Evènement à ajouter
   */
  void addEvents(Event event) async {
    _listevent.add(event);
    final url = Uri.parse('$urlPrefix/event/createEvent');
    final headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $accessToken"
    };
    final json =
        '{"title":"${event.title}","description":"${event.description}","date":"${event.time}","posX":${event.address.split('"')[1]},"posY":${event.address.split('"')[3]},"uid": "$myUID"}';
    final response = await post(url, headers: headers, body: json);
    event.eid = jsonDecode(response.body)['eid'];
    notifyListeners();
  }

  /**
   * Méthode permettant de mettre à jour les informations un évènement
   * @param event Evènement à mettre jour
   */
  void updateEvent(Event event) async {
    _listevent[_listevent.indexWhere((element) => element.eid == event.eid)] =
        event;
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

  /**
   * Méthode permettant de récupérer la liste des participants d'un évènements
   * @param event Evènement dont il est question 
   * @return la liste des participants demandée
   */
  Future<List<Participant>> getParticipants(Event event) async {
    List<Participant> listParticipants = [];
    final url = Uri.parse('$urlPrefix/Participants/event/${event.eid}');
    final headers = {"Authorization": "Bearer $accessToken"};
    final response = await get(url, headers: headers);
    for (var participant in jsonDecode(response.body)['participants']) {
      listParticipants.add(Participant(
        state: participant['status'],
        name: "${participant['name']}",
        email: 'email',
        uid: participant['uid'],
      ));
    }
    notifyListeners();
    return listParticipants;
  }

  /**
   * Méthode permettant de récupérer la liste de tous les utilisateurs (excépté
   * ceux que l'on passe en paramètre)
   * @param actuels Liste d'utilisateurs que l'on excluera de la liste retournée
   * @return la liste des utilisateurs demandée
   */
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

  /**
   * Méthode permettant d'accépter ou de refuser une invitation à un évènement
   * @param event Evènement dont il est question
   * @param status Réponse à l'invitation
   */
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

  /**
   * Méthode permettant d'inviter un utilisateur à un évènement
   * @param event Evènement dont il est question
   * @param userToInvite Utilisateur à inviter
   */
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

  /**
   * Méthode permettant de récupérer la liste des commentaires d'un évènements
   * @param event Evènement dont il est question 
   * @return la liste des commentaires demandée
   */
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

  /**
   * Méthode permettant d'ajouter un commentaire à un évènement
   * @param event Evènement dont il est question
   * @param comment Commentaire à poster
   */
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
