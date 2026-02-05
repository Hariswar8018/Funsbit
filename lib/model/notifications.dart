import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationFunction {
  final bool game;
  final String id;
  final String title;
  final String description;
  final bool notification;
  final String userId;
  final DateTime time;
  final int coins;

  NotificationFunction({
    required this.game,
    required this.id,
    required this.title,
    required this.description,
    required this.notification,
    required this.userId,
    required this.time,
    required this.coins,
  });

  /// 🔁 Convert to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'game': game,
      'id': id,
      'title': title,
      'description': description,
      'notification': notification,
      'userId': userId,
      'time': Timestamp.fromDate(time),
      'coins': coins,
    };
  }

  /// 🔁 Create model from Firestore Map
  factory NotificationFunction.fromMap(Map<String, dynamic> map) {
    return NotificationFunction(
      game: map['game'] ?? false,
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      notification: map['notification'] ?? false,
      userId: map['userId'] ?? '',
      time: map['time'] is Timestamp
          ? (map['time'] as Timestamp).toDate()
          : DateTime.now(),
      coins: int.tryParse(map['coins']?.toString() ?? '0') ?? 0,
    );
  }
}
