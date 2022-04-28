import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/models/chat_room_model.dart';
import 'package:instagramclone/models/message_model.dart';
import 'package:instagramclone/models/user.dart' as model;
import 'package:instagramclone/providers/user_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:instagramclone/utils/image_picker_utility.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  final uid;
  final String chatRoomId;
  final ChatRoomModel chatroom;

  const ChatScreen({Key key, this.uid, this.chatRoomId, this.chatroom})
      : super(key: key);
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();
  Stream<QuerySnapshot> chats;

  var userData = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      userData = userSnap.data();

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

  void donothing(BuildContext) {}
  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    addMessage() {
      String msg = _messageController.text.trim();
      _messageController.clear();

      if (msg != "") {
        // Send Message
        MessageModel newMessage = MessageModel(
            messageid: Uuid().v1(),
            sender: FirebaseAuth.instance.currentUser.uid,
            createdon: DateTime.now(),
            text: msg,
            seen: false);

        FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(widget.chatRoomId)
            .collection("messages")
            .doc(newMessage.messageid)
            .set(newMessage.toMap());

        widget.chatroom.lastMessage = msg;
        FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(widget.chatRoomId)
            .set(widget.chatroom.toMap());
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.color,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 17,
              backgroundImage: NetworkImage(
                userData['photoUrl'],
              ),
            ),
            SizedBox(
              width: 13,
            ),
            Text(
              userData['username'],
              style: TextStyle(
                color: Theme.of(context).iconTheme.color,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
          child: Container(
              child: Column(
        children: [
          // This is where the chats will go
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chatrooms")
                    .doc(widget.chatRoomId)
                    .collection("messages")
                    .orderBy("createdon", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot =
                          snapshot.data as QuerySnapshot;

                      return Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dragDismissible: false,
                          children: [
                            SlidableAction(
                                onPressed: donothing,
                                autoClose: true,
                                spacing: 0,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                foregroundColor: Theme.of(context)
                                    .iconTheme
                                    .color
                                    .withOpacity(0.6),
                                label: ""),
                          ],
                        ),
                        child: Container(
                          child: ListView.builder(
                            reverse: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: dataSnapshot.docs.length,
                            itemBuilder: (context, index) {
                              MessageModel currentMessage =
                                  MessageModel.fromMap(dataSnapshot.docs[index]
                                      .data() as Map<String, dynamic>);

                              return Slidable(
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  dragDismissible: false,
                                  children: [
                                    SlidableAction(
                                        onPressed: donothing,
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        foregroundColor: Theme.of(context)
                                            .iconTheme
                                            .color
                                            .withOpacity(0.6),
                                        label: DateFormat.Hm()
                                            .format(currentMessage.createdon)),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: (currentMessage.sender !=
                                          FirebaseAuth.instance.currentUser.uid)
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          (currentMessage.sender ==
                                                  FirebaseAuth
                                                      .instance.currentUser.uid)
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                      children: [
                                        (currentMessage.sender !=
                                                FirebaseAuth
                                                    .instance.currentUser.uid)
                                            ? SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 12,
                                                    ),
                                                    CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(userData[
                                                              'photoUrl']),
                                                      radius: 16,
                                                    ),
                                                    SizedBox(width: 12),
                                                    Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                          vertical: 3,
                                                        ),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          vertical: 12,
                                                          horizontal: 12,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: (currentMessage
                                                                      .sender ==
                                                                  FirebaseAuth
                                                                      .instance
                                                                      .currentUser
                                                                      .uid)
                                                              ? Colors.grey
                                                                  .withOpacity(
                                                                      0.7)
                                                              : Theme.of(
                                                                      context)
                                                                  .scaffoldBackgroundColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          border: Border.all(
                                                              color: Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .color
                                                                  .withOpacity(
                                                                      0.5),
                                                              width: 0.6),
                                                        ),
                                                        child: Text(
                                                          currentMessage.text
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .iconTheme
                                                                .color,
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              )
                                            : Row(
                                                children: [
                                                  Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                        vertical: 3,
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 12,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: (currentMessage
                                                                    .sender ==
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser
                                                                    .uid)
                                                            ? Colors.grey
                                                                .withOpacity(
                                                                    0.5)
                                                            : Theme.of(context)
                                                                .scaffoldBackgroundColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        border: Border.all(
                                                            color: Theme.of(
                                                                    context)
                                                                .iconTheme
                                                                .color
                                                                .withOpacity(
                                                                    0.2),
                                                            width: 0.6),
                                                      ),
                                                      child: Text(
                                                        currentMessage.text
                                                            .toString(),
                                                        style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .iconTheme
                                                                  .color,
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    width: 12,
                                                  ),
                                                  // Text(
                                                  //   DateFormat.Hm().format(
                                                  //       currentMessage.createdon),
                                                  //   style: TextStyle(
                                                  //     fontSize: 11,
                                                  //     color: Theme.of(context)
                                                  //         .iconTheme
                                                  //         .color
                                                  //         .withOpacity(0.6),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                            "An error occured! Please check your internet connection."),
                      );
                    } else {
                      return Center(
                        child: Text("Say hi to your new friend"),
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
          ),
        ],
      ))),
      bottomNavigationBar: SafeArea(
        child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            height: 50,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom, top: 7),
            padding: EdgeInsets.only(
              left: 16,
              right: 8,
            ),
            child: Container(
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).iconTheme.color.withOpacity(0.6),
                  width: 0.8,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.photo_camera,
                      color: Colors.white,
                    ),
                    radius: 18,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, top: 15),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: "Message...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => addMessage(),
                    child: Container(
                        padding: EdgeInsets.only(right: 10),
                        child: Text("Send",
                            style: TextStyle(
                                color: Colors.blueAccent.withOpacity(0.9),
                                fontSize: 17,
                                fontWeight: FontWeight.bold))),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
