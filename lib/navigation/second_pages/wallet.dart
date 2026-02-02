import 'package:earning_app/global/widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GlobalWidget.appbar(context, "My Wallet"),
        ],
      ),
    );
  }
}
