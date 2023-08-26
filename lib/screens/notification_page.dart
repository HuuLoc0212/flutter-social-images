import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Imagesio/models/author.dart';
import 'package:Imagesio/models/notification.dart';
import 'package:Imagesio/screens/post/post_page.dart';
import 'package:Imagesio/screens/user_profile.dart';
import 'package:Imagesio/services/notification.dart';
import 'package:provider/provider.dart';

import 'package:timeago/timeago.dart' as timeago;

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    User currentUser = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Notification",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
          stream: NotificationService().getNotifications(currentUser.uid),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SpinKitThreeBounce(
                  color: Colors.lightBlueAccent,
                  size: 24.0,
                ),
              );
            }

            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return SlidableItem(notification: snapshot.data[index]);
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

class SlidableItem extends StatelessWidget {
  final NotificationType notification;
  const SlidableItem({Key? key, required this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final time = DateTime.fromMillisecondsSinceEpoch(notification.createdAt);

    handleTap(NotificationType notification) {
      if (notification.postRef != null) {
        Navigator.pushNamed(context, PostPage.routeName,
            arguments: {'postId': notification.postRef!.id});
      } else {
        Navigator.pushNamed(context, UserProfile.routeName,
            arguments: {'userId': notification.userSendRef.id});
      }
    }

    return InkWell(
      onTap: () {
        handleTap(notification);
      },
      child: Slidable(
          key: Key(notification.id),
          endActionPane: ActionPane(
            // A motion is a widget used to control how the pane animates.
            motion: const ScrollMotion(),

            // A pane can dismiss the Slidable.
            dismissible: DismissiblePane(onDismissed: () {
              NotificationService().deleteNotification(
                  notification.id, notification.userReceive!.uid);
            }),

            children: [
              ElevatedButton(
                onPressed: () {
                  NotificationService().deleteNotification(
                      notification.id, notification.userReceive!.uid);
                },
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.grey,
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(23.0),
                  ),
                ),
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.grey.shade300, width: 1)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            notification.userSend!.avatar,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: notification.userSend!.displayName ??
                                        notification.userSend!.username,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: notification.state == 'like'
                                        ? " liked your post."
                                        : notification.state == 'follow'
                                            ? ' has started following you.'
                                            : ' has comment on your post',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  notification.post != null &&
                                          notification.post!.title != ''
                                      ? TextSpan(
                                          text:
                                              ': "${notification.post!.title}"',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      : const TextSpan()
                                ],
                              ),
                            ),
                            Text(
                              timeago.format(time, locale: 'en'),
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12.0,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      notification.post != null
                          ? Container(
                              width: 40,
                              height: 60,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 1)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  notification.post!.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class NotificationItem extends StatelessWidget {
  const NotificationItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
