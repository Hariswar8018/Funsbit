


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earning_app/global/widget.dart';
import 'package:flutter/material.dart';
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
      body: Column(
        children: [
          GlobalWidget.appbar(context, "Admin Panel"),
          SizedBox(height: 10,),
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
