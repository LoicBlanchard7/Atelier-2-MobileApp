// ignore_for_file: slash_for_doc_comments
/**
 * Classe modèle permettant de définir un participant d'un évènement
 * @author : ErwanBourlon
 */
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
