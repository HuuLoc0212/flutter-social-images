import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Imagesio/models/comment.dart';
import 'package:Imagesio/screens/post/comment_item.dart';
import 'package:Imagesio/services/post.dart';
import 'package:provider/provider.dart';

class CommentSection extends StatelessWidget {
  final String postId;
  const CommentSection({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 500.0, minHeight: 10),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(postId)
                  .collection('comments')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Comment comment = Comment.fromJson(
                          snapshot.data!.docs[index].data()
                              as Map<String, dynamic>);
                      return CommentItem(comment: comment);
                    },
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CommentInput(postId: postId),
        ),
      ],
    );
  }
}

class CommentInput extends StatefulWidget {
  final String postId;
  const CommentInput({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    User? currentUser = Provider.of<User?>(context);

    handleSend() {
      PostService()
          .commentPost(controller.text, widget.postId, currentUser!.uid);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: TextField(
            autofocus: true,
            // keyboardType: TextInputType.none,
            controller: controller,
            maxLines: 4,
            minLines: 1,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              fillColor: Colors.grey[200],
              filled: true,
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 0.0,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
                borderSide: BorderSide(
                  color: Colors.blue,
                  width: 1.0,
                ),
              ),
              hintStyle: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(
          width: 8.0,
        ),
        IconButton(
          onPressed: handleSend,
          icon: const Icon(Icons.arrow_circle_right),
          iconSize: 36.0,
        ),
      ],
    );
  }
}
