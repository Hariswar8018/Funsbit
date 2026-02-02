

import 'package:earning_app/global/color.dart';
import 'package:earning_app/model/game.dart';
import 'package:flutter/material.dart';
import 'package:earning_app/card/home_game_card.dart';
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
                  Spacer(),
                  tabcircle(Icon(Icons.notifications_active_rounded)),
                  SizedBox(width: 6,),
                  tabcircle(Icon(Icons.add_reaction_sharp)),
                  SizedBox(width: 8,),
                ],
              ),
            ),
          ),
          SizedBox(height: 25,),
          Container(
            width: w-30,height: 140,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade300,
                width: 3.5
              ),
              borderRadius: BorderRadius.circular(25)
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  SizedBox(),
                  Spacer(),
                  Container(
                    width: w-60,
                    height: 40,
                    decoration: BoxDecoration(
                      color: GlobalColor.black,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Boost Mining",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),),
                        Text("⚡",style: TextStyle(color: Colors.yellowAccent,fontWeight: FontWeight.w800),),
                      ],
                    ),

                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              c(w, "Wallet", Color(0xffDBEAFF),Icon(Icons.account_balance_wallet,color: Colors.blue,)),
              c(w, "Refer", Color(0xffFFEFA9),Icon(Icons.card_giftcard,color: Colors.orange,)),
              c(w, "History", Color(0xffE1E7FF),Icon(Icons.refresh,color: Colors.lightBlue,)),
              c(w, "Watch Ads", Color(0xffD0FAE4),Icon(Icons.ondemand_video_rounded,color: Colors.green,)),
            ],
          ),
          SizedBox(height: 25,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Featured Games",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 18),),
                Text("See All",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: GlobalColor.green),),
              ],
            ),
          ),
          SizedBox(height: 15,),
          Container(
            height: w/2-10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CardGame(game: games[0]),
                CardGame(game: games[1]),

              ],
            )
          )
        ],
      ),
    );
  }
  Widget c(double w, String str, Color color, Widget icon)=>Column(
    children: [
      Container(
        width: w/6,
        height: w/6,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: color
        ),
        child: Center(
          child: icon,
        ),
      ),
      SizedBox(height: 6,),
      Text(str,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 12),)
    ],
  );
  Widget tabcircle(Widget c)=>CircleAvatar(
    radius: 23,
    backgroundColor: Colors.grey.shade200,
    child: Center(child: c,),
  );
}
