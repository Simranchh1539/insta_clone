import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/models/chat_room_model.dart';
import 'package:instagramclone/providers/user_provider.dart';
import 'package:instagramclone/response/check.dart';
import 'package:instagramclone/screens/chat_screen.dart';

import 'package:instagramclone/models/user.dart' as model;
import 'package:instagramclone/screens/message_request.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.color,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
        title: Text(
          user.username,
          style:
              TextStyle(color: Theme.of(context).iconTheme.color, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Messages",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).iconTheme.color,
                          fontSize: 16),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessageRequest(),
                          ),
                        );
                      },
                      child: Text(
                        "Requests",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.blue,
                            fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chatrooms")
                      .where(
                          "participants.${FirebaseAuth.instance.currentUser.uid}",
                          isEqualTo: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot chatRoomSnapshot =
                            snapshot.data as QuerySnapshot;

                        return ListView.builder(
                          itemCount: chatRoomSnapshot.docs.length,
                          itemBuilder: (context, index) {
                            ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                                chatRoomSnapshot.docs[index].data()
                                    as Map<String, dynamic>);

                            Map<String, dynamic> participants =
                                chatRoomModel.participants;

                            List<String> participantKeys =
                                participants.keys.toList();
                            participantKeys
                                .remove(FirebaseAuth.instance.currentUser.uid);

                            return FutureBuilder(
                              future: FirebaseHelper.getUserModelById(
                                  participantKeys[0]),
                              builder: (context, userData) {
                                if (userData.connectionState ==
                                    ConnectionState.done) {
                                  if (userData.data != null) {
                                    model.User targetUser =
                                        userData.data as model.User;

                                    return ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return ChatScreen(
                                              chatroom: chatRoomModel,
                                              chatRoomId:
                                                  chatRoomModel.chatroomid,
                                              uid: targetUser.uid,
                                            );
                                          }),
                                        );
                                      },
                                      leading: CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(
                                            targetUser.photourl.toString()),
                                      ),
                                      title: Text(
                                        targetUser.username.toString(),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color),
                                      ),
                                      subtitle: (chatRoomModel.lastMessage
                                                  .toString() !=
                                              "")
                                          ? Text(
                                              chatRoomModel.lastMessage
                                                  .toString(),
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color
                                                    .withOpacity(0.6),
                                              ),
                                            )
                                          : Text(
                                              "Say hi to your new friend!",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                            ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                } else {
                                  return Container();
                                }
                              },
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      } else {
                        return Center(
                          child: Text("No Chats"),
                        );
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
