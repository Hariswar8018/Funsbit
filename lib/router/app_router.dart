import 'package:earning_app/admin/navigation.dart';
import 'package:earning_app/admin/send_notification.dart';
import 'package:earning_app/admin/transactions.dart';
import 'package:earning_app/admin/user.dart';
import 'package:earning_app/game/crossword/game.dart';
import 'package:earning_app/game/quiz/quiz.dart';
import 'package:earning_app/game/spin%20the%20wheel/screen.dart';
import 'package:earning_app/game/tetris/screen.dart';
import 'package:earning_app/login/bloc/bloc.dart';
import 'package:earning_app/login/getvalue.dart' show CreateUserScreen;
import 'package:earning_app/login/login.dart';
import 'package:earning_app/main.dart';
import 'package:earning_app/navigation/daily_reward/screen.dart';
import 'package:earning_app/navigation/naviagtion.dart';
import 'package:earning_app/navigation/second_pages/about.dart';
import 'package:earning_app/navigation/second_pages/help.dart';
import 'package:earning_app/navigation/second_pages/terms.dart';
import 'package:earning_app/navigation/second_pages/wallet.dart';
import 'package:earning_app/navigation/second_pages/withdraw.dart';
import 'package:earning_app/navigation/third_pages/watch_ads.dart';
import 'package:earning_app/navigation/user/announcment.dart';
import 'package:earning_app/navigation/user/history.dart';
import 'package:earning_app/navigation/user/update.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:earning_app/login/auth.dart';
import 'package:earning_app/navigation/second_pages/refer.dart';
import 'package:earning_app/navigation/user/notification.dart' as nn;
class AppRouter {
  final AuthService authService;
  final AppStartupService startupService = AppStartupService();

  AppRouter(this.authService);

  late final GoRouter router = GoRouter(
    refreshListenable: Listenable.merge([
      authService,
      startupService,
    ]),

    initialLocation: '/splash',

    redirect: (context, state) {
      final loggedIn = authService.isLoggedIn;

      final isSplash = state.matchedLocation == '/splash';
      final isLogin = state.matchedLocation == '/login';
      final isCreate = state.matchedLocation == '/create';

      if (!loggedIn) {
        if (isSplash || isLogin) return null;
        return '/splash';
      }

      if (loggedIn && (isSplash || isLogin)) {
        return '/create';
      }

      return null;
    },


    routes: [
      GoRoute(
        path: '/create',
        builder: (context, state) => CreateUserScreen(),
      ),


      GoRoute(
        path: '/splash',
        builder: (context, state) => MyHomePage(title: '',),
      ),

      GoRoute(
        path: '/login',
        builder: (context, state) => Login(str: ""),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => MyNavigationPage(),
      ),
      GoRoute(
        path: '/watch',
        builder: (context, state) => WatchAds(),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => History(id: GlobalUser.user.id,),
      ),
      GoRoute(
        path: '/refer',
        builder: (context, state) => Refer(),
      ),
      GoRoute(
        path: '/announce',
        builder: (context, state) => Announcment(my: false,),
      ),
      GoRoute(
        path: '/notify',
        builder: (context, state) => Announcment(my: true),
      ),
      GoRoute(
        path: '/update',
        builder: (context, state) => Update(user: GlobalUser.user,isback: true,),
      ),


      GoRoute(
        path: '/users',
        builder: (context, state) => Users(),
      ),
      GoRoute(
        path: '/transactions',
        builder: (context, state) => Transactions(completed: false),
      ),
      GoRoute(
        path: '/alltransactions',
        builder: (context, state) => Transactions(completed: true),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => NavigationAdmin(),
      ),




      //Second Pages
      GoRoute(
        path: '/dailywin',
        builder: (context, state) => DailyWinScreen(),
      ),
      GoRoute(
        path: '/wallet',
        builder: (context, state) => Wallet(),
      ),
      GoRoute(
        path: '/help',
        builder: (context, state) => Help(),
      ),
      GoRoute(
        path: '/withdraw',
        builder: (context, state) => Withdraw(),
      ),
      GoRoute(
        path: '/terms',
        builder: (context, state) => Terms(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => About(),
      ),


      //Game
      GoRoute(
        path: '/spin',
        builder: (context, state) => SpinWheelPage(),
      ),
      GoRoute(
        path: '/quiz',
        builder: (context, state) => QuizScreen(),
      ),
      GoRoute(
        path: '/crossword',
        builder: (context, state) =>CustomCrossword(),
      ),
      GoRoute(
        path: '/tetris',
        builder: (context, state) => TetrisScreen(),
      ),
      GoRoute(
        path: '/send',
        builder: (context, state) => NotifyAllUsersPage(),
      ),
    ],
  );
}

