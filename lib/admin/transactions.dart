


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earning_app/global/widget.dart';
import 'package:earning_app/model/transaction.dart';
import 'package:flutter/material.dart';

class Transactions extends StatefulWidget {
  final bool completed;
  const Transactions({super.key,required this.completed});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GlobalWidget.appbar(context, "All Transactions"),
          /*Flexible(
            child:StreamBuilder(
              stream: FirebaseFirestore.instance.collection("transactions").doc().snapshots(),
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
                    return TransactionCard(tx: tx,);
                  },
                );
              },
            ),
          )*/
        ],
      ),
    );
  }
}
