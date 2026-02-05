import 'package:earning_app/model/transaction.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
   TransactionCard({super.key,required this.tx});
  TransactionModel tx;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: ListTile(
        leading: Icon(
          tx.debit ? Icons.arrow_upward : Icons.arrow_downward,
          color: tx.debit ? Colors.red : Colors.green,
        ),
        title: Text(tx.name),
        subtitle: Text(
          "Coins: ${tx.coins}\nStatus: ${tx.status}",
        ),
        trailing: Text(
          tx.debit ? "-${tx.coins}" : "+${tx.coins}",
          style: TextStyle(
            color: tx.debit ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
