import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/models/reels_model.dart';
import 'package:instagramclone/models/user.dart';
import 'package:instagramclone/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:marquee/marquee.dart';
import 'package:expandable_text/expandable_text.dart';

class ReelHorizontalBar extends StatelessWidget {
  final Reels reel;

  const ReelHorizontalBar({Key key, this.reel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          //dense: true,
          minLeadingWidth: 0,
          horizontalTitleGap: 12,
          title: Text(
            "${reel.postedby}. follow",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
          leading: CircleAvatar(
            radius: 14,
            backgroundImage: CachedNetworkImageProvider(user.photourl),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22),
          child: ExpandableText(
            reel.caption,
            style: TextStyle(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400),
            expandText: 'more',
            collapseText: 'less',
            expandOnTextTap: true,
            collapseOnTextTap: true,
            maxLines: 1,
            linkColor: Colors.grey,
          ),
        ),
        ListTile(
            dense: true,
            minLeadingWidth: 0,
            horizontalTitleGap: 12,
            title: reel.isTagged
                ? Row(
                    children: [
                      Container(
                        height: 20,
                        width: 140,
                        child: Marquee(
                          text: "${reel.audiotitle}.Original Audio",
                          scrollAxis: Axis.horizontal,
                          blankSpace: 10,
                          velocity: 10,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                        ),
                        child: Icon(
                          Icons.person_outline_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${reel.taggedUser}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      )
                    ],
                  )
                : Text(
                    "${reel.audiotitle} . Orignal Audio",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
            leading: Icon(
              Icons.graphic_eq_outlined,
              size: 16,
              color: Colors.white,
            )),
      ],
    ));
  }
}
