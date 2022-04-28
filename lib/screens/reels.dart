import 'package:flutter/material.dart';
import 'package:instagramclone/utils/reels_data.dart';
import 'package:instagramclone/widgets/reel_horizontal_bar.dart';
import 'package:instagramclone/widgets/reel_side_bar.dart';
import 'package:instagramclone/widgets/video_tile.dart';
import 'package:video_player/video_player.dart';

class ReelsScreen extends StatefulWidget {
  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  @override
  Widget build(BuildContext context) {
    int index = 0;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          reels[index] == 0 ? "Reels" : "",
          style: TextStyle(
            color: Theme.of(context).scaffoldBackgroundColor,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.photo_camera_outlined,
                color: Theme.of(context).scaffoldBackgroundColor,
                size: 27,
              ),
              onPressed: () {})
        ],
        elevation: 0,
      ),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: reels.length,
        itemBuilder: (context, index) {
          return Container(
            child: Center(
              child: Stack(
                children: [
                  VideoTile(
                    reel: reels[index],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                        ],
                        begin: Alignment(0, -0.75),
                        end: Alignment(0, 0.01),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                        ],
                        end: Alignment(0, -0.75),
                        begin: Alignment(0, 0.01),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            flex: 12,
                            child: ReelHorizontalBar(
                              reel: reels[index],
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: ReelSideBar(
                              reel: reels[index],
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
