import 'package:earning_app/global/color.dart';
import 'package:earning_app/login/bloc/bloc.dart';
import 'package:earning_app/navigation/games.dart';
import 'package:earning_app/navigation/mining.dart';
import 'package:earning_app/navigation/profile.dart';
import 'package:earning_app/navigation/user/update.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../navigation/home.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';


class MyNavigationPage extends StatefulWidget {
  const MyNavigationPage({Key? key}) : super(key: key);

  @override
  _MyNavigationPageState createState() => _MyNavigationPageState();
}

class _MyNavigationPageState extends State<MyNavigationPage> {
  final _pageController = PageController(initialPage: 0);

  final NotchBottomBarController _controller = NotchBottomBarController(index: 0);

  int maxCount = 5;

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> bottomBarPages = [
      Home(),
      Gamess(),
      Level(),
      Profile(),
      Home(),
    ];
    return GlobalUser.user.name.isEmpty?Update(user: GlobalUser.user,):Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        color: Colors.white,
        showLabel: true,
        textOverflow: TextOverflow.visible,
        maxLine: 1,
        shadowElevation: 5,
        kBottomRadius: 28.0,
        notchColor: Colors.black87,
        removeMargins: false,
        bottomBarWidth: 500,
        showShadow: true,
        durationInMilliSeconds: 300,
        itemLabelStyle: const TextStyle(fontSize: 10),
        elevation: 1,
        bottomBarItems:  [
          BottomBarItem(
            inActiveItem: Icon(
              Icons.home_filled,
              color: Colors.blueGrey,
            ),
            activeItem: Icon(
              Icons.home_filled,
              color: Colors.blueAccent,
            ),
            itemLabel: 'Home',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.gamepad, color: Colors.blueGrey),
            activeItem: Icon(
              Icons.games_rounded,
              color: Colors.blueAccent,
            ),
            itemLabel: 'Games',
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.money_off_csred_outlined,
              color: Colors.blueGrey,
            ),
            activeItem: Icon(
              Icons.settings,
              color: Colors.pink,
            ),
            itemLabel: 'Level',
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.person,
              color: Colors.blueGrey,
            ),
            activeItem: Icon(
              Icons.person,
              color: Colors.yellow,
            ),
            itemLabel: 'Page 4',
          ),
        ],
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
        kIconSize: 24.0,

      )
          : null,
    );
  }
}
