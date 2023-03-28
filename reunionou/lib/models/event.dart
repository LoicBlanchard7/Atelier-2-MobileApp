// ignore_for_file: public_member_api_docs, sort_constructors_first
class Event {
  String title;
  String description;
  DateTime time;
  String address;
  Event({
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
