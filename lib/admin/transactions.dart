


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earning_app/card/transaction_card.dart';
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
          GlobalWidget.appbar(context, !widget.completed?"All Transactions":"Pending Payments"),
          Flexible(
            child:StreamBuilder<QuerySnapshot>(
              stream: !widget.completed ? FirebaseFirestore.instance
                  .collection("transactions").orderBy("time")
                  .snapshots():FirebaseFirestore.instance
                  .collection("transactions")
                  .where('status', isEqualTo: 'Waiting for Admin Approval')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No Transactions Found"));
                }

                final transactions = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final data = transactions[index].data() as Map<String, dynamic>;
                    final tx = TransactionModel.fromJson(data);
                    return TransactionCard(tx: tx);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
