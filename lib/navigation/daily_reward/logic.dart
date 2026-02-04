
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earning_app/global/notify.dart';
import 'package:earning_app/login/bloc/bloc.dart';
import 'package:earning_app/model/usermodel.dart';
import 'package:earning_app/navigation/user/service/transaction.dart' show TransactionService;
import 'package:flutter/cupertino.dart';

class Daily{
  static int getDailyReward(int streak) {
    switch (streak) {
      case 1: return 400;
      case 2: return 800;
      case 3: return 1000;
      case 4: return 2000;
      case 5: return 3000;
      case 6: return 4000;
      case 7: return 5000;
      default: return 6000;
    }
  }
  static Future<void> giveUserReward(int coinss,BuildContext context) async {

    await TransactionService.updateTransaction(
        id: DateTime.now().toString(), name: 'Daily Rewards Claim', coins: coinss,
        status: 'Credited', debit: false, userId: GlobalUser.user.id
    );
    await Send.addcoins(context, coinss);
  }
  static Future<void> claimDailyReward(String userId,BuildContext context) async {
    final docRef =
    FirebaseFirestore.instance.collection('users').doc(userId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;

      final user = UserModel.fromMap(snapshot.data()!);

      final now = DateTime.now().toUtc();

      if (user.lastDailyClaim != null &&
          isSameDay(user.lastDailyClaim!, now)) {
        throw Exception("Already claimed today");
      }

      int newStreak = 1;
      if (user.lastDailyClaim != null &&
          isYesterday(user.lastDailyClaim!)) {
        newStreak = user.dailyStreak + 1;
      }

      final reward = getDailyReward(newStreak);
      giveUserReward(reward, context);

      transaction.update(docRef, {
        'dailyStreak': newStreak,
        'lastDailyClaim': FieldValue.serverTimestamp(),
      });
    });
  }
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().toUtc().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }


}