import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  final snap;

  const NotificationScreen({Key key, this.snap}) : super(key: key);
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.color,
        title: Text(
          "Activity",
          style: TextStyle(
            color: Theme.of(context).iconTheme.color,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser.uid)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return (snapshot.data.docs[index]['likes'] != null)
                      ? Padding(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 15),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                    snapshot.data.docs[index]['profImage'],
                                  ),
                                  radius: 17,
                                ),
                                SizedBox(width: 15),
                                Text(
                                  '${snapshot.data.docs[index]['username']} liked your Post',
                                  style: TextStyle(
                                      color: Theme.of(context).iconTheme.color),
                                ),
                              ]),
                        )
                      : Container();
                });
          }),
    );
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:instagramclone/models/activity_model.dart';
// import 'package:instagramclone/response/check.dart';
// import 'package:instagramclone/response/firestore_methods.dart';
// import 'package:instagramclone/utils/colors.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import 'package:cached_network_image/cached_network_image.dart';

// class ActivityScreen extends StatefulWidget {
//   @override
//   _ActivityScreenState createState() => _ActivityScreenState();
// }

// class _ActivityScreenState extends State<ActivityScreen> {
//   List<Activity> _activities = [];
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _setupActivities();
//   }

//   _setupActivities() async {
//     setState(() => _isLoading = true);
//     List<Activity> activities = await FireStoreMethods()
//         .getActivities(FirebaseAuth.instance.currentUser.uid);
//     if (mounted) {
//       setState(() {
//         _activities = activities;
//         _isLoading = false;
//       });
//     }
//   }

//   _buildActivity(Activity activity) {
//     return FutureBuilder(
//       future: FirebaseHelper.getUserModelById(activity.fromUserId),
//       builder: (BuildContext context, AsyncSnapshot snapshot) {
//         if (!snapshot.hasData) {
//           return SizedBox.shrink();
//         }
//         User user = snapshot.data;
//         return ListTile(
//             leading: CircleAvatar(
//               radius: 25.0,
//               backgroundColor: Colors.grey,
//               backgroundImage: user.photoURL.isEmpty
//                   ? AssetImage("assets/message.png")
//                   : CircleAvatar(
//                       backgroundImage: NetworkImage(user.photoURL),
//                     ),
//             ),
//             title: Row(
//               children: <Widget>[
//                 Text('${user.displayName}', style: kFontWeightBoldTextStyle),
//                 SizedBox(width: 5),
//                 Expanded(
//                   child: Text(
//                     'liked your post',
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//             subtitle: Text(
//               timeago.format(activity.timestamp.toDate()),
//             ),
//             trailing: activity.postImageUrl == null
//                 ? SizedBox.shrink()
//                 : CachedNetworkImage(
//                     imageUrl: activity.postImageUrl,
//                     fadeInDuration: Duration(milliseconds: 500),
//                     height: 40.0,
//                     width: 40.0,
//                     fit: BoxFit.cover,
//                   ),
//             onTap: () {});
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).appBarTheme.color,
//         title: Text(
//           'Activity',
//         ),
//       ),
//       body: RefreshIndicator(
//         onRefresh: () => _setupActivities(),
//         child: _isLoading
//             ? Center(
//                 child: CircularProgressIndicator(),
//               )
//             : ListView.builder(
//                 itemCount: _activities.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   Activity activity = _activities[index];

//                   return _buildActivity(activity);
//                 },
//               ),
//       ),
//     );
//   }
// }
