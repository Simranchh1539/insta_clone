import 'package:flutter/material.dart';

class StoryTile extends StatefulWidget {
  @override
  _StoryTileState createState() => _StoryTileState();
}

class _StoryTileState extends State<StoryTile> {
  bool isExpansionopen = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Theme(
      data: theme,
      child: ExpansionTile(
        collapsedBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        onExpansionChanged: (_isOpen) {
          setState(() {
            isExpansionopen = true;
          });
        },
        title: Text("Story highlights",
            style: TextStyle(
                color: Theme.of(context).iconTheme.color,
                fontWeight: FontWeight.w600,
                fontSize: 14)),
        subtitle: (isExpansionopen)
            ? Text("Keep your favourite stories on your profile",
                style: TextStyle(
                    color: Theme.of(context).iconTheme.color,
                    fontWeight: FontWeight.w400,
                    fontSize: 13.5))
            : null,
        trailing: Icon(
          (isExpansionopen)
              ? Icons.expand_less_outlined
              : Icons.expand_more_outlined,
          color: Theme.of(context).iconTheme.color,
        ),
        children: [
          Container(
            height: 80,
            margin: EdgeInsets.only(left: 7),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return index != 0
                    ? Container(
                        width: 80,
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey.shade300,
                        ),
                      )
                    : Container(
                        width: 80,
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 58,
                              height: 58,
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).iconTheme.color,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Icon(Icons.add,
                                  color: Theme.of(context).iconTheme.color,
                                  size: 30),
                            ),
                            SizedBox(height: 2),
                            Text("New",
                                style: TextStyle(
                                  color: Theme.of(context).iconTheme.color,
                                  fontSize: 14,
                                ))
                          ],
                        ),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
