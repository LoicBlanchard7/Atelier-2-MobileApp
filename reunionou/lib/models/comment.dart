// ignore_for_file: public_member_api_docs, sort_constructors_first
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
