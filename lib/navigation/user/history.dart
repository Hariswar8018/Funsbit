import 'package:earning_app/global/widget.dart';
import 'package:earning_app/model/transaction.dart' show TransactionModel;
import 'package:earning_app/navigation/user/service/transaction.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  final service = TransactionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GlobalWidget.appbar(context, "Your Transactions"),
          Flexible(
            child: StreamBuilder<List<TransactionModel>>(
              stream: service.getTransactions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                }

                // Empty
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("No Transactions Found"),
                  );
                }

                final transactions = snapshot.data!;

                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    return Card(
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
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
