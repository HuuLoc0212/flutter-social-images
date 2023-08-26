class Reply {
  String id;
  String content;
  List<String> likes;
  String commentId;
  String userRef;

  Reply({
    required this.id,
    required this.content,
    required this.likes,
    required this.userRef,
    required this.commentId,
  });
}
