import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagramclone/models/activity_model.dart';
import 'package:instagramclone/models/posts.dart';
import 'package:instagramclone/response/storage_method.dart';
import 'package:uuid/uuid.dart';
import 'package:instagramclone/models/user.dart' as model;

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<String> postComment(String postId, String text, String uid,
      String name, String profilepic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilepic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data() as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // void likePost({String currentUserId, Post post, String receiverToken}) {
  //   final postsRef = _firestore.collection('posts');
  //   final likesRef = _firestore.collection('likes');
  //   DocumentReference postRef = postsRef.doc(post.postId);
  //   postRef.get().then((doc) {
  //     int likeCount = doc['likeCount'];
  //     postRef.update({'likeCount': likeCount + 1});
  //     likesRef
  //         .doc(post.postId)
  //         .collection('postLikes')
  //         .doc(FirebaseAuth.instance.currentUser.uid)
  //         .set({});
  //   });

  //   addActivityItem(
  //     currentUserId: currentUserId,
  //     post: post,
  //     comment: post.description ?? null,
  //     isLikeEvent: true,
  //     isCommentEvent: false,
  //     recieverToken: receiverToken,
  //   );
  // }

  // void unlikePost({String currentUserId, Post post}) {
  //   final postsRef = _firestore.collection('posts');
  //   final likesRef = _firestore.collection('likes');
  //   DocumentReference postRef = postsRef.doc(post.postId);
  //   postRef.get().then((doc) {
  //     int likeCount = doc['likeCount'];
  //     postRef.update({'likeCount': likeCount + -1});
  //     likesRef
  //         .doc(post.postId)
  //         .collection('postLikes')
  //         .doc(FirebaseAuth.instance.currentUser.uid)
  //         .get()
  //         .then((doc) {
  //       if (doc.exists) {
  //         doc.reference.delete();
  //       }
  //     });
  //   });

  //   deleteActivityItem(
  //     comment: null,
  //     currentUserId: FirebaseAuth.instance.currentUser.uid,
  //     post: post,
  //     isCommentEvent: false,
  //     isLikeEvent: true,
  //   );
  // }

  // Future<bool> didLikePost({String currentUserId, Post post}) async {
  //   final likesRef = _firestore.collection('likes');
  //   DocumentSnapshot userDoc = await likesRef
  //       .doc(post.postId)
  //       .collection('postLikes')
  //       .doc(FirebaseAuth.instance.currentUser.uid)
  //       .get();
  //   return userDoc.exists;
  // }

  void addActivityItem({
    String currentUserId,
    Post post,
    String comment,
    bool isCommentEvent,
    bool isLikeEvent,
    bool isMessageEvent,
    String recieverToken,
  }) {
    if (currentUserId != post.uid) {
      final activitiesRef = _firestore.collection('activities');
      activitiesRef.doc(post.uid).collection('userActivities').add({
        'fromUserId': currentUserId,
        'postId': post.postId,
        'postImageUrl': post.postUrl,
        'comment': comment,
        'timestamp': Timestamp.fromDate(DateTime.now()),
        'isCommentEvent': isCommentEvent,
        'isLikeEvent': isLikeEvent,
        'isMessageEvent': isMessageEvent,
        'recieverToken': recieverToken,
      });
    }
  }

  void deleteActivityItem(
      {String currentUserId,
      Post post,
      String comment,
      bool isFollowEvent,
      bool isCommentEvent,
      bool isLikeEvent,
      bool isMessageEvent,
      bool isLikeMessageEvent}) async {
    String boolCondition;

    if (isCommentEvent) {
      boolCondition = 'isCommentEvent';
    } else if (isLikeEvent) {
      boolCondition = 'isLikeEvent';
    }
    QuerySnapshot activities = await _firestore
        .collection('activities')
        .doc(post.uid)
        .collection('userActivities')
        .where('fromUserId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .where('postId', isEqualTo: post.postId)
        .where(boolCondition, isEqualTo: true)
        .get();

    activities.docs.forEach((element) {
      final activitiesRef = _firestore.collection('activities');
      activitiesRef
          .doc(post.uid)
          .collection('userActivities')
          .doc(element.id)
          .delete();
    });
  }

  Future<List<Activity>> getActivities(String uid) async {
    final activitiesRef = _firestore.collection('activities');
    QuerySnapshot userActivitiesSnapshot = await activitiesRef
        .doc(uid)
        .collection('userActivities')
        .orderBy('timestamp', descending: true)
        .get();
    List<Activity> activity = userActivitiesSnapshot.docs
        .map((doc) => Activity.fromDoc(doc))
        .toList();
    return activity;
  }
}
