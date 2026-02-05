import 'package:earning_app/global/color.dart';
import 'package:earning_app/global/widget.dart';
import 'package:earning_app/login/bloc/bloc.dart';
import 'package:earning_app/model/transaction.dart';
import 'package:earning_app/navigation/user/service/transaction.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {

  final service = TransactionService();

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          GlobalWidget.appbar(context, "My Wallet"),
          SizedBox(height: 20,),
          InkWell(
            child: Container(
              width: w-25,
              height: 90,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.green.shade700,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.diamond_outlined, color: GlobalColor.green,size: 34,),
                        )),
                    SizedBox(width: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("TOTAL COINS",style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,fontWeight: FontWeight.w600),),
                        Text("${GlobalUser.user.balance}",style: TextStyle(
                            fontSize: 20,
                            color: GlobalColor.green,fontWeight: FontWeight.w600),),
                      ],
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward,color: Colors.white,),
                    SizedBox(width: 10,)
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Flexible(
            child: StreamBuilder<List<TransactionModel>>(
              stream: service.getTransactions(GlobalUser.user.id),
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
