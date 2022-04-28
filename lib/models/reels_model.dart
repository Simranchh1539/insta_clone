import 'package:instagramclone/models/user.dart';

class Reels {
  final String postedby;
  final String imageurl;
  final String audiotitle;
  final String caption;
  final String totallikes;
  final String totalcomments;
  final bool islike;
  final bool isTagged;
  final String taggedUser;

  Reels(
      this.postedby,
      this.imageurl,
      this.audiotitle,
      this.caption,
      this.totallikes,
      this.totalcomments,
      this.islike,
      this.isTagged,
      this.taggedUser);
}
