import 'package:earning_app/global/color.dart';
import 'package:earning_app/global/widget.dart';
import 'package:earning_app/login/auth.dart';
import 'package:earning_app/login/bloc/bloc.dart';
import 'package:earning_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40,),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 25.0),
                child: Container(
                  width: w-25,
                  height: 230,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4), // shadow downwards
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: (){
                            context.push("/update");
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              children: [
                                Container(
                                  height: 80,width: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors:[Colors.blue.shade800, Colors.lightBlueAccent.shade100]
                                    )
                                  ),
                                  child: Center(child: Text("${GlobalUser.user.name.isEmpty?"A":GlobalUser.user.name.substring(0,1)}",
                                    style: TextStyle(fontWeight: FontWeight.w900,fontSize: 35),)),
                                ),
                                SizedBox(width: 15,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Ayusman Samasi",
                                      style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20),),
                                    Text("${GlobalUser.user.email}",style: TextStyle(fontSize: 10),),
                                    SizedBox(height: 4,),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade50,
                                        borderRadius: BorderRadius.circular(15)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 4),
                                        child: Text("🏆 App Level ${GlobalUser.user.level}"
                                          ,style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w900, fontSize: 11),),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: w*(7/8),
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20)
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: (){
                                context.push("/wallet");
                              },
                              child: Column(
                                children: [
                                  Text("${GlobalUser.user.balance}",style: TextStyle(
                                    fontSize: 28,fontWeight: FontWeight.w900
                                  ),),
                                  Text("Coins",style: TextStyle(
                                      fontSize: 15,fontWeight: FontWeight.w600
                                  ),),
                                ],
                              ),
                            ),
                            Container(
                              width: 3,
                              height: 75,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                context.push("/refer");
                              },
                              child: Column(
                                children: [
                                  Text("${GlobalUser.user.walletBalance}",style: TextStyle(
                                      fontSize: 28,fontWeight: FontWeight.w900,
                                    color: Colors.orange
                                  ),),
                                  Text("Referral",style: TextStyle(
                                      fontSize: 15,fontWeight: FontWeight.w600
                                  ),),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            SizedBox(height: 10,),
            InkWell(
              onTap: (){
                context.push("/wallet");
              },
              child: Container(
                width: w-25,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.green.shade700,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.diamond_outlined, color: GlobalColor.green,size: 34,),
                          )),
                      SizedBox(width: 10,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("TOTAL COINS",style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,fontWeight: FontWeight.w600),),
                          Text("${GlobalUser.user.balance}",style: TextStyle(
                              fontSize: 20,
                              color: GlobalColor.green,fontWeight: FontWeight.w600),),
                        ],
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward,color: Colors.white,),
                      SizedBox(width: 10,)
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Quick Access",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 18),),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                c("history",w, "History", Color(0xffDBEAFF),Icon(Icons.history,color: Colors.blue,)),
                c("refer",w, "Referral", Color(0xffFFEFA9),Icon(Icons.share_rounded,color: Colors.orange,)),
                c("help",w, "Help", Color(0xffE1E7FF),Icon(Icons.support_agent,color: Colors.lightBlue,)),
                c("withdraw",w, "Withdraw", Color(0xffD0FAE4),Icon(Icons.payments,color: Colors.green,)),
              ],
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Settings",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 18),),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: w-25,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4), // shadow downwards
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  list(Icon(Icons.info, color:Colors.black,size: 25,), "About App", "about"),
                  list(Icon(Icons.contact_page, color:Colors.black,size: 25,), "Terms & Condition", "terms"),
                  list(Icon(Icons.login, color:Colors.red,size: 25,), "Log Out", "logout"),
                ],
              ),
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Social Accounts",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 18),),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: w-25,
              height: (220)*(2/3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4), // shadow downwards
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  list2("assets/Telegram_2019_Logo.svg.png", "Telegram Channel", "https://t.me/+6y6Lnkhk13E3NzE1"),
                  list2("assets/instagram.webp", "Instagram Channel", "https://www.instagram.com/funs.bit/"),
                ],
              ),
            ),
            SizedBox(height: 130,),
          ],
        ),
      ),
    );
  }
  Widget list2(String assets, String str, String navigate)=>ListTile(
    onTap: () async {
      final Uri _url = Uri.parse(navigate);
      if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
      }
    },
    leading: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(assets),
        )),
    title: Text(str,style: TextStyle(fontWeight: FontWeight.w700),),
    trailing: Icon(Icons.arrow_forward,color: Colors.grey,),
  );


  Widget list(Widget icon, String str, String navigate)=>ListTile(
    onTap: (){
      if(navigate=="logout"){
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0), // Rectangle (no rounded edges)
              ),
              title: const Text("Log out ?"),
              content: const Text("You sure to Log out from the App"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false), // Cancel
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await context.read<AuthService>().logout();
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith(
                          (states) => Colors.red,   // your color here
                    ),
                  ),
                  child: const Text("OK",style: TextStyle(color: Colors.white)),
                )
              ],
            );
          },
        );
        return ;
      }
      context.push("/${navigate}");
    },
    leading: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: icon,
        )),
    title: Text(str,style: TextStyle(fontWeight: FontWeight.w700),),
    trailing: Icon(Icons.arrow_forward,color: Colors.grey,),
  );

  Widget c(String launch, double w, String str, Color color, Widget icon)=>InkWell(
    onTap: (){
      context.push("/$launch");
    },
    child: Column(
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
    ),
  );
}
