// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:reunionou/models/comment.dart';
import 'package:reunionou/models/participant.dart';

class Event {
  String creator;
  String title;
  String description;
  DateTime time;
  String address;
  List<Participant> participants;
  // List<Participant> participants = [
  //   Participant(name: 'Léa Jarosz', state: 'Absent(e)', email: 'lea@jarosz.fr'),
  //   Participant(
  //       name: 'Loïc Blanchard',
  //       state: 'Présent(e)',
  //       email: 'loic@blanchard.fr'),
  // ];
  List<Comment> comments = [
    Comment(
        author: 'Léa Jarosz', comment: "J'ai pas envie de voir vos tronches"),
    Comment(author: "Loïc Blanchard", comment: "Ca va être jovial"),
    Comment(
        author: "Erwan Bourlon",
        comment:
            "Je vous invite à ma soirée pyjama disney pour fêter mon anniversaire de mes 4 ans et demi ! youhou youhou youhou youhou youhou youhou youhou youhou youhou youhou youhou youhou"),
  ];
  Event({
    required this.creator,
    required this.title,
    required this.description,
    required this.time,
    required this.address,
    required this.participants,
  });
  @override
  String toString() {
    String allParticipants = '';
    String allComments = '';
    for (var element in participants) {
      allParticipants = '$allParticipants<${element.name}:${element.state}>';
    }
    for (var element in comments) {
      allComments = '$allComments<${element.author}:${element.comment}>';
    }
    return 'Event [titre:{$title}--description:{$description}--time:{$time}--address:{$address}--${participants.length} participants--${comments.length} comments]';
  }
}
