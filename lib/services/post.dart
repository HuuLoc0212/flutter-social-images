import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:Imagesio/models/author.dart';
import 'package:Imagesio/models/category.dart';
import 'package:Imagesio/models/comment.dart';
import 'package:Imagesio/models/post.dart';
import 'package:Imagesio/services/util.dart';

class PostService with ChangeNotifier {
  CollectionReference postsRef = FirebaseFirestore.instance.collection('posts');

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Post?> getPost(String postId) async {
    try {
      DocumentSnapshot docSnapshot = await postsRef.doc(postId).get();

      Post post = docSnapshot.data() as Post;

      // print(docSnapshot.data().toString());

      // List<Comment> listComments = await getPostComments(postId);
      return post;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<Post>> getPosts(String category) async {
    try {
      QuerySnapshot querySnapshot = category == ''
          ? await postsRef.limit(10).get()
          : await postsRef
              .where('keywords',
                  arrayContains: category.toString().toLowerCase())
              .get();

      List<Post> listPosts = querySnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return listPosts;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Stream<Post> streamPost(String postId) {
    return firestore
        .collection('posts')
        .doc(postId)
        .snapshots()
        .asyncMap((DocumentSnapshot documentSnapshot) async {
      Post post =
          Post.fromJson(documentSnapshot.data() as Map<String, dynamic>);

      post = await populatePost(post);
      return post;
    });
  }

  Future<Post> populatePost(Post post) async {
    Post populatedPost = post;

    // populate user send
    DocumentSnapshot userSendSnap = await post.userRef.get();

    Author? userInfo =
        Author.fromJson(userSendSnap.data() as Map<String, dynamic>);
    populatedPost.author = userInfo;

    return populatedPost;
  }

  Future<List<Category>> getCategories() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('keywords').get();

    return querySnapshot.docs
        .map((DocumentSnapshot categorySnapshot) =>
            Category.fromJson(categorySnapshot.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Comment>> getPostComments(String postId) async {
    try {
      List<Comment> comments = [];

      QuerySnapshot result =
          await postsRef.doc(postId).collection('comments').get();

      for (var comment in result.docs) {
        Comment newComment =
            Comment.fromJson(comment.data() as Map<String, dynamic>);
        comments.add(newComment);
      }

      return comments;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<Author?> getPostAuthor(DocumentReference userRef) async {
    try {
      DocumentSnapshot result = await userRef.get();
      Author author = Author.fromJson(result.data() as Map<String, dynamic>);

      return author;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  deletePost(String postId) {
    try {
      FirebaseFirestore.instance.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  void likePost(Post post, String uid) async {
    List<DocumentReference> postLikes = post.likes ?? [];

    //Create userRef
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(uid);

    // Check if user is already liked this post
    bool isLiked = postLikes
        .map((DocumentReference userRef) => userRef.id)
        .toList()
        .contains(uid);

    if (isLiked) {
      final index = postLikes.indexWhere((userRef) => userRef.id == uid);
      postLikes.removeAt(index);
    } else {
      postLikes.add(userRef);
    }

    FirebaseFirestore.instance
        .collection('posts')
        .doc(post.id)
        .update({'likes': postLikes});
  }

  void commentPost(String content, String postId, String userId) {
    // create comment Id
    String commentId = firestore.collection('posts').doc().id;

    Comment comment = Comment(
        id: commentId,
        content: content,
        likes: [],
        userRef: firestore.collection('users').doc(userId),
        postRef: firestore.collection('posts').doc(postId),
        createdAt: DateTime.now().millisecondsSinceEpoch);

    firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .set(comment.toFirestore());
  }

  Future<String> createPost(String? title, description, String categories,
      File image, String userId) async {
    try {
      Map<String, String> imageInfo = await Util().createImageUrl(image);

      // create post Id
      String postId = firestore.collection('posts').doc().id;

      print(Util().splitString(categories, ','));

      Post newPost = Post(
        id: postId,
        title: title ?? '',
        description: description ?? '',
        imageUrl: imageInfo['imageUrl']!,
        userRef: FirebaseFirestore.instance.collection('users').doc(userId),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        keywords: Util().splitString(categories, ','),
      );

      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .set(newPost.toFirestore())
          .catchError((e) => print(e.toString()));

      return postId;
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  Future<bool> editPost(
      String postId, String? title, description, String categories) async {
    try {
      print(Util().splitString(categories, ','));

      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'title': title ?? '',
        'description': description ?? '',
        'keywords': Util().splitString(categories, ','),
      });

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
