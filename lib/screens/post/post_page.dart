import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Imagesio/models/author.dart';
import 'package:Imagesio/models/comment.dart';
import 'package:Imagesio/models/post.dart';
import 'package:Imagesio/screens/post/comment_item.dart';
import 'package:Imagesio/screens/post/comment_section.dart';
import 'package:Imagesio/screens/post/edit-post.dart';
import 'package:Imagesio/screens/post/fullscreen_image.dart';
import 'package:Imagesio/services/post.dart';
import 'package:provider/provider.dart';

class PostPage extends StatefulWidget {
  static const routeName = '/post';

  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    String postId = arg['postId'];

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder(
              stream: PostService().streamPost(postId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // var docsnap = snapshot.data;
                // Post post =
                //     Post.fromJson(docsnap?.data() as Map<String, dynamic>);

                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(36),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 3.0,
                            offset: Offset(0, 3.0),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: 450,
                                  minWidth: MediaQuery.of(context).size.width,
                                ),
                                child: GestureDetector(
                                  child: Image(
                                    image: NetworkImage(snapshot.data.imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                      return FullScreenImage(
                                        imageUrl: snapshot.data.imageUrl,
                                      );
                                    }));
                                  },
                                ),
                              ),
                              TopBarAction(postId: snapshot.data.id)
                            ],
                          ),
                          AuthorWidget(
                              author: snapshot.data.author,
                              post: snapshot.data),
                          PostContent(post: snapshot.data),
                          ReactionWidget(
                            post: snapshot.data,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}

class ReactionWidget extends StatefulWidget {
  final Post post;
  const ReactionWidget({Key? key, required this.post}) : super(key: key);

  @override
  State<ReactionWidget> createState() => _ReactionWidgetState();
}

class _ReactionWidgetState extends State<ReactionWidget> {
  bool isOpenComment = false;

  void toggleComment() {
    setState(() {
      isOpenComment = !isOpenComment;
    });
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = Provider.of<User?>(context);
    int likesCount = widget.post.likes != null ? widget.post.likes!.length : 0;

    // Check if user is liked this post
    bool? isLiked = false;

    if (widget.post.likes
            ?.map((DocumentReference userRef) {
              return userRef.id;
            })
            .toList()
            .contains(currentUser?.uid) ==
        true) {
      setState(() {
        isLiked = true;
      });
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    PostService().likePost(widget.post, currentUser!.uid);
                  },
                  icon: Icon(Icons.favorite,
                      color: isLiked == true ? Colors.red : Colors.grey),
                  label: Text(likesCount.toString()),
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 0.0,
                    primary: Colors.grey[200],
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(widget.post.id)
                      .collection('comments')
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return Expanded(
                      child: ElevatedButton.icon(
                        onPressed: toggleComment,
                        icon: const Icon(
                          Icons.comment_rounded,
                          color: Colors.grey,
                        ),
                        label: Text(snapshot.hasData
                            ? snapshot.data.docs.length.toString()
                            : '0'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          elevation: 0.0,
                          primary: Colors.grey[200],
                          onPrimary: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(36),
                          ),
                        ),
                      ),
                    );
                  }),
              const SizedBox(width: 8.0),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => {},
                  icon: const Icon(
                    Icons.download,
                    color: Colors.grey,
                  ),
                  label: const Text('123'),
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 0.0,
                    primary: Colors.grey[200],
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isOpenComment) CommentSection(postId: widget.post.id)
      ],
    );
  }
}

class AuthorWidget extends StatelessWidget {
  final Post post;
  final Author author;
  const AuthorWidget({Key? key, required this.author, required this.post})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? currentUser = Provider.of<User?>(context);

    String categories = post.keywords!.join(', ');

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(999),
                ),
                child: Image.network(
                  author.avatar,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    author.displayName ?? author.username!,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    author.username!,
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          currentUser?.uid != author.uid
              ? ElevatedButton(
                  onPressed: () {},
                  child: const Text('Follow'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36),
                    ),
                  ),
                )
              : Tooltip(
                  message: 'Edit',
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, EditPostPage.routeName,
                          arguments: {
                            'postId': post.id,
                            'title': post.title,
                            'description': post.description,
                            'categories': categories,
                            'imageUrl': post.imageUrl,
                          });
                    },
                    child: const Icon(Icons.edit),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(36),
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}

