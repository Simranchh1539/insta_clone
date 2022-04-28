import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/models/user.dart';
import 'package:instagramclone/providers/user_provider.dart';
import 'package:instagramclone/response/firestore_methods.dart';

import 'package:instagramclone/widgets/comment_card.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final snap;

  const CommentScreen({Key key, this.snap}) : super(key: key);
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.color,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Comments",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 23,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Image.asset("assets/send.png",
                color: Theme.of(context).iconTheme.color,
                height: 25,
                width: 18),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                  radius: 18,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: widget.snap['username'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                              TextSpan(
                                text: ' ${widget.snap['description']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            DateFormat.yMMMd()
                                .format(widget.snap['datePublished'].toDate()),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 0.5,
                        color: Theme.of(context)
                            .iconTheme
                            .color
                            .withOpacity(0.6)))),
          ),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(widget.snap['postId'])
                    .collection('comments')
                    .orderBy(
                      'datePublished',
                      descending: true,
                    )
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) =>
                        CommentCard(snap: snapshot.data.docs[index].data()),
                  );
                }),
          )
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            height: kToolbarHeight,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            padding: EdgeInsets.only(
              left: 16,
              right: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    user.photourl,
                  ),
                  radius: 18,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: "Add a comment...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await FireStoreMethods().postComment(
                        widget.snap['postId'],
                        _commentController.text,
                        user.uid,
                        user.username,
                        user.photourl);

                    setState(() {
                      _commentController.text = "";
                    });
                  },
                  child: Container(
                      padding: EdgeInsets.only(right: 10),
                      child: Text("Post",
                          style: TextStyle(
                            color: Colors.blueAccent.withOpacity(0.4),
                            fontSize: 15,
                          ))),
                )
              ],
            )),
      ),
    );
  }
}
