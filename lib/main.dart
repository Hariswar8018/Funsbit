import 'package:earning_app/global/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login/login.dart' show Login;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
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
      duration: const Duration(seconds: 3), // ⏱ 3 sec
    )..forward();
    _navigate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  Future<void> _navigate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String s = await prefs.getString('username')??"NA";
    if(s!="NA"){
      Future.delayed(const Duration(seconds: 3), () async {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            childBuilder: (context) => Login(
              str: s,
            ),
          ),
        );
      });
    }else{
      Future.delayed(const Duration(seconds: 3), () async {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.leftToRight,duration: Duration(milliseconds: 300),
            childBuilder: (context) => Login(
              str: s,
            ),
          ),
        );
      });
    }

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
            Text("Loading your Experience...",style: TextStyle(fontSize: 11,color: Colors.black),),
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
