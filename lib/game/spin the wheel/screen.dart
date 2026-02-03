import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earning_app/ads/ads_helper.dart';
import 'package:earning_app/global/color.dart';
import 'package:earning_app/global/notify.dart';
import 'package:earning_app/global/widget.dart';
import 'package:earning_app/login/bloc/bloc.dart';
import 'package:earning_app/navigation/user/service/transaction.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:roulette/roulette.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SpinWheelPage extends StatefulWidget {
  const SpinWheelPage({super.key});

  @override
  State<SpinWheelPage> createState() => _SpinWheelPageState();
}

class _SpinWheelPageState extends State<SpinWheelPage> {
  late RouletteController controller;
  late RouletteGroup group;

  int? selectedIndex;

  final rewards = [
    "10 Coins",
    "20 Coins",
    "Try Again",
    "50 Coins",
    "100 Coins",
    "No Luck",
  ];

  @override
  void initState() {
    super.initState();
    loadDailySpins();

    group = RouletteGroup.uniform(
      rewards.length,
      colorBuilder: (index) {
        return index.isEven ? Colors.orange : Colors.blue;
      },
      textBuilder: (index) => rewards[index],
      textStyleBuilder: (index) {
        return const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        );
      },
    );

    controller = RouletteController();
  }
  final AudioPlayer _player = AudioPlayer();

  Future<void> useSpin() async {
    final prefs = await SharedPreferences.getInstance();

    spinsLeft--;

    await prefs.setInt("spins_left", spinsLeft);

    setState(() {});
  }
  bool canSpin() {
    return spinsLeft > 0;
  }
  void _showNoSpinDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("No Spins Left 😕"),
        content: const Text("Watch an ad to get 5 more spins!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showRewardedAd();
            },
            child: const Text("Watch Ad"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  int parseCoins(String reward) {
    final match = RegExp(r'\d+').firstMatch(reward);
    return match == null ? 0 : int.parse(match.group(0)!);
  }

void firespin(){
  FirebaseFirestore.instance
      .collection("users")
      .doc(GlobalUser.user.id)
      .update({
    "lastSpin": DateTime.now().toIso8601String().split('T')[0],
  });

}

Future<void> spinWheel() async {
    if (!canSpin()) {
      _showNoSpinDialog();
      return;
    }

    await _player.play(AssetSource("audio/spin.mp3")); // add in assets

    useSpin();
    firespin();

    final random = Random();
    final index = random.nextInt(rewards.length);
    final offset = random.nextDouble();

    await controller.rollTo(index, offset: offset);

    selectedIndex = index;
    final coins = parseCoins(rewards[index]);

    if (coins > 0) {
      giveUserReward(coins);
      setState(() {
        wincoin=coins;
      });
    }
    _showResultDialog(rewards[index]);
  }
  int wincoin = 0;
  Future<void> giveUserReward(int coinss) async {

    await TransactionService.updateTransaction(
        id: DateTime.now().toString(), name: 'Spin the Wheel Game Win', coins: coinss,
        status: 'Credited', debit: false, userId: GlobalUser.user.id
    );
    await Send.addcoins(context, coinss);
  }
  int spinsLeft = 10;
  Future<void> loadDailySpins() async {
    final prefs = await SharedPreferences.getInstance();

    final today = DateTime.now().toIso8601String().split('T')[0];
    final savedDate = prefs.getString("spin_date");

    if (savedDate != today) {
      // NEW DAY → reset
      spinsLeft = 10;
      await prefs.setString("spin_date", today);
      await prefs.setInt("spins_left", spinsLeft);
    } else {
      // SAME DAY → restore
      spinsLeft = prefs.getInt("spins_left") ?? 10;
    }

    setState(() {});
  }

  void _showResultDialog(String reward) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("🎉 You Won"),
        content: Text(
          reward,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }


  void redeemReward() {
    if (selectedIndex == null) return;

    final reward = rewards[selectedIndex!];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("You redeemed: $reward 🎉"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: GlobalColor.gameback,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GlobalWidget.appbar(context, "Spin the Wheel Game"),
          SizedBox(height: 40,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: w/3+40,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.touch_app_outlined),
                    Text("Spin left : ${spinsLeft}",
                    style: TextStyle(fontWeight: FontWeight.w900),),
                  ],
                ),
              ),
              Container(
                width: w/3+40,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.diamond_outlined),
                    Text(" Coins : ${wincoin}",
                      style: TextStyle(fontWeight: FontWeight.w900),),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 20,),
          Center(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                SizedBox(
                  width: 340,
                  height: 340,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Roulette(
                      group: group,
                      controller: controller,
                      style: const RouletteStyle(
                        dividerThickness: 4,
                        dividerColor: Colors.white,
                        centerStickerColor: Colors.yellowAccent,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -6,
                  child: Icon(Icons.location_pin,size: 33,color: Colors.black,)
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          InkWell(
            onTap:spinWheel,
            child: Container(
              width: MediaQuery.of(context).size.width-30,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: GlobalColor.gamebutton
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.rotate_90_degrees_cw),
                  Text("Spin the Wheel",style: TextStyle(fontWeight: FontWeight.w900),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _loadRewardedAd() {
    if (_isRewardedLoading || _rewardedAd != null) return;

    _isRewardedLoading = true;

    RewardedAd.load(
      adUnitId: AdHelper.getRewarded(3),
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
  RewardedAd? _rewardedAd;

  bool _isRewardedLoading=false;
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

        addExtraSpins();
      },
    );
  }
  Future<void> addExtraSpins() async {
    final prefs = await SharedPreferences.getInstance();

    spinsLeft += 1;

    await prefs.setInt("spins_left", spinsLeft);

    setState(() {});
  }

}
