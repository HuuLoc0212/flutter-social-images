import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Imagesio/screens/post/post_page.dart';
import 'package:Imagesio/services/user.dart';
import 'package:Imagesio/shared/constants.dart';

class UserProfile extends StatefulWidget {
  static const routeName = '/user-profile';

  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    String userId = arg['userId'];

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        foregroundColor: Colors.blue,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FutureBuilder(
                        future: UserService().getUser(userId),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                                child: Text('Something went wrong'));
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasData) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 14),
                                // profile
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    children: [
                                      ClipOval(
                                        child: Image.network(
                                          snapshot.data.avatar,
                                          height: 70,
                                          width: 70,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                              snapshot.data.followings?.length
                                                      .toString() ??
                                                  '0',
                                              style: const TextStyle(
                                                color: black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18,
                                              ),
                                            ),
                                            const Text(
                                              'Following',
                                              style: TextStyle(
                                                color: black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                              snapshot.data.followers?.length
                                                      .toString() ??
                                                  '0',
                                              style: const TextStyle(
                                                color: black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18,
                                              ),
                                            ),
                                            const Text(
                                              'Followers',
                                              style: TextStyle(
                                                color: black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            FutureBuilder(
                                                future: FirebaseFirestore
                                                    .instance
                                                    .collection('posts')
                                                    .where('userRef',
                                                        isEqualTo:
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .doc(userId))
                                                    .get(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot snapshot) {
                                                  if (snapshot.hasError) {
                                                    return const Center(
                                                        child: Text('0'));
                                                  }

                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                      child: Text('0'),
                                                    );
                                                  }
                                                  return Text(
                                                    snapshot.data.docs.length
                                                        .toString(),
                                                    style: const TextStyle(
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 18,
                                                    ),
                                                  );
                                                }),
                                            const Text(
                                              'Posts',
                                              style: TextStyle(
                                                color: black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // username
                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    '@${snapshot.data.username}',
                                    style: const TextStyle(
                                      color: black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),

                                // display name
                                const SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    snapshot.data.displayName ??
                                        snapshot.data.username!,
                                    style: const TextStyle(
                                      color: black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),

                                // bio
                                const SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    snapshot.data.bio ?? '',
                                    style: const TextStyle(
                                      color: hyperlinkColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }

                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }),

                    // Follow and Message buttons
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text('Follow'),
                              style: ElevatedButton.styleFrom(
                                primary: const Color(0xFF26BAEE),
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(36),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16.0,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text('Message'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
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

                    // Stories
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFF26BAEE),
                                  ),
                                  borderRadius: BorderRadius.circular(74),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/highlight-1.jpg',
                                    height: 66,
                                    width: 66,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text('Nguyen'),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Column(
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: secondaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(74),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/highlight-2.jpg',
                                    height: 66,
                                    width: 66,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text('Huu'),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Column(
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: secondaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(74),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/highlight-3.jpg',
                                    height: 66,
                                    width: 66,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text('Loc'),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Column(
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: secondaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(74),
                                ),
                                child: const Center(
                                  child: Icon(Icons.add, size: 36),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text('New'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Tab menu
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Spacer(),
                                SvgPicture.asset(
                                  'assets/icons/post.svg',
                                  height: 24,
                                  width: 24,
                                  color: black,
                                ),
                                const Spacer(),
                                const Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: black,
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Spacer(),
                                SvgPicture.asset(
                                  'assets/icons/panduan.svg',
                                  height: 24,
                                  width: 24,
                                ),
                                const Spacer(),
                                const Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: white,
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Spacer(),
                                SvgPicture.asset(
                                  'assets/icons/tag.svg',
                                  height: 24,
                                  width: 24,
                                ),
                                const Spacer(),
                                const Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: white,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // grid post
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('posts')
                          .where('userRef',
                              isEqualTo: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userId))
                          .get(),
                      builder: ((BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Something went wrong'));
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasData) {
                          // return Container();
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1 / 1,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 2,
                            ),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () => Navigator.pushNamed(
                                    context, PostPage.routeName, arguments: {
                                  'postId': snapshot.data!.docs[index]['id']
                                }),
                                child: Container(
                                  color: hyperlinkColor,
                                  child: Image.network(
                                    snapshot.data!.docs[index]['imageUrl'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                            itemCount: snapshot.data!.docs.length,
                          );
                        }

                        return const CircularProgressIndicator();
                      }),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// bottom sheet modal
class BottomSheetModal extends StatelessWidget {
  const BottomSheetModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
    );
  }
}

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 36,
        decoration: buttonDecoration,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: black,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
