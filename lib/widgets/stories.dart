import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/models/user.dart';
import 'package:instagramclone/providers/user_provider.dart';
import 'package:instagramclone/utils/stories_json.dart';
import 'package:provider/provider.dart';

class Stories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      height: 160,
      child: ListView(scrollDirection: Axis.horizontal, children: [
        Row(
            children: List.generate(stories.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(
              top: 5,
              left: 10,
            ),
            child: Container(
              width: 65,
              child: Column(
                children: [
                  Stack(
                    children: [
                      stories[index]['isStory']
                          ? Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xffA844A1),
                                    const Color(0xffAB429A),
                                    const Color(0xffB43C88),
                                    const Color(0xffC33269),
                                    const Color(0xffD7243F),
                                    const Color(0xffF9A326),
                                    const Color(0xffF9DD26),
                                  ],
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  height: 70,
                                  width: 65,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 2,
                                        color: Color(0xffffffff),
                                      ),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              stories[index]['imageUrl']),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0xffC8C8C8),
                                    ),
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            user.photourl),
                                        fit: BoxFit.cover)),
                              ),
                            ),
                      stories[index]['isAdd']
                          ? Positioned(
                              right: 5,
                              bottom: 5,
                              child: Container(
                                height: 19,
                                width: 19,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xff0095f6),
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    width: 2,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Color(0xffffffff),
                                    size: 13,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  SizedBox(height: 1),
                  Text(
                    stories[index]['username'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).iconTheme.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        })),
      ]),
    );
  }
}
