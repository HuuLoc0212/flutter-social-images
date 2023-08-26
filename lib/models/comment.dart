import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Imagesio/models/author.dart';
import 'package:Imagesio/models/reply.dart';

class Comment {
  final String id, content;
  final List<String>? likes;
  final List<Reply>? replies;
  final DocumentReference userRef, postRef;
  final int createdAt;

  Author? author;

  Comment({
    required this.id,
    required this.content,
    required this.likes,
    required this.userRef,
    required this.postRef,
    required this.createdAt,
    this.author,
    this.replies,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      createdAt: json['createdAt'],
      likes: [],
      replies: [],
      userRef: json['userRef'],
      postRef: json['postRef'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'content': content,
      'createdAt': createdAt,
      'likes': likes,
      'userRef': userRef,
      'postRef': postRef,
    };
  }
}
