import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen>
    with SingleTickerProviderStateMixin {
  TabController controllertab;
  int _initialindex = 0;

  @override
  void initState() {
    super.initState();
    controllertab =
        TabController(length: 3, vsync: this, initialIndex: _initialindex);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TabBar(
        controller: controllertab,
        tabs: [
          Tab(
            icon: Image.asset(
              "assets/postnew.png",
              color: (_initialindex == 0)
                  ? Theme.of(context).tabBarTheme.labelColor
                  : Theme.of(context).tabBarTheme.unselectedLabelColor,
              height: 28,
            ),
          ),
          Tab(
            icon: SvgPicture.asset(
              "assets/reels.svg",
              color: (_initialindex == 1)
                  ? Theme.of(context).tabBarTheme.labelColor
                  : Theme.of(context).tabBarTheme.unselectedLabelColor,
              height: 25,
            ),
          ),
          Tab(
            icon: SvgPicture.asset(
              "assets/tag.svg",
              color: (_initialindex == 2)
                  ? Theme.of(context).tabBarTheme.labelColor
                  : Theme.of(context).tabBarTheme.unselectedLabelColor,
              height: 22,
              width: 22,
            ),
          ),
        ],
      ),
    );
  }
}
