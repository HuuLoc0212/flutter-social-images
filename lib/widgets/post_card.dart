import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Imagesio/models/author.dart';
import 'package:Imagesio/models/post.dart';
import 'package:Imagesio/providers/screen_provider.dart';
import 'package:Imagesio/screens/profile_page.dart';
import 'package:Imagesio/screens/user_profile.dart';
import 'package:Imagesio/services/post.dart';
import 'package:provider/provider.dart';

enum Menu { itemOne, itemTwo }

class PostCard extends StatefulWidget {
  final Post post;
  const PostCard({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  void handleTap(DocumentReference userRef) async {
    // Author? author = await PostService().getPostAuthor(userRef);
    Navigator.pushNamed(
      context,
      '/post',
      arguments: {
        'postId': widget.post.id,
        'author': widget.post.author,
      },
    );
  }

  @override
  void initState() {
    void getAuthor() async {
      Author? author = await PostService().getPostAuthor(widget.post.userRef);

      setState(() {
        widget.post.author = author;
      });
    }

    getAuthor();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenProvider = Provider.of<ScreenProvider>(context);
    final user = Provider.of<User>(context);

    void handleTapUser(String userId) {
      if (user.uid == userId) {
        screenProvider.changeTab(3);
      } else {
        Navigator.pushNamed(
          context,
          UserProfile.routeName,
          arguments: {
            'userId': userId,
          },
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            handleTap(widget.post.userRef);
          },
          child: Card(
            elevation: 5,
            semanticContainer: true,
            key: ValueKey(widget.post.id),
            child: CachedNetworkImage(
              imageUrl: widget.post.imageUrl,
              placeholder: (context, url) => AspectRatio(
                aspectRatio: 2 / 1,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        handleTapUser(widget.post.author!.uid);
                      },
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(36),
                        ),
                        child: widget.post.author != null
                            ? Image.network(
                                widget.post.author!.avatar,
                                height: 25,
                                width: 25,
                                fit: BoxFit.cover,
                              )
                            : Container(),
                      ),
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    Expanded(
                      child: widget.post.author != null
                          ? InkWell(
                              onTap: () {
                                handleTapUser(widget.post.author!.uid);
                              },
                              child: Text(
                                widget.post.author?.displayName ??
                                    widget.post.author!.username!,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                ),
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
                child: Center(
                  child: PopupMenuButton<String>(
                    splashRadius: 16.0,
                    icon: const Icon(Icons.more_horiz, size: 18.0),
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        child: const Text('Download'),
                        onTap: () {},
                      ),
                      PopupMenuItem(
                        child: const Text('Share'),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
