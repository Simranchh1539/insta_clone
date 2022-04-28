import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostTabBar extends StatelessWidget {
  final String uid;

  const PostTabBar({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          itemCount: (snapshot.data as dynamic).docs.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 1,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            DocumentSnapshot snap = (snapshot.data as dynamic).docs[index];

            return Container(
              child: Image(
                image: CachedNetworkImageProvider(snap['postUrl']),
                fit: BoxFit.cover,
              ),
            );
          },
        );
      },
    );
  }
}
