import 'package:earning_app/ads/ads_helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Level extends StatefulWidget {
  const Level({super.key});

  @override
  State<Level> createState() => _LevelState();
}

class _LevelState extends State<Level> {

  NativeAd? _nativeAd;
  bool _isNativeLoaded = false;

  void loadNativeAd() {

    _nativeAd = NativeAd(
      adUnitId: AdHelper.getNative(0),

      factoryId: 'listTile',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isNativeLoaded = true;
          });

          print('✅ Native Loaded');
        },

        onAdFailedToLoad: (ad, error) {

          ad.dispose();

          print('❌ Native Failed: $error');
        },
      ),
    );

    _nativeAd!.load();
  }
  Widget nativeAdWidget() {

    if (!_isNativeLoaded || _nativeAd == null) {
      return const SizedBox();
    }

    return Container(
      height: 300,
      padding: const EdgeInsets.all(8),

      child: AdWidget(ad: _nativeAd!),
    );
  }
  @override
  void initState() {
    super.initState();
    loadNativeAd();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }


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
                      Text("Your Level",style: TextStyle(        height: 1, fontSize: 13,color: Colors.grey.shade700),),
                      Text("and Leaderboard",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 15,height: 1),),
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
          SizedBox(height: 15,),
          Container(
            width: w-25,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15)
              ),
              gradient:LinearGradient(
                colors: [Color(0xff00CB6C),Color(0xff00B990)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Color(0xff34CF96),
                  child: Icon(Icons.leaderboard,size: 50,color: Colors.white,),
                ),
                SizedBox(height: 10,),
                Text("Level 1 : BASIC USER",style: TextStyle(
                  color: Colors.white,fontWeight: FontWeight.w800,fontSize: 20
                ),),
              ],
            ),
          ),
          Container(
            width: w-25,
            height: 80,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4), // shadow downwards
                  ),
                ],
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15)
              ),
              color: Colors.white
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Total Balance",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                      Text("1,440",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 24,height: 1),)
                    ],
                  ),
                  Spacer(),
                  Container(
                    width: w/2-35,height: 50,
                    decoration: BoxDecoration(
                      gradient:LinearGradient(
                          colors: [Color(0xff00CB6C),Color(0xff00B990)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight
                      ),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Withdraw",style: TextStyle(fontWeight: FontWeight.w800,color: Colors.white),),
                        SizedBox(width: 7,),
                        Icon(Icons.payments,size: 25,color: Colors.white,)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          nativeAdWidget(),

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
