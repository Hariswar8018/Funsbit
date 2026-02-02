import 'package:earning_app/login/login.dart';
import 'package:earning_app/main.dart';
import 'package:earning_app/navigation/naviagtion.dart';
import 'package:earning_app/navigation/second_pages/about.dart';
import 'package:earning_app/navigation/second_pages/help.dart';
import 'package:earning_app/navigation/second_pages/history.dart';
import 'package:earning_app/navigation/second_pages/terms.dart';
import 'package:earning_app/navigation/second_pages/wallet.dart';
import 'package:earning_app/navigation/second_pages/withdraw.dart';
import 'package:earning_app/navigation/third_pages/watch_ads.dart';
import 'package:earning_app/navigation/user/announcment.dart';
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

      final isReady = startupService.isReady;
      final loggedIn = authService.isLoggedIn;

      final isSplash = state.matchedLocation == '/splash';
      final isLogin = state.matchedLocation == '/login';

      if (!isReady) {
        return '/splash';
      }

      // Ready but on splash → move on
      if (isReady && isSplash) {
        return loggedIn ? '/home' : '/login';
      }

      // Not logged in → login
      if (!loggedIn && !isLogin) {
        return '/login';
      }

      return null;
    },

    routes: [
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
        builder: (context, state) => History(),
      ),
      GoRoute(
        path: '/refer',
        builder: (context, state) => Refer(),
      ),
      GoRoute(
        path: '/announce',
        builder: (context, state) => Announcment(),
      ),
      GoRoute(
        path: '/notify',
        builder: (context, state) => nn.Notification(),
      ),







      //Second Pages
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
    ],
  );
}

