import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramclone/models/user.dart';
import 'package:instagramclone/providers/user_provider.dart';

import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/gloabal_variable.dart';
import 'package:provider/provider.dart';

class MobileScreen extends StatefulWidget {
  @override
  _MobileScreenState createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  int _page = 0;
  PageController pageController; // for tabs animation

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: PageView(
        children: homeScreenItems,
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: (_page == 2)
            ? mobileBackgroundColor
            : Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: (_page == 0)
                ? Icon(
                    Icons.home,
                    color: (_page == 2)
                        ? primaryColor
                        : Theme.of(context)
                            .bottomNavigationBarTheme
                            .selectedIconTheme
                            .color,
                  )
                : Icon(
                    Icons.home_outlined,
                    color: (_page == 2)
                        ? primaryColor
                        : Theme.of(context)
                            .bottomNavigationBarTheme
                            .selectedIconTheme
                            .color,
                  ),
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
              icon: (_page == 1)
                  ? Icon(
                      Icons.search,
                      color: (_page == 2)
                          ? primaryColor
                          : Theme.of(context)
                              .bottomNavigationBarTheme
                              .selectedIconTheme
                              .color,
                    )
                  : Icon(
                      Icons.search_outlined,
                      color: (_page == 2)
                          ? primaryColor
                          : Theme.of(context)
                              .bottomNavigationBarTheme
                              .selectedIconTheme
                              .color,
                    ),
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: (_page == 2)
                  ? SvgPicture.asset(
                      'assets/reelsfilled.svg',
                      height: 27,
                      width: 22,
                      fit: BoxFit.fill,
                      //width: 30,
                      color: (_page == 2)
                          ? primaryColor
                          : Theme.of(context).iconTheme.color,
                    )
                  : SvgPicture.asset(
                      'assets/reelsnew.svg',
                      height: 24,
                      width: 20,
                      //fit: BoxFit.fill,
                      //width: 30,
                      color: (_page == 2)
                          ? primaryColor
                          : Theme.of(context).iconTheme.color,
                    ),
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
            icon: (_page == 3)
                ? Icon(
                    Icons.favorite,
                    color: (_page == 2)
                        ? primaryColor
                        : Theme.of(context)
                            .bottomNavigationBarTheme
                            .selectedIconTheme
                            .color,
                  )
                : Icon(
                    Icons.favorite_outline,
                    color: (_page == 2)
                        ? primaryColor
                        : Theme.of(context)
                            .bottomNavigationBarTheme
                            .selectedIconTheme
                            .color,
                  ),
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: (_page == 4)
                ? Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: (_page == 2)
                                ? primaryColor
                                : Theme.of(context)
                                    .bottomNavigationBarTheme
                                    .selectedIconTheme
                                    .color,
                            width: 1.5)),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundImage: NetworkImage(user.photourl),
                    ),
                  )
                : CircleAvatar(
                    radius: 14,
                    backgroundImage: NetworkImage(user.photourl),
                  ),
            backgroundColor: primaryColor,
          ),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}
