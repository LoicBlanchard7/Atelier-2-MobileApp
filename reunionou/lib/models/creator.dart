// ignore_for_file: slash_for_doc_comments
/**
 * Classe modèle permettant de définir un créateur d'un évènement
 * @author : ErwanBourlon
 */
class Creator {
  String firstname;
  String name;
  String email;
  Creator({
    required this.firstname,
    required this.name,
    required this.email,
  });
  @override
  String toString() {
    return 'Creator [firstname:{$firstname}--name:{$name}--email:{$email}]';
  }
}
