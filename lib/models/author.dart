import 'package:cloud_firestore/cloud_firestore.dart';

class Author {
  final String uid, email, avatar;
  String? displayName, username, bio;
  List<DocumentReference>? followers, followings;
  List<dynamic>? notifications;

  Author(
      {required this.uid,
      required this.email,
      required this.avatar,
      this.username,
      this.displayName,
      this.followers,
      this.bio,
      this.followings,
      this.notifications});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      uid: json['uid'],
      username: json['username'],
      email: json['email'],
      avatar: json['avatar'],
      bio: json['bio'],
      displayName: json['displayName'],
      followers:
          json['followers'] is Iterable ? List.from(json['followers']) : [],
      followings:
          json['followings'] is Iterable ? List.from(json['followings']) : [],
      // notifications: json['notifications'],
    );
  }
}