class TopBarAction extends StatefulWidget {
  final String postId;

  const TopBarAction({Key? key, required this.postId}) : super(key: key);

  @override
  State<TopBarAction> createState() => _TopBarActionState();
}

class _TopBarActionState extends State<TopBarAction> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            color: Colors.white,
            icon: const Icon(Icons.arrow_back_ios_rounded),
            iconSize: 24.0,
          ),
          IconButton(
            onPressed: () {},
            color: Colors.white,
            icon: const Icon(Icons.more_horiz),
            iconSize: 36.0,
          ),
        ],
      ),
    );
  }
}

// class MakeDismissible extends StatelessWidget {
//   final Widget child;
//   const MakeDismissible({Key? key, required this.child}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: () => Navigator.of(context).pop(),
//       child: GestureDetector(
//         onTap: () {},
//         child: child,
//       ),
//     );
//   }
// }

// class CommentSheet extends StatefulWidget {
//   final String postId;
//   const CommentSheet({Key? key, required this.postId}) : super(key: key);

//   @override
//   State<CommentSheet> createState() => _CommentSheetState();
// }

// class _CommentSheetState extends State<CommentSheet> {
//   @override
//   Widget build(BuildContext context) {
//     Stream<QuerySnapshot<Map<String, dynamic>>> dataStream = FirebaseFirestore
//         .instance
//         .collection('posts')
//         .doc(widget.postId)
//         .collection('comments')
//         .snapshots();
//     return MakeDismissible(
//       child: DraggableScrollableSheet(
//         initialChildSize: 0.85,
//         minChildSize: 0.5,
//         maxChildSize: 0.85,
//         builder: (_, controller) => Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(
//               top: Radius.circular(36),
//             ),
//           ),
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const DraggableLine(),
//               const SizedBox(
//                 height: 10,
//               ),
//               Expanded(
//                 child: StreamBuilder(
//                   stream: dataStream,
//                   builder: (BuildContext context,
//                       AsyncSnapshot<QuerySnapshot> snapshot) {
//                     if (snapshot.hasError) {
//                       return const Center(child: Text('Something went wrong'));
//                     }

//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }

//                     if (snapshot.hasData) {
//                       List<Comment> listComments = [];

//                       for (var docSnap in snapshot.data!.docs) {
//                         Comment comment = Comment.fromJson(
//                             docSnap.data() as Map<String, dynamic>);
//                         listComments.add(comment);
//                       }

//                       return CommentListView(listComments: listComments);
//                     }

//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(
//                     top: 16, bottom: MediaQuery.of(context).viewInsets.bottom),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: const [
//                     Flexible(
//                       child: CommentInput(),
//                     ),
//                     SizedBox(
//                       width: 8.0,
//                     ),
//                     Icon(
//                       Icons.arrow_circle_right,
//                       size: 36.0,
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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

class PostContent extends StatefulWidget {
  final Post post;
  const PostContent({Key? key, required this.post}) : super(key: key);

  @override
  State<PostContent> createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  bool _seeMore = false;
  static const defaultLines = 4;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              widget.post.title ?? '',
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(
            height: 4.0,
          ),
          LayoutBuilder(builder: (context, size) {
            final span = TextSpan(text: widget.post.description);
            final tp = TextPainter(
                text: span,
                textDirection: TextDirection.ltr,
                maxLines: defaultLines);
            tp.layout(maxWidth: size.maxWidth);

            if (tp.didExceedMaxLines) {
              return Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.post.description ?? '',
                      textAlign: TextAlign.left,
                      maxLines: _seeMore == false ? defaultLines : null,
                      overflow:
                          _seeMore == false ? TextOverflow.ellipsis : null,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () => setState(() {
                        _seeMore = !_seeMore;
                      }),
                      child: _seeMore == false
                          ? const Icon(Icons.keyboard_double_arrow_down_rounded)
                          : const Icon(Icons.keyboard_double_arrow_up_rounded),
                    ),
                  )
                ],
              );
            } else {
              return Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.post.description ?? '',
                  textAlign: TextAlign.left,
                ),
              );
            }
          })
        ],
      ),
    );
  }
}
