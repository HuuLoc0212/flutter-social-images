import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Imagesio/models/author.dart';
import 'package:Imagesio/models/post.dart';

class NotificationType {
  final String id, state;
  final int createdAt;
  final bool isSeen;
  final DocumentReference? postRef;
  final DocumentReference userSendRef, userReceiveRef;

  Author? userSend;
  Author? userReceive;
  Post? post;

  NotificationType({
    required this.id,
    required this.state,
    required this.userSendRef,
    required this.userReceiveRef,
    required this.createdAt,
    required this.isSeen,
    this.postRef,
    this.userSend,
    this.userReceive,
    this.post,
  });

  factory NotificationType.fromJson(Map<String, dynamic> json) {
    return NotificationType(
      id: json['id'],
      state: json['state'],
      userSendRef: json['userSendRef'],
      userReceiveRef: json['userReceiveRef'],
      createdAt: json['createdAt'],
      isSeen: json['isSeen'],
      postRef: json['postRef'],
    );
  }

  factory NotificationType.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return NotificationType(
      id: data?['id'],
      state: data?['state'],
      userSendRef: data?['userSendRef'],
      userReceiveRef: data?['userReceiveRef'],
      createdAt: data?['createdAt'],
      postRef: data?['postRef'],
      isSeen: data?['isSeen'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'state': state,
      'userSendRef': userSendRef,
      'userReceiveRef': userReceiveRef,
      'createdAt': createdAt,
      'postRef': postRef,
      'isSeen': isSeen,
    };
  }
}
