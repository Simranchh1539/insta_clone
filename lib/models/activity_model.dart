import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String id;
  final String fromUserId;
  final String postId;
  final String postImageUrl;
  final String comment;

  final bool isLikeEvent;

  final bool isCommentEvent;

  final Timestamp timestamp;

  Activity({
    this.id,
    this.fromUserId,
    this.postId,
    this.postImageUrl,
    this.comment,
    this.timestamp,
    this.isLikeEvent,
    this.isCommentEvent,
  });

  factory Activity.fromDoc(DocumentSnapshot doc) {
    return Activity(
      id: doc.id,
      fromUserId: doc['fromUserId'],
      postId: doc['postId'],
      postImageUrl: doc['postImageUrl'],
      comment: doc['comment'],
      timestamp: doc['timestamp'],
      isCommentEvent: doc['isCommentEvent'] ?? false,
      isLikeEvent: doc['isLikeEvent'] ?? false,
    );
  }
}
