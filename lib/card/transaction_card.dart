import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earning_app/admin/user.dart';
import 'package:earning_app/model/transaction.dart';
import 'package:earning_app/model/usermodel.dart';
import 'package:earning_app/navigation/naviagtion.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
   TransactionCard({super.key,required this.tx});
  TransactionModel tx;
   Future<void> updateTransactionStatus({
     required String transactionId,
     required String status,
   }) async {
     await FirebaseFirestore.instance
         .collection('transactions')
         .doc(transactionId)
         .update({
       'status': status,
     });
   }

   @override
  Widget build(BuildContext context) {
     double w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (){
        if(admin){
            showStatusBottomSheet(context, (selectedStatus) {
              updateTransactionStatus(
                transactionId: tx.id, // 🔥 Firestore doc id
                status: selectedStatus,
              );
            });
        }
      },
      child:tx.debit?Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4), // shadow downwards
            ),
          ],
        ),      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tx.name,style: TextStyle(fontWeight: FontWeight.w900,fontSize: 16),),
              SizedBox(height: 9,),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        tx.debit ? Icons.payments : Icons.card_giftcard_rounded,
                        color: tx.debit ? Colors.red : Colors.green,
                        size: 30,
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text(
                    "${formatTransactionTime(tx.time)}\n${tx.status}",
                    style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  Text(
                    " - ${(tx.coins/2000)} INR",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,fontSize: 13,color: Colors.red
                    ),
                  ),
                ],
              ),
              SizedBox(height: 9,),
              Row(
                children: [
                  Text(
                    tx.upiNumber.isEmpty?"Bank : ${tx.bankNumber}   IFSC : ${tx.bankIfsc}":"Upi Details : ${tx.upiNumber}",
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(height: 9,),
              InkWell(
                onTap: (){
                  openUserDetails(context, tx.userId);
                },
                child: Container(
                  width: w-20,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Check User Info"),
                        Icon(Icons.arrow_forward)
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 9,)
            ],
          ),
        ),
      ): Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4), // shadow downwards
            ),
          ],
        ),      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              tx.debit ? Icons.payments : Icons.card_giftcard_rounded,
              color: tx.debit ? Colors.red : Colors.green,
              size: 30,
            ),
          ),
        ),
        title: Text(tx.name,style: TextStyle(fontWeight: FontWeight.w900,fontSize: 16),),
        subtitle: Text(
          "${formatTransactionTime(tx.time)}\n${tx.status}",
          style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(tx.debit?"-":"+",style: TextStyle(fontSize: 20,
                    color: tx.debit ? Colors.red : Colors.green,),),
                  Text(
                    " ${tx.coins}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,fontSize: 18
                    ),
                  ),
                ],
              ),
            ),
            Image.asset("assets/gold.png",width: 20),
          ],
        ),
      ),
    ),
    );
   }
   Future<void> openUserDetails(
       BuildContext context,
       String userId,
       ) async {
     try {
       final doc = await FirebaseFirestore.instance
           .collection('users')
           .doc(userId)
           .get();

       if (!doc.exists) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('User not found')),
         );
         return;
       }

       final user = UserModel.fromMap(
         doc.data() as Map<String, dynamic>,
       );

       Navigator.push(
         context,
         MaterialPageRoute(
           builder: (_) => UserDetailPage(user: user),
         ),
       );
     } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Error: $e')),
       );
     }
   }


   String formatTransactionTime(DateTime time) {
      return DateFormat('d MMM, h:mm a').format(time);
    }


    void showStatusBottomSheet(
       BuildContext context,
       Function(String) onStatusSelected,
       ) {
     showModalBottomSheet(
       context: context,
       shape: const RoundedRectangleBorder(
         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
       ),
       builder: (context) {
         final List<String> statuses = [
           'Confirmed',
           'Payed',
           'Rejected : UPI/Bank doesn\'t exist',
           'Rejected : Fraud Detected',
           'Rejected',
           'Rejected : Other Reasons',
         ];

         return Padding(
           padding: const EdgeInsets.all(16),
           child: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               const Text(
                 'Select Transaction Status',
                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
               ),
               const SizedBox(height: 12),

               ListView.separated(
                 shrinkWrap: true,
                 itemCount: statuses.length,
                 separatorBuilder: (_, __) => const Divider(),
                 itemBuilder: (context, index) {
                   final status = statuses[index];
                   return ListTile(
                     leading: getStatusIcon(returnInt(status)),
                     title: Text(status),
                     onTap: () {
                       Navigator.pop(context);
                       onStatusSelected(status);
                     },
                   );
                 },
               ),
             ],
           ),
         );
       },
     );
   }
   int returnInt(String status) {
     switch (status) {
       case 'Confirmed':
         return 0;
       case 'Payed':
         return 1;
       case 'Rejected : UPI/Bank doesn\'t exist':
         return 2;
       case 'Rejected : Fraud Detected':
         return 3;
       case 'Rejected':
         return 4;
       case 'Rejected : Other Reasons':
         return 5;
       default:
         return -1;
     }
   }
   Icon getStatusIcon(int status) {
     switch (status) {
       case 0: // Confirmed
         return const Icon(Icons.verified, color: Colors.blue);

       case 1: // Payed
         return const Icon(Icons.payments, color: Colors.green);

       case 2: // UPI/Bank not exist
         return const Icon(Icons.account_balance, color: Colors.orange);

       case 3: // Fraud
         return const Icon(Icons.warning_amber, color: Colors.red);

       case 4: // Rejected
         return const Icon(Icons.cancel, color: Colors.grey);

       case 5: // Other reasons
         return const Icon(Icons.help_outline, color: Colors.brown);

       default:
         return const Icon(Icons.help, color: Colors.grey);
     }
   }

}
