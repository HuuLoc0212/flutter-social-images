import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Imagesio/models/comment.dart';
import 'package:Imagesio/screens/post/comment_item.dart';

class CommentPage extends StatelessWidget {
  static const routeName = 'comment';
  const CommentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    final postId = arg['postId'];

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(postId)
                  .collection('comments')
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

                if (snapshot.hasData) {
                  List<Comment> listComments = [];

                  for (var docSnap in snapshot.data!.docs) {
                    Comment comment = Comment.fromJson(
                        docSnap.data() as Map<String, dynamic>);
                    listComments.add(comment);
                  }

                  return CommentListView(listComments: listComments);
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          const CommentInput(),
        ],
      )),
    );
  }
}

class CommentListView extends StatelessWidget {
  const CommentListView({
    Key? key,
    required this.listComments,
  }) : super(key: key);

  final List<Comment> listComments;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listComments.length,
      itemBuilder: (context, index) {
        return CommentItem(comment: listComments[index]);
      },
    );
  }
}

class CommentInput extends StatefulWidget {
  const CommentInput({
    Key? key,
  }) : super(key: key);

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
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
        ));
  }
}
