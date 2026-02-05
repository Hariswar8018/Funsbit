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

  // NEW FIELDS
  final String upiNumber;
  final String bankNumber;
  final String bankIfsc;

  TransactionModel({
    required this.id,
    required this.debit,
    required this.name,
    required this.time,
    required this.coins,
    required this.status,
    required this.userId,
    required this.info,

    // NEW
    this.upiNumber = '',
    this.bankNumber = '',
    this.bankIfsc = '',
  });

  /// Convert to JSON (Firestore)
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

      // NEW
      'upiNumber': upiNumber,
      'bankNumber': bankNumber,
      'bankIfsc': bankIfsc,
    };
  }

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
      upiNumber: json['upiNumber'] ?? '',
      bankNumber: json['bankNumber'] ?? '',
      bankIfsc: json['bankIfsc'] ?? '',
    );
  }
}
