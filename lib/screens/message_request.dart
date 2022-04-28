import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MessageRequest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Message requests",
            style: TextStyle(color: Theme.of(context).iconTheme.color)),
        elevation: 0,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 250),
          child: Center(
              child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).iconTheme.color,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: Image.asset("assets/send.png",
                      height: 57,
                      alignment: Alignment.center,
                      color: Theme.of(context).iconTheme.color),
                  radius: 48,
                ),
              ),
              SizedBox(height: 12),
              Text("No message requests",
                  style: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Text("You don't have any message requests",
                  style: TextStyle(
                      color: Theme.of(context).iconTheme.color.withOpacity(0.5),
                      fontSize: 13,
                      fontWeight: FontWeight.w400)),
            ],
          )),
        ),
      ),
    );
  }
}
