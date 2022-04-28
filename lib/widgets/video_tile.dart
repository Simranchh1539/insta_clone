import 'package:flutter/material.dart';
import 'package:instagramclone/models/reels_model.dart';
import 'package:video_player/video_player.dart';

class VideoTile extends StatefulWidget {
  final Reels reel;

  const VideoTile({Key key, this.reel}) : super(key: key);

  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  VideoPlayerController _videoPlayerController;
  Future _initializeController;
  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.asset("assets/${widget.reel.imageurl}");
    _initializeController = _videoPlayerController.initialize();
    _videoPlayerController.setLooping(true);
    _videoPlayerController.play();
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
      future: _initializeController,
      builder: (context, snapshot) {
        return VideoPlayer(_videoPlayerController);
      },
    ));
  }
}
