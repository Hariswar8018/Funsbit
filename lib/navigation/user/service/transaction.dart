import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earning_app/login/bloc/bloc.dart';
import 'package:earning_app/model/transaction.dart';

class TransactionService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final String collection = "transactions";

   Stream<List<TransactionModel>> getTransactions(String id) {
    return _firestore
        .collection(collection)
        .where("userId",isEqualTo: id).orderBy("time",descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TransactionModel.fromJson(doc.data());
      }).toList();
    });
  }

  static Future<void> updateTransaction({
    required String id,
    required String name,
    required int coins,
    required String status,
    required bool debit,
    required String userId,
    String info = '',
    String upi = '',
    String bankinfc = '',
    String bankno = '',
  }) async {
    final data = TransactionModel(
      id: id,
      debit: debit,
      name: name,
      time: DateTime.now(),
      coins: coins,
      status: status,
      userId: userId,
      info: info,
      upiNumber: upi,
      bankIfsc: bankinfc,
      bankNumber: bankno,

    );

    await _firestore
        .collection(collection)
        .doc(id)
        .set(data.toJson(), SetOptions(merge: true));
  }
}
