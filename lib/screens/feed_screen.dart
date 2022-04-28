import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramclone/screens/add_post.dart';

import 'package:instagramclone/screens/message_main_page.dart';

import 'package:instagramclone/widgets/post_card.dart';
import 'package:instagramclone/widgets/stories.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.color,
          centerTitle: false,
          elevation: 0.0,
          title: SvgPicture.asset(
            'assets/ic_instagram.svg',
            height: 35,
            //fit: BoxFit.fill,
            //width: 30,
            color: Theme.of(context).iconTheme.color,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Image.asset("assets/postimg.png",
                    color: Theme.of(context).iconTheme.color,
                    height: 27,
                    width: 27),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddPost())),
              ),
            ),
            InkWell(
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ChatRoom())),
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: SvgPicture.asset("assets/newshare.svg",
                    color: Theme.of(context).iconTheme.color,
                    height: 20,
                    width: 20),
              ),
            )
          ],
        ),
        // body: Column(
        //   children: [
        //     Expanded(
        //       child: Column(
        //         mainAxisSize: MainAxisSize.max,
        //         children: [
        //           Container(height: 100, child: Stories()),
        //           Container(
        //             height: double.infinity,
        //             child: Expanded(
        //               child: StreamBuilder(
        //                   stream: FirebaseFirestore.instance
        //                       .collection('posts')
        //                       .orderBy(
        //                         'datePublished',
        //                         descending: true,
        //                       )
        //                       .snapshots(),
        //                   builder: (context,
        //                       AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
        //                           snapshot) {
        //                     if (snapshot.connectionState ==
        //                         ConnectionState.waiting) {
        //                       return Center(
        //                         child: CircularProgressIndicator(),
        //                       );
        //                     }
        //                     return ListView.builder(
        //                       itemCount: snapshot.data.docs.length,
        //                       itemBuilder: (context, index) => PostCard(
        //                           snap: snapshot.data.docs[index].data()),
        //                     );
        //                   }),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
        body: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(height: 100, child: Stories()),
                  ],
                ),
              ),
            ];
          },
          body: Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
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
                        PostCard(snap: snapshot.data.docs[index].data()),
                  );
                }),
          ),
        ));
  }
}
