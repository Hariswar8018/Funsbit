

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width:w ,height: 90,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Image.asset("assets/logo_noback.png"),
                    ),
                  ),
                  SizedBox(width: 8,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome back,",style: TextStyle(fontSize: 13,color: Colors.grey.shade700),),
                      Text("Ayusman",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 15),)
                    ],
                  ),
                  SizedBox(width: 8,),
                ],
              ),
            ),
          ),
          SizedBox(height: 25,),
          Container(
            width: w-30,height: 150,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade300,
                width: 3
              ),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              children: [

              ],
            ),
          )
        ],
      ),
    );
  }
}
