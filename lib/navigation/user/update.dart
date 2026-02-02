import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earning_app/global/color.dart';
import 'package:earning_app/global/notify.dart';
import 'package:earning_app/global/widget.dart';
import 'package:earning_app/login/bloc/bloc.dart';
import 'package:earning_app/login/bloc/userevent.dart';
import 'package:earning_app/model/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Update extends StatefulWidget {
  UserModel user;
  Update({super.key,this.isback=true,required this.user});
  bool isback;

  @override
  State<Update> createState() => _UserProfileState();
}

class _UserProfileState extends State<Update> {
  String pic="";
  @override
  void initState(){
    super.initState();

    name.text = widget.user.name;
    emails.text = widget.user.email;
    phone.text = widget.user.phone;
    age.text = widget.user.password;
  }

  TextEditingController emails = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlobalWidget.appbar(context, "Update Profile"),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text("Complete your Profile",style: GoogleFonts.robotoSlab(
                  textStyle: const TextStyle(color: Colors.black,
                      fontSize: 20,fontWeight: FontWeight.w900),
                ),),
                Text("Just a few things to update your Profile",style: GoogleFonts.roboto(
                  textStyle: const TextStyle(color: Colors.black,
                      fontSize: 12,fontWeight: FontWeight.w400),
                ),),
                SizedBox(height: 20,),
                Center(
                  child: CircleAvatar(
                    radius: 68,
                    backgroundColor: Colors.grey.shade300,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: CircleAvatar(
                        radius: 65,
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.grey.shade300,
                            child: Center(child: Icon(Icons.person,color: Colors.black,size: 60,),),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                c(name, "Your Name",Icon(Icons.person)),
                SizedBox(height: 10,),
                c(emails, "Your Email",Icon(Icons.email)),
                SizedBox(height: 10,),
                c(phone, "Your Phone Number",Icon(Icons.phone_android)),
                SizedBox(height: 10,),
                c(age, "Your Age ( Optional - min 18 )",Icon(Icons.phone_android)),
                SizedBox(height: 20,),
                InkWell(
                  onTap: () async {
                    try {
                      change(true);
                      await FirebaseFirestore.instance.collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid).update({
                        "name":name.text.trim(),
                        "password":age.text.trim(),
                        "phone":phone.text.trim(),
                      });
                      context.read<UserBloc>().add(RefreshUserEvent());
                      change(false);
                      Send.topic(context, "Success","Your Data is Updated",b: false);
                    }catch(e){
                      change(false);
                      Send.topic(context, "Error","${e}");
                    }

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
                        Icon(Icons.login,color: Colors.black,),
                        SizedBox(width: 8),
                        Text(
                          "Update Account",
                          style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  bool progress= false;
  void change(bool th){
    progress = th;
  }
  Widget c(TextEditingController c, String str, Widget icon){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: c,
        style: const TextStyle(color: Colors.black),
        cursorColor: Colors.black,
        decoration:  InputDecoration(
          hintText: str,
          prefixIcon: icon,
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
  bool on=false;
  TextEditingController username=TextEditingController();
  TextEditingController address=TextEditingController();
  TextEditingController age=TextEditingController();
  Widget r14(TextEditingController _controller,double w,String str,bool yrrt){
    return  Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          width: w-20,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: Colors.grey.shade300, width: 2),
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(left: 16,top: 8.0,bottom: 8,right: 16),
            child: TextField(
              controller: _controller,
              keyboardType:yrrt?TextInputType.number: TextInputType.name,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w800
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                counterText: "",
                hintText: str,
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget r1456(TextEditingController _controller,double w,String str,bool yrrt){
    return  Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          width: w-20,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: Colors.grey.shade300, width: 2),
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(left: 16,top: 8.0,bottom: 8,right: 16),
            child: TextField(
              controller: _controller,
              keyboardType:yrrt?TextInputType.number: TextInputType.name,
              textAlign: TextAlign.left,
              maxLength: 10,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w800
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                counterText: "",
                hintText: str,
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget r(TextEditingController _controller,double w,String str){
    return  Center(
      child: Container(
        width: w-10,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: Colors.grey.shade300, width: 2),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(left: 16,top: 8.0,bottom: 8,right: 16),
          child: TextField(
            minLines: 3,maxLines: 20,
            controller: _controller,
            keyboardType: TextInputType.name,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w800
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              counterText: "",
              hintText: str,
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}