import 'package:flutter/material.dart';
import 'package:instagramclone/models/user.dart';
import 'package:instagramclone/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final snap;

  const CommentCard({Key key, @required this.snap}) : super(key: key);
  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              widget.snap['profilePic'],
            ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        TextSpan(
                          text: ' ${widget.snap['text']}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate()),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context)
                              .iconTheme
                              .color
                              .withOpacity(0.7)),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.favorite_border,
              size: 16,
              color: Theme.of(context).iconTheme.color.withOpacity(0.5),
            ),
          )
        ],
      ),
    );
  }
}
