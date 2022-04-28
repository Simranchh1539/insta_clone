import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramclone/models/reels_model.dart';
import 'package:instagramclone/models/user.dart';
import 'package:instagramclone/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ReelSideBar extends StatelessWidget {
  final Reels reel;

  const ReelSideBar({Key key, this.reel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
        height: 300,
        child: Column(
          children: [
            IconButton(
                icon: Icon(
                  reel.islike ? Icons.favorite : Icons.favorite_border_outlined,
                  size: 30,
                  color: reel.islike ? Colors.red : Colors.white,
                ),
                onPressed: () {}),
            Text(
              reel.totallikes,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),
            IconButton(
                icon: SvgPicture.asset(
                  "assets/comment.svg",
                  color: Colors.white,
                  height: 25,
                ),
                onPressed: () {}),
            Text(
              reel.totalcomments,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),
            IconButton(
                icon: SvgPicture.asset(
                  "assets/newshare.svg",
                  color: Colors.white,
                  height: 23,
                ),
                onPressed: () {}),
            IconButton(
                icon: Icon(
                  Icons.more_vert_outlined,
                  size: 28,
                  color: Colors.white,
                ),
                onPressed: () {}),
            SizedBox(height: 10),
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(
                    user.photourl,
                  ))),
            )
          ],
        ));
  }
}
