import 'package:flutter/material.dart';

class TreasureTile extends StatelessWidget {
  final int day;
  final bool opened;
  final bool isToday;

  const TreasureTile({
    super.key,
    required this.day,
    required this.opened,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    if (opened) {
      color = Colors.brown;
      icon = Icons.check_circle;
    } else if (isToday) {
      color = Colors.amber;
      icon = Icons.auto_awesome;
    } else {
      color = Colors.grey;
      icon = Icons.lock;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 70,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isToday ? Colors.amber : Colors.grey.shade400,
          width: isToday ? 2 : 1,
        ),
        boxShadow: isToday
            ? [
          BoxShadow(
            color: Colors.amber.withOpacity(0.6),
            blurRadius: 12,
          )
        ]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 6),
          Text(
            "Day $day",
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
