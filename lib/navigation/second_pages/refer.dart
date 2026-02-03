import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earning_app/global/notify.dart';
import 'package:earning_app/global/widget.dart';
import 'package:earning_app/login/bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:share_plus/share_plus.dart';

class Refer extends StatefulWidget {
  const Refer({super.key});

  @override
  State<Refer> createState() => _ReferState();
}

class _ReferState extends State<Refer> {
  String generateAlphaNumericCode(String input) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    int hash = 0;

    // Create stable hash
    for (int i = 0; i < input.length; i++) {
      hash = ((hash << 5) - hash) + input.codeUnitAt(i);
      hash = hash & 0x7fffffff; // keep positive
    }

    // Build 7-character code
    StringBuffer code = StringBuffer();
    for (int i = 0; i < 12; i++) {
      final index = (hash + i * 31) % chars.length;
      code.write(chars[index]);
    }

    return code.toString();
  }

  @override
  void initState(){
    super.initState();
    update_refer();
  }
  update_refer() async {
    if(GlobalUser.user.myReferralCode.isEmpty){
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String s = generateAlphaNumericCode(uid);
      refer = s;
      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        "myReferralCode":s,
      });
    }else{
      refer = GlobalUser.user.myReferralCode;
    }
  }
  late String refer;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            GlobalWidget.appbar(context, "Refer Program"),
            SizedBox(height: 15,),
            Center(
              child: Container(
                width: w-30,
                height: w-90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [Color(0xff5145E5),Color(0xff7A3BEC)]
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 35,
                        child: Center(
                          child: Icon(Icons.people),
                        ),
                      ),
                      Text("Invite Friends and Earn",style: TextStyle(color: Colors.white,
                      fontWeight: FontWeight.w800,fontSize: 19),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("${GlobalUser.user.withdrawalBalance}",style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.w800,fontSize: 29,height: 1),),
                          Text(" Coins",style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.w800,fontSize: 14),),
                        ],
                      ),
                      SizedBox(height: 15,),
                      Container(
                        width:w-60,height: 90,
                        decoration: BoxDecoration(
                          color: Color(0xff815BEC),
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${GlobalUser.user.withdrawalBalance}",style: TextStyle(
                                    fontSize: 28,fontWeight: FontWeight.w900,color: Colors.white
                                ),),
                                Text("Earn Coins",style: TextStyle(
                                    fontSize: 15,fontWeight: FontWeight.w600,color: Colors.white
                                ),),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${GlobalUser.user.myReferral.length}",style: TextStyle(
                                    fontSize: 28,fontWeight: FontWeight.w900,color: Colors.white
                                ),),
                                Text("Referrals",style: TextStyle(
                                    fontSize: 15,fontWeight: FontWeight.w600,color: Colors.white
                                ),),
                              ],
                            ),
                          ],
                        )
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Center(
              child: Container(
                width: w-30,
                height: 140,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4), // shadow downwards
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Your Referral Code",style: TextStyle(color: Colors.black,
                          fontWeight: FontWeight.w800,fontSize: 19),),
                      SizedBox(height: 4,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                              width:w/2,height: 50,
                              decoration: BoxDecoration(
                                  color: Color(0xffF3F4F6),
                                  borderRadius: BorderRadius.circular(15)
                              ),
                            child: Center(
                              child: Text(refer,style: TextStyle(
                                fontWeight: FontWeight.w800
                              ),),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Clipboard.setData(ClipboardData(text: refer),);
                              Send.topic(context, "Success", "The refer code is Copied to Clipboard");
                            },
                            child: Container(
                              width:60,height: 50,
                              decoration: BoxDecoration(
                                  color: Color(0xffF3F4F6),
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: Center(
                                child: Icon(Icons.copy),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              SharePlus.instance.share(
                                  ShareParams(text: 'Download the FunsBit App from Playstore and Earn and Win GitCards. \n\nUse my referral code : $refer')
                              );
                            },
                            child: Container(
                              width:60,height: 50,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [Color(0xff5145E5),Color(0xff7A3BEC)]
                                  ),
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: Center(
                                child: Icon(Icons.share,color: Colors.white,),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4,),
                    ],
                  ),
                ),
              ),
            ),
            s(25),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 20,),
                Text("How to Earn ?",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20,height: 1),),
              ],
            ),
            s(8),
            icon("1", "Share your Code with Friend"),
            icon("2", "They Register in App, and Earn"),
            icon("3", "You will Earn 1K Coins on their Withdraw"),
            s(45),
          ],
        ),
      ),
    );
  }

  Widget icon(String str, String str2)=>ListTile(
    leading: CircleAvatar(
      backgroundColor: Colors.grey.shade200,
      child: Center(child: Text(str,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800),)),
    ),
    title: Text(str2,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700),),
  );

  Widget s(double w)=>SizedBox(height: w,);
}
