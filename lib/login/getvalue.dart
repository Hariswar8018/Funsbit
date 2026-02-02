import 'package:earning_app/global/color.dart';
import 'package:earning_app/global/notify.dart';
import 'package:earning_app/login/auth.dart';
import 'package:earning_app/login/bloc/bloc.dart';
import 'package:earning_app/login/bloc/state.dart';
import 'package:earning_app/login/bloc/userevent.dart';
import 'package:earning_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(LoadUserEvent());
  }

  void _go(String route) {
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.go(route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UserBloc, UserState>(
        listenWhen: (_, state) =>
        state is UserSuccess || state is UserFailure,
        listener: (context, state) async {
          if (state is UserFailure) {
            Send.topic(
              context,
              "Login Required for Security",
              state.error,
            );
            await context.read<AuthService>().logout();
            _go('/login');
          }
          if (state is UserSuccess) {
            _go('/home');
          }
        },
        builder: (context, state) {
          return MyHomePage(title: '');
        },
      ),
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
      duration: const Duration(seconds: 6), // ⏱ 3 sec
    )..forward();
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
