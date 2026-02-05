import 'package:earning_app/card/transaction_card.dart';
import 'package:earning_app/global/widget.dart';
import 'package:earning_app/model/transaction.dart' show TransactionModel;
import 'package:earning_app/navigation/user/service/transaction.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  final String id;
  const History({super.key,required this.id});

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
              stream: service.getTransactions(widget.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  print(snapshot.error);
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
                    return TransactionCard(tx: tx,);
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
