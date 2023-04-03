// ignore_for_file: public_member_api_docs, sort_constructors_first
class Participant {
  String uid;
  String name;
  String email;
  String state;
  Participant({
    required this.uid,
    required this.state,
    required this.name,
    required this.email,
  });
  @override
  String toString() {
    return 'Participant [uid:{$uid}--name:{$name}--state:{$state}--email:{$email}]';
  }
}
