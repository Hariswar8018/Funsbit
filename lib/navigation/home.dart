

import 'package:earning_app/ads/ads_helper.dart';
import 'package:earning_app/global/color.dart';
import 'package:earning_app/login/bloc/bloc.dart';
import 'package:earning_app/model/game.dart';
import 'package:flutter/material.dart';
import 'package:earning_app/card/home_game_card.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _bannerAd = BannerAd(
      adUnitId: AdHelper.getBanner(0),
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Ad failed: $error');
        },
      ),
    );

    _bannerAd.load();
  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
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
                        Text("Welcome back,",style: TextStyle(        height: 1, fontSize: 13,color: Colors.grey.shade700),),
                        Text("${GlobalUser.user.name.isEmpty?"New User":GlobalUser.user.name}",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 15,height: 1),),
                        SizedBox(height: 7,),
                      ],
                    ),
                    SizedBox(width: 8,),
                    Spacer(),
                    tabcircle(Icon(Icons.notifications_active_rounded),"notify"),
                    SizedBox(width: 6,),
                    tabcircle(Icon(Icons.add_reaction_sharp),"announce"),
                    SizedBox(width: 8,),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25,),
            Container(
              width: w-30,height: 160,
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
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text("Total Coins",style: TextStyle(
                                fontSize: 13,fontWeight: FontWeight.w600,
                              color: Colors.grey
                            ),),
                            Text("${GlobalUser.user.balance}",style: TextStyle(
                                fontSize: 20,fontWeight: FontWeight.w900
                            ),),
                          ],
                        ),
                        Container(
                          width: 3,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20)
                          ),
                        ),
                        Column(
                          children: [
                            Text("My Level",style: TextStyle(
                                fontSize: 13,fontWeight: FontWeight.w600,
                                color: Colors.grey
                            ),),
                            Text("Lvl. ${GlobalUser.user.level}",style: TextStyle(
                                fontSize: 20,fontWeight: FontWeight.w900
                            ),),
                          ],
                        ),
                      ],
                    ),
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
                          Text("Boost My Level",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),),
                          Text("⚡",style: TextStyle(color: Colors.yellowAccent,fontWeight: FontWeight.w800),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                c(w, "Wallet", Color(0xffDBEAFF),Icon(Icons.account_balance_wallet,color: Colors.blue,),"wallet"),
               c(w, "Refer", Color(0xffFFEFA9),Icon(Icons.card_giftcard,color: Colors.orange,),"refer"),
                c(w, "History", Color(0xffE1E7FF),Icon(Icons.refresh,color: Colors.lightBlue,),"history"),
                c(w, "Watch Ads", Color(0xffD0FAE4),Icon(Icons.ondemand_video_rounded,color: Colors.green,),"watch"),
              ],
            ),
            SizedBox(height: 20,),
            if (_isAdLoaded)
              Container(
                height: _bannerAd.size.height.toDouble(),
                width: _bannerAd.size.width.toDouble(),
                child: AdWidget(ad: _bannerAd),
              ),
            SizedBox(height: 14,),
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
            ),
            SizedBox(height: 15,),
            Container(
                height: w/2-10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CardGame(game: games[2]),
                    CardGame(game: games[3]),
                  ],
                )
            ),
            SizedBox(height: 140,)
          ],
        ),
      ),
    );
  }
  Widget c(double w, String str, Color color, Widget icon,String launch)=>InkWell(
    onTap: (){
      context.push('/$launch');
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
