import 'package:reunionou/models/creator.dart';

class Event {
  Creator creator;
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
