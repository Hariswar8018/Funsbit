

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GlobalWidget{

  static Widget appbar(BuildContext context,String str){
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

            const Icon(Icons.notifications, color: Colors.white),
          ],
        ),
      ),
    );
  }
}