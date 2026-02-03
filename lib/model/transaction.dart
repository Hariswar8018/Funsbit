import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final bool debit;
  final String name;
  final DateTime time;
  final int coins;
  final String status;
  final String userId;
  final String info;

  TransactionModel({
    required this.id,
    required this.debit,
    required this.name,
    required this.time,
    required this.coins,
    required this.status,
    required this.userId,
    required this.info,
  });

  // Convert to JSON (for Firestore)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'debit': debit,
      'name': name,
      'time': Timestamp.fromDate(time),
      'coins': coins,
      'status': status,
      'userId': userId,
      'info': info,
    };
  }

  // Convert from JSON (from Firestore)
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      debit: json['debit'] ?? false,
      name: json['name'] ?? '',
      time: (json['time'] as Timestamp).toDate(),
      coins: json['coins'] ?? 0,
      status: json['status'] ?? '',
      userId: json['userId'] ?? '',
      info: json['info'] ?? '',
    );
  }
}
