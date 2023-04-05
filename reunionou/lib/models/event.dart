// ignore_for_file: slash_for_doc_comments
import 'package:reunionou/models/creator.dart';

/**
 * Classe modèle permettant de définir un évènement
 * @author : ErwanBourlon
 */
class Event {
  Creator creator;
  // Statut de l'évènement par rapport à l'utilisateur connécté (creator/declined/accepted/pending)
  String status;
  String eid;
  String title;
  String description;
  DateTime time;
  String address;
  Event({
    required this.creator,
    required this.status,
    required this.eid,
    required this.title,
    required this.description,
    required this.time,
    required this.address,
  });
  @override
  String toString() {
    return 'Event [titre:{$title}--description:{$description}--time:{$time}--address:{$address}]';
  }
}
