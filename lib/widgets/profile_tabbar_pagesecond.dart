import 'package:flutter/material.dart';

class ProfileTabBarPageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Photos and",
            style: TextStyle(
                color: Theme.of(context).iconTheme.color,
                fontWeight: FontWeight.bold,
                fontSize: 24),
          ),
          Text(
            "videos of you",
            style: TextStyle(
                color: Theme.of(context).iconTheme.color,
                fontWeight: FontWeight.bold,
                fontSize: 24),
          ),
          SizedBox(height: 10),
          Text(
            "When people tag you in photos and",
            style: TextStyle(
                color: Theme.of(context).iconTheme.color.withOpacity(0.7),
                fontWeight: FontWeight.w400,
                fontSize: 15),
          ),
          SizedBox(height: 1),
          Text(
            "videos, they'll appear here.",
            style: TextStyle(
                color: Theme.of(context).iconTheme.color.withOpacity(0.7),
                fontWeight: FontWeight.w400,
                fontSize: 15),
          ),
        ],
      ),
    );
  }
}
