import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Imagesio/models/author.dart';
import 'package:Imagesio/models/notification.dart';
import 'package:Imagesio/models/post.dart';

class NotificationService {
  Future<NotificationType> populateNotification(
      NotificationType notification) async {
    NotificationType populatedNotification = notification;

    // populate user send
    DocumentSnapshot userSendSnap = await notification.userSendRef.get();
    Author? userSendInfo =
        Author.fromJson(userSendSnap.data() as Map<String, dynamic>);
    populatedNotification.userSend = userSendInfo;

    // populate user receive
    DocumentSnapshot userReceiveSnap = await notification.userReceiveRef.get();
    Author? userReceiveInfo =
        Author.fromJson(userReceiveSnap.data() as Map<String, dynamic>);
    populatedNotification.userReceive = userReceiveInfo;

    //populate post if have
    if (notification.postRef != null) {
      DocumentSnapshot postSnap = await notification.postRef!.get();
      Post postInfor = Post.fromJson(postSnap.data() as Map<String, dynamic>);
      populatedNotification.post = postInfor;
    }

    return populatedNotification;
  }

  Stream<List<NotificationType>> getNotifications(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) {
      return Future.wait(snapshot.docs.map((document) async {
        NotificationType notification =
            NotificationType.fromJson(document.data());

        notification = await populateNotification(notification);

        return notification;
      }).toList());
    });
  }

  // .withConverter<NotificationType>(
  //         fromFirestore: (snapshot, _) =>
  //             NotificationType.fromFirestore(snapshot, _),
  //         toFirestore: (NotificationType notification, _) =>
  //             notification.toFirestore());

  deleteNotification(String notificationId, String userReceiveId) {
    print('$userReceiveId $notificationId');
    FirebaseFirestore.instance
        .collection('users')
        .doc(userReceiveId)
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }
}
