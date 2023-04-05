// ignore_for_file: slash_for_doc_comments
/**
 * Classe modèle permettant de définir un commentaire d'un évènement
 * @author : ErwanBourlon
 */
class Comment {
  String author;
  String comment;
  Comment({
    required this.author,
    required this.comment,
  });
  @override
  String toString() {
    return 'Comment [author:{$author}--comment:{$comment}]';
  }
}
