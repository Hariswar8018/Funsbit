import 'package:earning_app/admin/navigation.dart';
import 'package:earning_app/global/color.dart';
import 'package:earning_app/login/bloc/bloc.dart';
import 'package:earning_app/navigation/games.dart';
import 'package:earning_app/navigation/mining.dart';
import 'package:earning_app/navigation/profile.dart';
import 'package:earning_app/navigation/user/notifications/save_token.dart';
import 'package:earning_app/navigation/user/notifications/show_notification.dart';
import 'package:earning_app/navigation/user/update.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../navigation/home.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';

bool admin =
    GlobalUser.user.email == "satyabratam433@gmail.com" ||
        GlobalUser.user.email == "samasasahi14@gmail.com";

class MyNavigationPage extends StatefulWidget {
  const MyNavigationPage({Key? key}) : super(key: key);

  @override
  _MyNavigationPageState createState() => _MyNavigationPageState();
}

class _MyNavigationPageState extends State<MyNavigationPage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  void fg() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(settings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 Foreground message received');
      print(message.data);
      print(message.notification?.title);

      if (message.notification != null) {
        _showNotification(message);
      }
    });
  }

  Future<void> setupNotifications() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Used for important notifications',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'high_importance_channel', // MUST MATCH channel
      'High Importance Notifications',
      channelDescription: 'Used for important notifications',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails details =
    NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.notification!.title,
      message.notification!.body,
      details,
    );
  }
  Future<void> createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // MUST match below
      'High Importance Notifications',
      description: 'Used for important notifications',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  @override
  void initState() {

    super.initState();
    start();
  }
  void start()async{
    await setupNotifications();
    await createNotificationChannel();
    requestNotificationPermission();
    fgi();
    await send();
  }
  Future<void> send() async {
    SaveToken.registerUserFCMToken(GlobalUser.user.id);

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    NowSendMeMessage.listenForegroundMessages();
  }
  void fgi(){
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 Foreground message');
      print(message.notification?.title);

      if (message.notification != null) {
        flutterLocalNotificationsPlugin.show(
          DateTime.now().millisecondsSinceEpoch ~/ 1000,
          message.notification!.title,
          message.notification!.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });

  }


  void requestNotificationPermission() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ User granted permission');
      fg();
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print('❌ User denied permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
      print('❓ Permission not determined');
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  }
  final _pageController = PageController(initialPage: 0);

  final NotchBottomBarController _controller = NotchBottomBarController(index: 0);
  void openFallbackScreen(int index) {
    _controller.index=index;
    _pageController.jumpToPage(index);
    setState(() {

    });
  }
  int maxCount = 5;

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> bottomBarPages = [
      Home(onFallback: openFallbackScreen),
      Gamess(),
      Level(),
      Profile(),
    ];
    return admin?NavigationAdmin():GlobalUser.user.name.isEmpty?Update(user: GlobalUser.user,isback: false,):WillPopScope(
        onWillPop: () async {
          final shouldExit = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                title: const Text("Close the App ?"),
                content: const Text("You sure to Close the App"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.red),
                    ),
                    onPressed: () async {
                      Navigator.pop(context, true);
                    },
                    child: const Text(
                      "OK",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          );
          return shouldExit ?? false;
      },
      child: Scaffold(
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
                Icons.leaderboard,
                color: Colors.blueGrey,
              ),
              activeItem: Icon(
                Icons.leaderboard,
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
              itemLabel: 'Profile',
            ),
          ],
          onTap: (index) {
            _pageController.jumpToPage(index);
          },
          kIconSize: 24.0,

        )
            : null,
      ),
    );
  }
}
