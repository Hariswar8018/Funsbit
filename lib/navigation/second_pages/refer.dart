import 'package:earning_app/global/widget.dart';
import 'package:flutter/material.dart';

class Refer extends StatelessWidget {
  const Refer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GlobalWidget.appbar(context, "Refer Program"),
        ],
      ),
    );
  }
}
