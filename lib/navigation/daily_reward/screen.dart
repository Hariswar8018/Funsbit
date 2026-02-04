import 'package:earning_app/global/color.dart';
import 'package:earning_app/global/notify.dart';
import 'package:earning_app/global/widget.dart';
import 'package:earning_app/login/bloc/bloc.dart';
import 'package:earning_app/login/bloc/userevent.dart';
import 'package:earning_app/model/usermodel.dart';
import 'package:earning_app/navigation/daily_reward/logic.dart';
import 'package:earning_app/navigation/daily_reward/treasure%20map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailyWinScreen extends StatelessWidget {

  const DailyWinScreen({super.key,  });
  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().toUtc().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = GlobalUser.user;
    final now = DateTime.now().toUtc();
    final alreadyClaimed = user.lastDailyClaim != null &&
        isSameDay(user.lastDailyClaim!, now);
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: GlobalColor.gameback,
      body: Column(
        children: [
          GlobalWidget.appbar(context, "My Daily Reward"),
          Spacer(),
          Text("Join Daily to Earn Rewards",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 24),),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Text(textAlign: TextAlign.center,"Join Daily with us to get FREE Rewards Daily in our App ! ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 18),),
          ),
          SizedBox(height: 30,),
          DailyTreasureMap(
            streak: user.dailyStreak,
            alreadyClaimed: alreadyClaimed,
          ),
          const SizedBox(height: 50),
          Text(
            "Day ${user.dailyStreak + (alreadyClaimed ? 0 : 1)} Reward",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.white),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: alreadyClaimed
                ? (){
              Send.topic(context, "You Already Claimed","You already Claimed. Come back Tomorrow to win daily reward");
            } : () async {
              try {
                final reward = await Daily.claimDailyReward(user.id,context);
                context.read<UserBloc>().add(RefreshUserEvent());
                showWinDialog(context, Daily.getDailyReward(user.dailyStreak + 1));
              } catch (e) {
                Send.topic(context, "Error !","${e.toString()}");
              }
            },
            child: Container(
              width: w-30,
              height: 65,
              decoration: BoxDecoration(
                color: alreadyClaimed?Colors.grey.shade100: Colors.white,
                borderRadius: BorderRadius.circular(15)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/gold.png",height: 30),
                    SizedBox(width: 7,),
                    Text(
                      "${Daily.getDailyReward(user.dailyStreak + 1)} Coins",
                      style: TextStyle(fontSize: 30, color: alreadyClaimed?Colors.grey.shade900:Colors.amber,fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
          Spacer(),
        ],
      ),
    );
  }
  void showWinDialog(BuildContext context, int coins) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: GlobalColor.gameback,
          title: const Text(
            "🎉 Congratulations!",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/gold.png", height: 60),
              const SizedBox(height: 15),
              Text(
                "You won $coins coins!",
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // go back screen
              },
              child: const Text(
                "Awesome!",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

}
