import 'package:earning_app/ads/ads_helper.dart';
import 'package:earning_app/global/color.dart';
import 'package:earning_app/global/notify.dart';
import 'package:earning_app/global/widget.dart';
import 'package:earning_app/login/bloc/bloc.dart';
import 'package:earning_app/navigation/user/service/transaction.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WatchAds extends StatefulWidget {
  const WatchAds({super.key});

  @override
  State<WatchAds> createState() => _WatchAdsState();
}

class _WatchAdsState extends State<WatchAds> {
  RewardedAd? _rewardedAd;

  bool _isRewardedLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDailyLimit();
    _loadRewardedAd();
  }
  Future<void> _loadDailyLimit() async {
    final prefs = await SharedPreferences.getInstance();

    final today = DateTime.now().toIso8601String().split('T')[0];
    final savedDate = prefs.getString("watch_ads_date");
    final savedCount = prefs.getInt("watch_ads_count") ?? 0;

    if (savedDate != today) {
      // 🔄 New day → reset
      await prefs.setString("watch_ads_date", today);
      await prefs.setInt("watch_ads_count", 0);

      watchedToday = 0;
    } else {
      watchedToday = savedCount;
    }

    limitReached = watchedToday >= dailyLimit;

    setState(() {});
  }


  void _loadRewardedAd() {
    if (_isRewardedLoading || _rewardedAd != null) return;

    _isRewardedLoading = true;

    RewardedAd.load(
      adUnitId: AdHelper.getRewarded(0),
      request: const AdRequest(),

      rewardedAdLoadCallback: RewardedAdLoadCallback(

        onAdLoaded: (ad) {

          _rewardedAd = ad;
          _isRewardedLoading = false;

          print('✅ Rewarded Loaded');
        },

        onAdFailedToLoad: (error) {

          _isRewardedLoading = false;
          _rewardedAd = null;

          print('❌ Rewarded Failed: $error');

          Future.delayed(const Duration(seconds: 5), () {
            _loadRewardedAd();
          });
        },
      ),
    );
  }

  void showRewardedAd() {

    if (_rewardedAd == null) {

      print('⚠️ Rewarded not ready, reloading...');
      _loadRewardedAd();
      return;
    }

    _rewardedAd!.fullScreenContentCallback =
        FullScreenContentCallback(

          onAdShowedFullScreenContent: (ad) {
            print('🎬 Rewarded Started');
          },

          onAdDismissedFullScreenContent: (ad) {

            ad.dispose();
            _rewardedAd = null;

            print('🔄 Reloading Rewarded...');
            _loadRewardedAd();
          },

          onAdFailedToShowFullScreenContent: (ad, error) {

            ad.dispose();
            _rewardedAd = null;

            print('❌ Show Failed: $error');

            _loadRewardedAd();
          },
        );

    _rewardedAd!.show(

      onUserEarnedReward: (ad, reward) {

        print('🎁 Earned: ${reward.amount} ${reward.type}');

        giveUserReward(); // Your function
      },
    );
  }
  Future<void> giveUserReward() async {
    final prefs = await SharedPreferences.getInstance();

    if (watchedToday >= dailyLimit) {
      Send.topic(context, "Daily Limit reached","Daily limit reached. Try again tomorrow.");
      return;
    }

    setState(() {
      progress = true;
    });

    // ✅ Credit coins
    await TransactionService.updateTransaction(
      id: DateTime.now().toString(),
      name: 'Watch Video Ads',
      coins: 500,
      status: 'Credited',
      debit: false,
      userId: GlobalUser.user.id,
    );

    await Send.addcoins(context, 500);

    // ✅ Update daily count
    watchedToday++;
    await prefs.setInt("watch_ads_count", watchedToday);

    limitReached = watchedToday >= dailyLimit;

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        progress = false;
      });
    });
  }
  int dailyLimit=10,watchedToday = 0 ;
bool limitReached = false;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            GlobalWidget.appbar(context, "Watch & Earn Coins"),
            s(25),
            Text("Current Balance"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.diamond_outlined,color: Colors.orange,),
                progress ? CircularProgressIndicator():Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text("${GlobalUser.user.balance}",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 23),),
                ),
                Text("Coins",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 19),),
              ],
            ),
            s(25),
            Container(
              width: w-30,
              height: 370,
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 15),
                child: Column(
                  children: [
                    Spacer(),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Container(
                            width: 70,height: 70,
                            decoration: BoxDecoration(
                              gradient: GlobalColor.gradient,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Center(child: Icon(Icons.play_arrow),),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Watch Video Ads",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20,height: 1),),
                            Text("Get Free Coins instantly",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),)
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Container(
                      height: 80,
                      width: w-30,
                      decoration: BoxDecoration(
                        color: Colors.green.shade100.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 17.0),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("REWARD AMOUNT",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.green),),
                                Text("500 Coins",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20,height: 1,color: Colors.green),),
                              ],
                            ),
                            Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0,horizontal: 12),
                                child: Text("Instant",style: TextStyle(fontWeight: FontWeight.w700),),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Daily Limit",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 18),),
                          Text("$watchedToday / $dailyLimit",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: GlobalColor.black),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 4),
                      child: LinearProgressIndicator(
                        value: watchedToday / dailyLimit,
                        minHeight: 10,
                        backgroundColor: Colors.grey.shade300,
                        color: GlobalColor.green,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 18),),
                          Text("${dailyLimit - watchedToday} videos remaining",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 13,color: Colors.grey),),
                        ],
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: limitReached
                          ? () {
                        Send.topic(context, "Limit Reached","You reached today's limit (10/10)");
                      }
                          : showRewardedAd,
                      child: Container(
                        width: w-55,
                        height: 65,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: GlobalColor.gradient
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_arrow,color: Colors.white,size: 28,),
                            SizedBox(width: 6,),
                            Text("Watch Ad",style: TextStyle(color: Colors.white,fontSize: 19,fontWeight: FontWeight.w900),)
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            s(25),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 30,),
                Text("How to Earn ?",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20,height: 1),),
              ],
            ),
            s(8),
            icon("1", "Tap on Play Button"),
            icon("2", "Watch the Ad Completely ( 30 sec ) "),
            icon("3", "You will get your Reward"),
            s(45),
          ],
        ),
      ),
    );
  }
  bool progress = false;
  Widget icon(String str, String str2)=>ListTile(
    leading: CircleAvatar(
      backgroundColor: Colors.grey.shade200,
      child: Center(child: Text(str,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800),)),
    ),
    title: Text(str2,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700),),
  );
  Widget s(double w)=>SizedBox(height: w,);
}
