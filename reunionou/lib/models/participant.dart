// ignore_for_file: public_member_api_docs, sort_constructors_first
class Participant {
  String name;
  String state;
  String email;
  Participant({
    required this.name,
    required this.state,
    required this.email,
  });
  @override
  String toString() {
    return 'Participant [name:{$name}--state:{$state}--email:{$email}]';
  }
}
