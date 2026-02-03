import 'package:earning_app/global/widget.dart';
import 'package:flutter/material.dart';

class Announcment extends StatelessWidget {
  final bool my;
  const Announcment({super.key,required this.my});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GlobalWidget.appbar(context, my?"My Notifications":"Announcement"),
          Spacer(),
          Center(
            child:Image.network("https://cdn.pixabay.com/photo/2012/04/02/13/51/cardboard-box-24547_960_720.png",height: 100,),
          ),
          SizedBox(height: 7,),
          Center(
            child: Text("Empty Notifications",style: TextStyle(fontWeight: FontWeight.w800,
            fontSize: 24),),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
