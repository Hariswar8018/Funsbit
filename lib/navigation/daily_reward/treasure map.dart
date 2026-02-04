import 'package:earning_app/navigation/daily_reward/treasure.dart';
import 'package:flutter/material.dart';

class DailyTreasureMap extends StatelessWidget {
  final int streak;
  final bool alreadyClaimed;

  const DailyTreasureMap({
    super.key,
    required this.streak,
    required this.alreadyClaimed,
  });

  @override
  Widget build(BuildContext context) {
    const totalDays = 7;

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: totalDays,
        itemBuilder: (context, index) {
          final day = index + 1;

          final opened = day <= streak;
          final isToday = day == streak + (alreadyClaimed ? 0 : 1);

          return TreasureTile(
            day: day,
            opened: opened,
            isToday: isToday,
          );
        },
      ),
    );
  }
}
