import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earning_app/login/bloc/bloc.dart';
import 'package:earning_app/login/bloc/userevent.dart' show RefreshUserEvent;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class Send{

  static void topic(BuildContext context,String str1,String str,{bool b = false}) async{
    await Flushbar(
      titleColor: Colors.white,
      message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.linear,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor:b?Colors.green: Colors.red,
      boxShadows: [BoxShadow(color: Colors.blue, offset: Offset(0.0, 2.0), blurRadius: 3.0)],
      backgroundGradient: LinearGradient(colors: [Colors.red, Colors.redAccent.shade400]),
      isDismissible: false,
      duration: Duration(seconds: 3),
      icon: b?Icon(
        Icons.verified_rounded,color: Colors.white,
      ):Icon(
        Icons.warning,
        color: Colors.white,
      ),
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.white,
      titleText:  Text(
        str1,
        style: TextStyle(fontSize: 18.0, color: Colors.white,fontWeight: FontWeight.w700, fontFamily: "ShadowsIntoLightTwo"),
      ),
      messageText: Text(
        str,
        style: TextStyle(fontSize: 14.0, color: Colors.white, fontFamily: "ShadowsIntoLightTwo"),
      ),
    ).show(context);
  }


  static Future<String> addcoins(BuildContext context, int coins) async {
    try {
      await FirebaseFirestore.instance.collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid).update({
        "balance":FieldValue.increment(coins),
      });
      context.read<UserBloc>().add(RefreshUserEvent());
      Send.topic(context, "Success","Your Coins Updated",b: true);
      return "Success";
    }catch(e){
      Send.topic(context, "Error","${e}");
      return "${e}";
    }
  }
}