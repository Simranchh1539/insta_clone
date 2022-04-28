import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramclone/models/chat_room_model.dart';
import 'package:instagramclone/models/user.dart' as model;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/providers/user_provider.dart';
import 'package:instagramclone/response/firestore_methods.dart';
import 'package:instagramclone/screens/chat_screen.dart';
import 'package:instagramclone/screens/edit_profile.dart';
import 'package:instagramclone/screens/log_in.dart';
import 'package:instagramclone/screens/reels_post_profile_screen.dart';
import 'package:instagramclone/screens/theme.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/image_picker_utility.dart';
import 'package:instagramclone/widgets/profile_button.dart';
import 'package:instagramclone/widgets/profile_tabbar_pageone.dart';
import 'package:instagramclone/widgets/profile_tabbar_pagesecond.dart';
import 'package:instagramclone/widgets/profite_widget.dart';
import 'package:instagramclone/widgets/story_tile.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({Key key, @required this.uid}) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  var userData = {};
  int postlength = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  model.User _profileUser;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    getData();
    _tabController = new TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
  }

  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where(
            'uid',
            isEqualTo: FirebaseAuth.instance.currentUser.uid,
          )
          .get();

      postlength = postSnap.docs.length;
      userData = userSnap.data();
      followers = userSnap.data()['followers'].length;
      following = userSnap.data()['following'].length;
      isFollowing = userSnap
          .data()['followers']
          .contains(FirebaseAuth.instance.currentUser.uid);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
      setState(() {
        isLoading = true;
      });
    }
  }

  Future<ChatRoomModel> getChatroomModel(String targetUser) async {
    ChatRoomModel chatRoom;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${FirebaseAuth.instance.currentUser.uid}",
            isEqualTo: true)
        .where("participants.${widget.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.length > 0) {
      // Fetch the existing one
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatroom;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(
                    chatRoomId: chatRoom.chatroomid,
                    uid: widget.uid,
                    chatroom: chatRoom,
                  )));
    } else {
      // Create a new one
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: Uuid().v1(),
        lastMessage: "",
        participants: {
          FirebaseAuth.instance.currentUser.uid.toString(): true,
          widget.uid.toString(): true,
        },
      );

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.toMap());

      chatRoom = newChatroom;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(
                    chatRoomId: newChatroom.chatroomid,
                    uid: widget.uid,
                    chatroom: chatRoom,
                  )));

      print("New Chatroom Created!");
    }

    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: AppBar(
                backgroundColor: Theme.of(context).appBarTheme.color,
                elevation: 0,
                centerTitle: false,
                title: Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      color: Theme.of(context).iconTheme.color.withOpacity(0.6),
                      size: 17,
                    ),
                    SizedBox(width: 5),
                    Text(
                      (widget.uid == FirebaseAuth.instance.currentUser.uid)
                          ? user.username
                          : userData['username'],
                      style: TextStyle(
                          color: Theme.of(context).iconTheme.color,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                  ],
                ),
                actions: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/post.png",
                        width: 18,
                        height: 18,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      SizedBox(width: 10),
                      IconButton(
                          icon: Image.asset(
                            "assets/menuslim.png",
                            color: Theme.of(context).iconTheme.color,
                            width: 18,
                            height: 21,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isDismissible: true,
                              backgroundColor:
                                  Theme.of(context).backgroundColor,

                              elevation: 15,
                              // gives rounded corner to modal bottom screen
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              builder: (BuildContext context) {
                                return Container(
                                    child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.settings),
                                            onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ThemeScreen(),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Settings",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.exit_to_app_outlined,
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                            ),
                                            onPressed: () async {
                                              await FirebaseAuth.instance
                                                  .signOut();
                                              Navigator.popUntil(context,
                                                  (route) => route.isFirst);
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                  return LogIn();
                                                }),
                                              );
                                            },
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Sign Out",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                                fontSize: 16),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ));
                              },
                            );
                          }),
                    ],
                  ),
                ],
              ),
            ),
            body: DefaultTabController(
                length: 3,
                child: NestedScrollView(
                    headerSliverBuilder: (context, _) {
                      return [
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 42,
                                          backgroundColor: Colors.grey,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                            (widget.uid ==
                                                    FirebaseAuth.instance
                                                        .currentUser.uid)
                                                ? user.photourl
                                                : userData['photoUrl'],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              BuildColumn(
                                                  num: postlength,
                                                  label: "Posts"),
                                              BuildColumn(
                                                  num: followers,
                                                  label: "Followers"),
                                              BuildColumn(
                                                  num: following,
                                                  label: "Following"),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        (widget.uid ==
                                                FirebaseAuth
                                                    .instance.currentUser.uid)
                                            ? Text(user.username,
                                                style:
                                                    TextStyle(
                                                        color: Theme.of(context)
                                                            .iconTheme
                                                            .color,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w700))
                                            : Text(userData['username'],
                                                style:
                                                    TextStyle(
                                                        color: Theme.of(context)
                                                            .iconTheme
                                                            .color,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                        SizedBox(height: 3),
                                        (widget.uid ==
                                                FirebaseAuth
                                                    .instance.currentUser.uid)
                                            ? Text(user.bio,
                                                style:
                                                    TextStyle(
                                                        color: Theme.of(context)
                                                            .iconTheme
                                                            .color,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400))
                                            : Text(userData['bio'],
                                                style:
                                                    TextStyle(
                                                        color: Theme.of(context)
                                                            .iconTheme
                                                            .color,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FirebaseAuth.instance.currentUser.uid ==
                                                widget.uid
                                            ? Row(
                                                children: [
                                                  ProfileButton(
                                                    text: 'Edit profile',
                                                    width: 320,
                                                    backgroundColor: Theme.of(
                                                            context)
                                                        .scaffoldBackgroundColor,
                                                    textColor: Theme.of(context)
                                                        .iconTheme
                                                        .color,
                                                    borderColor: Colors.grey,
                                                    function: () {},
                                                  ),
                                                  Container(
                                                      width: 34,
                                                      height: 36,
                                                      // margin: EdgeInsets.only(
                                                      //     top: 6),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          width: 0.5,
                                                          color: Theme.of(
                                                                  context)
                                                              .iconTheme
                                                              .color
                                                              .withOpacity(0.6),
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                      ),
                                                      child: Icon(
                                                          Icons.person_add,
                                                          color:
                                                              Theme.of(context)
                                                                  .iconTheme
                                                                  .color,
                                                          size: 18)),
                                                ],
                                              )
                                            : isFollowing
                                                ? Row(
                                                    children: [
                                                      ProfileButton(
                                                        text: 'Following',
                                                        width: 175,
                                                        backgroundColor: Theme
                                                                .of(context)
                                                            .scaffoldBackgroundColor,
                                                        textColor:
                                                            Theme.of(context)
                                                                .iconTheme
                                                                .color,
                                                        borderColor: Theme.of(
                                                                context)
                                                            .iconTheme
                                                            .color
                                                            .withOpacity(0.5),
                                                        function: () async {
                                                          await FireStoreMethods()
                                                              .followUser(
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser
                                                                .uid,
                                                            userData['uid'],
                                                          );

                                                          setState(() {
                                                            isFollowing = false;
                                                            followers--;
                                                          });
                                                        },
                                                      ),
                                                      ProfileButton(
                                                        text: 'Message',
                                                        width: 175,
                                                        backgroundColor: Theme
                                                                .of(context)
                                                            .scaffoldBackgroundColor,
                                                        textColor:
                                                            Theme.of(context)
                                                                .iconTheme
                                                                .color,
                                                        borderColor:
                                                            Colors.grey,
                                                        function: () async {
                                                          ChatRoomModel
                                                              chatroomModel =
                                                              await getChatroomModel(
                                                                  widget.uid);
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ChatScreen(
                                                                            uid:
                                                                                widget.uid,
                                                                            chatRoomId:
                                                                                chatroomModel.chatroomid,
                                                                            chatroom:
                                                                                chatroomModel,
                                                                          )));
                                                        },
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    children: [
                                                      ProfileButton(
                                                        text: 'Follow',
                                                        width: 320,
                                                        backgroundColor:
                                                            blueColor,
                                                        textColor: Colors.white,
                                                        borderColor:
                                                            Colors.blue,
                                                        function: () async {
                                                          await FireStoreMethods()
                                                              .followUser(
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser
                                                                .uid,
                                                            userData['uid'],
                                                          );

                                                          setState(() {
                                                            isFollowing = true;
                                                            followers++;
                                                          });
                                                        },
                                                      ),
                                                      Container(
                                                        width: 34,
                                                        height: 36,
                                                        // margin:
                                                        //     EdgeInsets.only(
                                                        //         top: 6),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: Theme.of(
                                                                    context)
                                                                .iconTheme
                                                                .color
                                                                .withOpacity(
                                                                    0.6),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                        ),
                                                        child: Icon(
                                                          Icons.person_add,
                                                          color:
                                                              Theme.of(context)
                                                                  .iconTheme
                                                                  .color,
                                                          size: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                      ],
                                    ),
                                  ),
                                  FirebaseAuth.instance.currentUser.uid ==
                                          widget.uid
                                      ? StoryTile()
                                      : Text(""),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ];
                    },
                    body: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          Material(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: TabBar(
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.grey.shade300,
                              controller: _tabController,
                              tabs: [
                                Tab(
                                  icon: Image.asset(
                                    "assets/postnew.png",
                                    color: (_tabController.index == 0)
                                        ? Theme.of(context).iconTheme.color
                                        : Theme.of(context)
                                            .iconTheme
                                            .color
                                            .withOpacity(0.5),
                                    height: 28,
                                  ),
                                ),
                                Tab(
                                  icon: SvgPicture.asset(
                                    "assets/reels.svg",
                                    color: (_tabController.index == 1)
                                        ? Theme.of(context).iconTheme.color
                                        : Theme.of(context)
                                            .iconTheme
                                            .color
                                            .withOpacity(0.5),
                                    height: 25,
                                  ),
                                ),
                                Tab(
                                  icon: SvgPicture.asset(
                                    "assets/tag.svg",
                                    color: (_tabController.index == 2)
                                        ? Theme.of(context).iconTheme.color
                                        : Theme.of(context)
                                            .iconTheme
                                            .color
                                            .withOpacity(0.5),
                                    height: 22,
                                    width: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              child: TabBarView(
                            controller: _tabController,
                            children: [
                              PostTabBar(uid: widget.uid),
                              Text(""),
                              ProfileTabBarPageTwo(),
                            ],
                          ))
                        ],
                      ),
                    ))),
          );
  }
}
