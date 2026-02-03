

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GlobalWidget{
  static Widget follow(double w){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: w/2-15,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blue,width: 2.5)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                children: [
                  Image.asset("assets/Telegram_2019_Logo.svg.png",width: 25,),
                  SizedBox(width: 5,),
                  Text("Join Telegram ",style: TextStyle(fontWeight: FontWeight.w900),),
                  Spacer(),
                  Icon(Icons.open_in_new,size: 20,)
                ],
              ),
            ),
          ),
          Container(
            width: w/2-15,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.orange,width: 2.5)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                children: [
                  Image.asset("assets/instagram.webp",width: 25,),
                  SizedBox(width: 5,),
                  Text("Join Instagram",style: TextStyle(fontWeight: FontWeight.w900),),
                  Spacer(),
                  Icon(Icons.open_in_new,size: 20,)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  static Widget appbar(BuildContext context,String str,{bool show = false}){
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4), // shadow downwards
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            top: 40,
            left: 16,
            right: 16,
            bottom: 10
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap:(){
                context.pop();
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back, color: Colors.black),
                  )),
            ),
            Text(
              str,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            show?InkWell(
              onTap:(){
                context.push('/help');
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.support_agent, color: Colors.black),
                  )),
            ):SizedBox(width: 20,),
          ],
        ),
      ),
    );
  }
}