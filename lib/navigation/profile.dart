import 'package:earning_app/global/color.dart';
import 'package:earning_app/login/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

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
                        Padding(
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
                                      child: Text("🏆 Miner Level ${GlobalUser.user.level}"
                                        ,style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w900, fontSize: 11),),
                                    ),
                                  )
                                ],
                              )
                            ],
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
                            Column(
                              children: [
                                Text("${GlobalUser.user.balance}",style: TextStyle(
                                  fontSize: 28,fontWeight: FontWeight.w900
                                ),),
                                Text("Referrals",style: TextStyle(
                                    fontSize: 15,fontWeight: FontWeight.w600
                                ),),
                              ],
                            ),
                            Container(
                              width: 3,
                              height: 75,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                            Column(
                              children: [
                                Text("${GlobalUser.user.walletBalance}",style: TextStyle(
                                    fontSize: 28,fontWeight: FontWeight.w900,
                                  color: Colors.orange
                                ),),
                                Text("Tokens",style: TextStyle(
                                    fontSize: 15,fontWeight: FontWeight.w600
                                ),),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
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
                            color: Colors.green.shade900,
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
                InkWell(
                    onTap: (){
                      context.push('/wallet');
                    },
                    child: c(w, "Wallet", Color(0xffDBEAFF),Icon(Icons.account_balance_wallet,color: Colors.blue,))),
                InkWell(
                    onTap: (){
                      context.push('/refer');
                    },
                    child: c(w, "Refer", Color(0xffFFEFA9),Icon(Icons.card_giftcard,color: Colors.orange,))),
                c(w, "History", Color(0xffE1E7FF),Icon(Icons.refresh,color: Colors.lightBlue,)),
                c(w, "Watch Ads", Color(0xffD0FAE4),Icon(Icons.ondemand_video_rounded,color: Colors.green,)),
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
                  list(Icon(Icons.info, color:Colors.black,size: 25,), "About App", "wallet"),
                  list(Icon(Icons.contact_page, color:Colors.black,size: 25,), "Terms & Condition", "wallet"),
                  list(Icon(Icons.login, color:Colors.red,size: 25,), "Log Out", "wallet"),
                ],
              ),
            ),
            SizedBox(height: 130,),
          ],
        ),
      ),
    );
  }
  Widget list(Widget icon, String str, String navigate)=>ListTile(
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
}
