


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earning_app/card/transaction_card.dart';
import 'package:earning_app/global/widget.dart';
import 'package:earning_app/login/auth.dart';
import 'package:earning_app/model/transaction.dart' show TransactionModel;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NavigationAdmin extends StatefulWidget {
   NavigationAdmin({super.key});

  @override
  State<NavigationAdmin> createState() => _NavigationAdminState();
}

class _NavigationAdminState extends State<NavigationAdmin> {

  Future<int> countuser() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();
      return snapshot.docs.length;
    } catch (e) {
      debugPrint('Error counting transactions: $e');
      return 0;
    }
  }
  Future<int> countAllTransactions() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .get();

      return snapshot.docs.length;
    } catch (e) {
      debugPrint('Error counting transactions: $e');
      return 0;
    }
  }
  Future<int> countOverdueTransactions() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .where('status', isEqualTo: 'Waiting for Admin Approval')
          .get();

      return snapshot.docs.length;
    } catch (e) {
      debugPrint('Error counting overdue transactions: $e');
      return 0;
    }
  }
  @override
  void initState(){
    super.initState();
    count();
  }

  Future<void> count() async {
    penidng = await countOverdueTransactions();
    transactions = await countAllTransactions();
    totaluser = await countuser();
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Admin Panel",style: TextStyle(fontWeight: FontWeight.w900,color: Colors.white),),
        actions: [
          IconButton(onPressed: (){
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0), // Rectangle (no rounded edges)
                  ),
                  title: const Text("Log out ?"),
                  content: const Text("You sure to Log out from the App"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false), // Cancel
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await context.read<AuthService>().logout();
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith(
                              (states) => Colors.red,   // your color here
                        ),
                      ),
                      child: const Text("OK",style: TextStyle(color: Colors.white)),
                    )
                  ],
                );
              },
            );
          }, icon: Icon(Icons.logout,color: Colors.red,))
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              srr("All Users", w, Colors.orangeAccent.shade100, totaluser,"users"),
              srr("All Transactions", w, Colors.blue.shade100, transactions,"transactions"),
              sr("Pending", w, Colors.red.shade100, penidng, transactions,"alltransactions"),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: (){
              context.push("/send");
            },
            child: Container(
              height: 55,
              width: w-30,
              decoration: BoxDecoration(
                color: Colors.green.shade800,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Icon(Icons.notifications_active,color: Colors.white,),
                Text("Send Notifications to Users",style: TextStyle(fontWeight: FontWeight.w900,color: Colors.white),)
              ],),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Flexible(
            child:StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
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

 int penidng = 0, transactions = 0,totaluser=0;

  Widget sr(String str,double w,Color color,int i,int j,String launch){
    return InkWell(
      onTap: (){
        context.push("/$launch");
      },
      child: Container(
        width:w/3-10 ,
        height: 80,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(str,style: TextStyle(fontWeight: FontWeight.w800,color: Colors.black,fontSize: 10),),
            Text("$i / $j",style: TextStyle(fontWeight: FontWeight.w800,color: Colors.black,fontSize: 16),),
          ],
        ),
      ),
    );
  }

  Widget srr(String str,double w,Color color,int i,String launch){
    return InkWell(
      onTap: (){
        context.push("/$launch");
      },
      child: Container(
        width:w/3-10 ,
        height: 80,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(str,style: TextStyle(fontWeight: FontWeight.w800,color: Colors.black,fontSize: 10),),
            Text("$i",style: TextStyle(fontWeight: FontWeight.w800,color: Colors.black,fontSize: 16),),
          ],
        ),
      ),
    );
  }
}
