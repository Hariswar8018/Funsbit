import 'package:earning_app/ads/ads_helper.dart';
import 'package:earning_app/game/spin%20the%20wheel/screen.dart';
import 'package:earning_app/game/tetris/screen.dart';
import 'package:earning_app/global/color.dart';
import 'package:earning_app/model/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardGame extends StatefulWidget {
  final Games game;
  const CardGame({super.key,required this.game});

  @override
  State<CardGame> createState() => _CardGameState();
}

class _CardGameState extends State<CardGame> {
  InterstitialAd? _interstitialAd;

  @override
  void initState(){
    super.initState();
    loadInterstitialAd();
  }
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.getInterstitial(0),

      request: const AdRequest(),

      adLoadCallback: InterstitialAdLoadCallback(

        onAdLoaded: (ad) {
          _interstitialAd = ad;
          print('Interstitial Loaded');
        },

        onAdFailedToLoad: (error) {
          print('Interstitial failed: $error');
        },
      ),
    );
  }
  void showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Interstitial not ready');
      navigate();
      return;
    }

    _interstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            _interstitialAd = null;
            navigate();
            loadInterstitialAd(); // preload next
          },

          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            _interstitialAd = null;
            navigate();
            loadInterstitialAd();
        }
        );

    _interstitialAd!.show();
  }

  void navigate(){
    context.push("/${widget.game.id}");
  }


  Future<void> now() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int counter = prefs.getInt('counter')??0;

    if(counter%3==0){
      showInterstitialAd();
      await prefs.setInt('counter', counter+1);
    }else{
      await prefs.setInt('counter', counter+1);
      navigate();
    }
  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () async {
        now();
      },
      child: Container(
        width: w/2-10,
        height: w/2-5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(image: AssetImage(widget.game.image),fit: BoxFit.cover)
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
                        Text(widget.game.name,style: TextStyle(
                          color: Colors.white,fontWeight:
                            FontWeight.w900,fontSize: w/19
                        ),),
                        Row(
                          children: [
                            Icon(Icons.circle,color: Colors.green,size: 19,),
                            SizedBox(width: 4),
                            Text(formatNumber(widget.game.totalplaying).toString()+" Playing",style: TextStyle(color: Colors.white,
                            fontWeight: FontWeight.w700, fontSize: w/34),)
                          ],
                        ),
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

  String formatNumber(int value) {
    if (value >= 1000000000) {
      return (value / 1000000000).toStringAsFixed(1) + 'B';
    } else if (value >= 1000000) {
      return (value / 1000000).toStringAsFixed(1) + 'M';
    } else if (value >= 1000) {
      return (value / 1000).toStringAsFixed(1) + 'K';
    } else {
      return value.toString();
    }
  }
}
