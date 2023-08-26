import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Imagesio/models/author.dart';

class UserService {
  getUser(String userId) async {
    DocumentSnapshot user =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    return Author.fromJson(user.data() as Map<String, dynamic>);
  }
}
