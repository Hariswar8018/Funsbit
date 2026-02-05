import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earning_app/admin/send_notification.dart';
import 'package:earning_app/global/notify.dart';
import 'package:earning_app/global/widget.dart';
import 'package:earning_app/login/bloc/bloc.dart';
import 'package:earning_app/login/bloc/userevent.dart';
import 'package:earning_app/navigation/user/service/transaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Withdraw extends StatefulWidget {
  Withdraw({super.key});

  @override
  State<Withdraw> createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            GlobalWidget.appbar(context, "Withdraw Coins"),
            SizedBox(height: 15,),
            Container(
              width: w-25,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4), // shadow downwards
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Available Coins",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w400),),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset("assets/gold.png",width: 24,),
                        SizedBox(width: 5,),
                        Text("${GlobalUser.user.balance}",style: TextStyle(height:1,fontSize: 28,fontWeight: FontWeight.w900),)
                      ],
                    ),
                  ),
                  SizedBox(height: 6,),
                  Text("2000 Coins = ₹1",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Container(
              width: w-25,
              height: upi?570:650,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4), // shadow downwards
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Withdrawal Details",
                      style: TextStyle(height:1,fontSize: 21,fontWeight: FontWeight.w800),),
                    SizedBox(height: 14,),
                    Text("Total Coins",
                      style: TextStyle(height:1,fontSize: 18,fontWeight: FontWeight.w800),),
                    c(coins, "Total Coins to Withdraw", Icon(Icons.diamond_outlined),str8: "hsxbnx"),
                    SizedBox(height: 14,),
                    Text("Withdraw Method : ",
                      style: TextStyle(height:1,fontSize: 18,fontWeight: FontWeight.w800),),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        card(w, true),card(w, false)
                      ],
                    ),
                    SizedBox(height: 14,),
                    Text(upi?"Your UPI Details":"Your Bank Account Number",
                      style: TextStyle(height:1,fontSize: 18,fontWeight: FontWeight.w800),),
                    upi?c(upinum, "8093426959@paytm", Icon(Icons.alternate_email)):
                    c(upinum2, "5544567534790", Icon(Icons.numbers)),
                    upi?SizedBox():SizedBox(height: 14,),
                    upi?SizedBox():Text("IFSC CODE",
                      style: TextStyle(height:1,fontSize: 18,fontWeight: FontWeight.w800),),
                    upi?SizedBox():c(ifsc, "KKBK009574", Icon(Icons.confirmation_num)),
                    SizedBox(height: 14,),
                    SizedBox(height: 20,),
                    progress?Center(child: CircularProgressIndicator()):InkWell(
                      onTap: () async {
                        int i = int.parse(coins.text);
                        if(i>GlobalUser.user.balance){
                          Send.topic(context, "Not Enough Balance","You don't have Enough Balance to redeem. You have only ${GlobalUser.user.balance} Coins");
                          return ;
                        }
                        if(i<=20000){
                          Send.topic(context, "Minimum Withdrawal 100 INR","Minimum Withdraw is 200,000 Coins for 100 INR. Come back later");
                          return ;
                        }
                        if(upi && upinum.text.isEmpty){
                          Send.topic(context, "Fill your UPI Number","Fill your UPI Number to Proceed");
                          return ;
                        }else if( !upi && (upinum2.text.isEmpty || ifsc.text.isEmpty)){
                          Send.topic(context, "Fill your Details","Fill your Bank Number and IFSC to Proceed");
                          return ;

                        }
                        await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              title: const Text("Confirm to Withdrawal"),
                              content: const Text("Make Sure to check all details again ! Payments will be carried out in this Account only"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(Colors.red),
                                  ),
                                  onPressed: () async {
                                    Navigator.pop(context, true);
                                    startprocess(i);
                                  },
                                  child: const Text(
                                    "OK",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 20,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xFF00FD88), // blue
                              Color(0xFF01CF6B), // cyan
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.payment,color: Colors.black,),
                            SizedBox(width: 8),
                            Text(
                              "Request Withdrawl",
                              style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 3,),
                    Text("* Minimum Gift Card is INR 100"),
                    Text("* Processing Time 1-3 Working Days"),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15,),
          ],
        ),
      ),
    );
  }
  Future<void> startprocess(int i) async {
    togglee(true);
    try {
      await FirebaseFirestore.instance.collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid).update({
        "balance": FieldValue.increment(-i),
      });
      context.read<UserBloc>().add(RefreshUserEvent());
      await TransactionService.updateTransaction(
        id: DateTime.now().toString(),
        name: 'Withdraw ${i / 2000} INR for $i Coins',
        coins: i,
        status: 'Waiting for Admin Approval',
        debit: true,
        userId: GlobalUser.user.id,
        upi: upinum.text,
        bankno: upinum2.text,
        bankinfc: ifsc.text,
      );
      togglee(false);

      Send.topic(
          context, "Success", "Your Withdrawl Request is Proceed", b: true);
      await NotifyAll.sendNotificationsCompany(
          "🎉 Congrats Your Redeem $i Coins",
          "Your Withdrawal ${stsr()} will be processed within 2-3 Business Days ",
          [GlobalUser.user.tokens]);
    }catch(e){
      togglee(true);
      Send.topic(
          context, "Error", "$e", b: true);
    }
  }
  void togglee(bool y){
    setState(() {
      progress = y;
    });
  }
  bool progress = false;

  TextEditingController upinum = TextEditingController();
  TextEditingController upinum2 = TextEditingController();
  TextEditingController ifsc = TextEditingController();

  Widget card(double w , bool toggles )=>InkWell(
    onTap: toggle,
    child: Container(
      width: w/2-40,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: toggles == upi ?Colors.blue : Colors.white,
        ),
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(image: AssetImage(toggles?"assets/upi.png":"assets/bank.png"),fit: BoxFit.contain)
      ),
    ),
  );

  void toggle(){
    setState(() {
      upi = !upi;
    });
  }

  bool upi = true;

  TextEditingController coins = TextEditingController();

  Widget c(TextEditingController c, String str, Widget icon,{bool number = false, String str8=""}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: c,
        keyboardType: number?TextInputType.number:TextInputType.text,
        style: const TextStyle(color: Colors.black),
        cursorColor: Colors.black,
        decoration:  InputDecoration(
          hintText: str,
          prefixIcon: icon,
          suffix: str8.isEmpty?SizedBox():Text(stsr()),
          labelStyle: TextStyle(color: Colors.black),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
  String stsr(){
    try {
      int y = int.parse(coins.text);
      return (y / 2000).toStringAsFixed(0)+"₹ ";
    }catch(e){
      return "";
    }
  }
}
