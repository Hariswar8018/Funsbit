import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earning_app/global/widget.dart';
import 'package:earning_app/model/usermodel.dart';
import 'package:earning_app/navigation/user/history.dart';
import 'package:flutter/material.dart';

class Users extends StatelessWidget {
  const Users({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GlobalWidget.appbar(context, "All Users"),
          SizedBox(height: 5,),
          Flexible(child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No users found'));
              }

              final users = snapshot.data!.docs
                  .map((doc) => UserModel.fromMap(
                doc.data() as Map<String, dynamic>,
              ))
                  .toList();

              return ListView.separated(
                itemCount: users.length,
                separatorBuilder: (_, __) => const Divider(height: 0),
                itemBuilder: (context, index) {
                  final user = users[index];

                  return ListTile(
                    tileColor: Colors.white,
                    leading: CircleAvatar(
                      child: Text(
                        user.name.isNotEmpty
                            ? user.name[0].toUpperCase()
                            : '?',
                      ),
                    ),
                    title: Text(user.name,style: TextStyle(fontWeight: FontWeight.w500),),
                    subtitle: Text("Coins Earned : "+user.balance.toString(),style: TextStyle(fontWeight: FontWeight.w900),),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UserDetailPage(user: user),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ))
        ],
      ),
    );
  }
}

class UserDetailPage extends StatelessWidget {
  final UserModel user;

  const UserDetailPage({super.key, required this.user});

  Widget row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlobalWidget.appbar(context, "${user.name}"),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Container(
                  width: w-25,
                  height: 230,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4), // shadow downwards
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              children: [
                                Container(
                                  height: 80,width: 80,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                          colors:[Colors.blue.shade800, Colors.lightBlueAccent.shade100]
                                      )
                                  ),
                                  child: Center(child: Text("${user.name.substring(0,1)}",
                                    style: TextStyle(fontWeight: FontWeight.w900,fontSize: 35),)),
                                ),
                                SizedBox(width: 15,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user.name,
                                      style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20),),
                                    Text("${user.email}",style: TextStyle(fontSize: 10),),
                                    SizedBox(height: 4,),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.orange.shade50,
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 4),
                                        child: Text("🏆 App Level ${user.level}"
                                          ,style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w900, fontSize: 11),),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),

                        Container(
                          width: w*(7/8),
                          height: 3,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20)
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(

                              child: Column(
                                children: [
                                  Text("${user.balance}",style: TextStyle(
                                      fontSize: 28,fontWeight: FontWeight.w900
                                  ),),
                                  Text("Coins",style: TextStyle(
                                      fontSize: 15,fontWeight: FontWeight.w600
                                  ),),
                                ],
                              ),
                            ),
                            Container(
                              width: 3,
                              height: 75,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                            InkWell(
                              onTap: (){
                              },
                              child: Column(
                                children: [
                                  Text("${user.walletBalance}",style: TextStyle(
                                      fontSize: 28,fontWeight: FontWeight.w900,
                                      color: Colors.orange
                                  ),),
                                  Text("Referral",style: TextStyle(
                                      fontSize: 15,fontWeight: FontWeight.w600
                                  ),),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>History(id: user.id)));
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
                        Icon(Icons.transfer_within_a_station,color: Colors.white,),
                        Text("Check his Transactions",style: TextStyle(fontWeight: FontWeight.w900,color: Colors.white),)
                      ],),
                  ),
                ),
              ),
            ),
            Padding(
              padding:EdgeInsets.symmetric(horizontal:15),
                child:Column(
                    children:[
                      row('Phone', user.phone),
                      row('Withdrawal', user.withdrawalBalance.toString()),
                      row('Total Taps', user.totalTaps.toString()),
                      row('Ads Seen', user.totalAdsSeen.toString()),
                      row('Referral Count', user.referral.toString()),
                      row('Referral Code', user.myReferralCode),
                      row('Total Done', user.totalDone.toString()),
                      row('Daily Streak', user.dailyStreak.toString()),
                      const SizedBox(height: 12),
                      /*const Text(
                        'Games Played',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        children: user.gamesPlayed
                            .map((e) => Chip(label: Text(e)))
                            .toList(),
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        'My Referrals',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        children: user.myReferral
                            .map((e) => Chip(label: Text(e)))
                            .toList(),
                      ), */
                    ]
                ),
            ),

          ],
        ),
      ),
    );
  }
}
