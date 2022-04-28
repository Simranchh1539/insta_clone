import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramclone/models/posts.dart';
import 'package:instagramclone/models/user.dart' as model;
import 'package:instagramclone/providers/user_provider.dart';
import 'package:instagramclone/response/firestore_methods.dart';
import 'package:instagramclone/screens/comments.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/image_picker_utility.dart';
import 'package:instagramclone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;

  const PostCard({Key key, this.snap}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isAnimation = false;
  int comment = 0;

  @override
  void initState() {
    super.initState();

    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();

      comment = snap.docs.length;
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: CachedNetworkImageProvider(
                    widget.snap['profImage'],
                  ),
                ),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.snap['username'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          )
                        ],
                      )),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: ListView(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shrinkWrap: true,
                          children: [
                            "Delete",
                          ]
                              .map(
                                (e) => InkWell(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    child: Text(e),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FireStoreMethods().likePost(
                  widget.snap['postId'], user.uid, widget.snap['likes']);
              setState(() {
                isAnimation = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.40,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: widget.snap['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: Duration(
                    milliseconds: 200,
                  ),
                  opacity: isAnimation ? 1 : 0,
                  child: LikeAnimation(
                    isliking: isAnimation,
                    duration: Duration(milliseconds: 200),
                    child: Icon(
                      Icons.favorite,
                      size: 100,
                      color: Colors.white,
                    ),
                    onEnd: () {
                      setState(() {
                        isAnimation = false;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isliking: widget.snap['likes'].contains(user.uid),
                like: true,
                child: IconButton(
                  icon: widget.snap['likes'].contains(user.uid)
                      ? Icon(Icons.favorite, color: Colors.red, size: 27)
                      : Icon(Icons.favorite_border, size: 27),
                  onPressed: () async {
                    await FireStoreMethods().likePost(
                        widget.snap['postId'], user.uid, widget.snap['likes']);
                    setState(
                      () {
                        isAnimation = false;
                      },
                    );
                  },
                ),
              ),
              // IconButton(
              //     icon: _isLiked
              //         ? Icon(
              //             Icons.favorite,
              //             size: 36,
              //             color: Colors.red,
              //           )
              //         : Icon(Icons.favorite_border_outlined, size: 36),
              //     iconSize: 30.0,
              //     onPressed: _likePost),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/comment.svg",
                  color: Theme.of(context).iconTheme.color,
                  height: 20,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommentScreen(
                      snap: widget.snap,
                    ),
                  ),
                ),
              ),
              IconButton(
                  icon: SvgPicture.asset(
                    "assets/newshare.svg",
                    color: Theme.of(context).iconTheme.color,
                    height: 18,
                  ),
                  onPressed: () {}),
              Expanded(
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: Icon(Icons.bookmark_border),
                        onPressed: () {},
                      )))
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 2, left: 13),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                  child: Text("${widget.snap['likes'].length} likes",
                      style:
                          TextStyle(color: Theme.of(context).iconTheme.color)),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 4),
                  child: RichText(
                    text: TextSpan(
                        style:
                            TextStyle(color: Theme.of(context).iconTheme.color),
                        children: [
                          TextSpan(
                            text: widget.snap['username'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                            text: ' ${widget.snap['description']}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ]),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CommentScreen(snap: widget.snap))),
                  child: Container(
                      padding: EdgeInsets.only(top: 4),
                      child: (comment <= 1)
                          ? Text('View all $comment comment',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .iconTheme
                                    .color
                                    .withOpacity(0.6),
                              ))
                          : Text('View all $comment comments',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .iconTheme
                                    .color
                                    .withOpacity(0.6),
                              ))),
                ),
                Container(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(
                      color: secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
