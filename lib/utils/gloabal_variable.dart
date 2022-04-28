import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:instagramclone/screens/feed_screen.dart';
import 'package:instagramclone/screens/notification.dart';
import 'package:instagramclone/screens/profile_screen.dart';
import 'package:instagramclone/screens/reels.dart';
import 'package:instagramclone/screens/search_screen.dart';

List<Widget> homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  ReelsScreen(),
  NotificationScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser.uid,
  ),
];
