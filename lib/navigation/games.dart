import 'package:earning_app/card/home_game_card.dart';
import 'package:earning_app/model/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Gamess extends StatefulWidget {
  const Gamess({super.key});

  @override
  State<Gamess> createState() => _GamessState();
}

class _GamessState extends State<Gamess> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
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
                      Text("Play Games",style: TextStyle(        height: 1, fontSize: 13,color: Colors.grey.shade700),),
                      Text("and EARN Coins",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 15,height: 1),),
                      SizedBox(height: 7,),
                    ],
                  ),
                  SizedBox(width: 8,),
                  Spacer(),
                  tabcircle(Icon(Icons.notifications_active_rounded),"notify"),

                  SizedBox(width: 8,),
                ],
              ),
            ),
          ),
          SizedBox(height: 25,),
          Container(
              height: w/2-10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CardGame(game: games[0]),
                  CardGame(game: games[1]),
                ],
              )
          ),
          SizedBox(height: 10,),
          Container(
              height: w/2-10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CardGame(game: games[2]),
                  SizedBox(width: w/2-10,)
                ],
              )
          ),
        ],
      ),
    );
  }

  Widget tabcircle(Widget c,String launch)=>InkWell(
    onTap: (){
      context.push('/$launch');
    },
    child: CircleAvatar(
      radius: 23,
      backgroundColor: Colors.grey.shade200,
      child: Center(child: c,),
    ),
  );
}
