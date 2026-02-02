import 'package:earning_app/game/tetris/screen.dart';
import 'package:earning_app/global/color.dart';
import 'package:earning_app/model/game.dart';
import 'package:flutter/material.dart';

class CardGame extends StatelessWidget {
  final Games game;
  const CardGame({super.key,required this.game});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>TetrisScreen()));
      },
      child: Container(
        width: w/2-10,
        height: w/2-5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(image: AssetImage(game.image),fit: BoxFit.cover)
        ),
        child: Column(
          children: [
            Spacer(),
            Container(
              width: w/2-20,
              height: w/6,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.67),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)
                )
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(game.name,style: TextStyle(
                          color: Colors.white,fontWeight:
                            FontWeight.w900,fontSize: w/19
                        ),),
                        Row(
                          children: [
                            Icon(Icons.circle,color: Colors.green,size: 19,),
                            SizedBox(width: 4),
                            Text(game.totalplay.toString()+" Playing",style: TextStyle(color: Colors.white,
                            fontWeight: FontWeight.w700, fontSize: w/34),)
                          ],
                        )
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(Icons.play_arrow,color: Colors.white,),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
