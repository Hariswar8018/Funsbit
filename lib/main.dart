import 'package:earning_app/firebase_options.dart';
import 'package:earning_app/game/crossword/game.dart';

import 'package:earning_app/global/color.dart';
import 'package:earning_app/login/auth.dart';
import 'package:earning_app/login/bloc/bloc.dart';
import 'package:earning_app/navigation/naviagtion.dart';
import 'package:earning_app/navigation/second_pages/withdraw.dart';
import 'package:earning_app/navigation/user/history.dart';
import 'package:earning_app/router/app_router.dart' show AppRouter;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'login/login.dart' show Login;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await MobileAds.instance.initialize();

  final authService = AuthService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>.value(
          value: authService,
        ),
        BlocProvider<UserBloc>(
          create: (_) => UserBloc(),
        ),
      ],
      child: MyApp(authService: authService),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthService authService;

  const MyApp({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    /*return MaterialApp(
        title: 'FunsBit',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        ),
      home:CustomCrossword(),
    );*/
    return MaterialApp.router(
      title: 'FunsBit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      routerConfig: AppRouter(authService).router,
    );
  }
}


class AppStartupService extends ChangeNotifier {

  bool _isReady = false;

  bool get isReady => _isReady;

  AppStartupService() {
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(Duration(seconds: 3)); // Splash time
    _isReady = true;
    notifyListeners();
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>  with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      context.go('/login');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/background.jpg"),fit: BoxFit.cover)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10,),
            Spacer(),
            CircleAvatar(
              radius: 90,
              backgroundColor: Color(0xffC8FFE0),
              child: Image.asset("assets/logo_noback.png", width: 90,),
            ),
            Text("FUNS BIT",style: GoogleFonts.robotoSlab(
              textStyle: const TextStyle(color: Color(0xff16603B), letterSpacing: .5,fontSize: 27,fontWeight: FontWeight.w900),
            ),),
            Text("PLAY | MINE | EARN",style: GoogleFonts.robotoSlab(
              textStyle: TextStyle(color:GlobalColor.green, letterSpacing: .5,fontSize: 18,fontWeight: FontWeight.w700),
            ),),
            SizedBox(height: 22,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60,vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(seconds: 3),
                  builder: (context, value, child) {
                    return LinearProgressIndicator(
                      value: value,
                      minHeight: 12,
                      backgroundColor: Colors.grey.shade300,
                      color: GlobalColor.green,
                    );
                  },
                ),
              ),
            ),
            Text("Loading Login Screen...",style: TextStyle(fontSize: 11,color: Colors.black),),
            Spacer(),
            t("@ 2026 FunsBit "),
            t("Version 1.0.0 "),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
  Widget t(String str )=>Text(str,style: TextStyle(fontSize: 12,color: Colors.grey),);
}
