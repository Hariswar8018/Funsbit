
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../navigation/naviagtion.dart';
import '../global/color.dart';



class Login extends StatefulWidget {
  final String str;
  const Login({super.key,required this.str});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController usernameC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  TextEditingController name = .new();
  TextEditingController email = .new();
  TextEditingController confirm = .new();
  TextEditingController coupon = .new();


  Future<void> login() async {
    final username = usernameC.text.trim();
    final password = passwordC.text.trim();

    /*
    LoginModel? user = await Users.login(context, username: username, password: password, name: widget.str);
    if(user!=null){
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      await prefs.setString('id', widget.str);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>InitCla(id: widget.str,username: username,)));
    }

     */
    debugPrint('Username: $username');
    debugPrint('Password: $password');
  }

  @override
  void dispose() {
    usernameC.dispose();
    passwordC.dispose();
    super.dispose();
  }

  bool create = true;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: create ? Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/background.jpg")
                ,fit: BoxFit.cover)
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 35,),
              Container(
                width: 120,height: 120,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: GlobalColor.green.withOpacity(0.2),
                    border: Border.all(
                        color: GlobalColor.green,width: 3
                    )
                ),
                child: Center(
                  child: Image.asset("assets/logo_noback.png",height: 70,),
                ),
              ),
              Text("FUNSBIT",style: GoogleFonts.robotoSlab(
                textStyle: const TextStyle(color: Color(0xff16603B), letterSpacing: .5,fontSize: 27,fontWeight: FontWeight.w900),
              ),),
              Text("PLAY | MINE | EARN",style: GoogleFonts.robotoSlab(
                textStyle: TextStyle(color:GlobalColor.green, letterSpacing: .5,fontSize: 18,fontWeight: FontWeight.w700),
              ),),
              SizedBox(height: 35,),
              Container(
                width: w-30,
                height: h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25), // soft shadow
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: const Offset(0, 6), // vertical drop
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Create Account ! 👋",style: GoogleFonts.robotoSlab(
                        textStyle: const TextStyle(color: Colors.black,
                            fontSize: 20,fontWeight: FontWeight.w900),
                      ),),
                      Text("We Welcome you to FUNSBIT App Community",style: GoogleFonts.roboto(
                        textStyle: const TextStyle(color: Colors.black,
                            fontSize: 12,fontWeight: FontWeight.w400),
                      ),),
                      SizedBox(height: 20,),
                      c(usernameC, "Your Name"),
                      SizedBox(height: 10,),
                      c(passwordC, "Your Email Address"),
                      SizedBox(height: 10,),
                      c(passwordC, "Your Password"),
                      SizedBox(height: 10,),
                      c(passwordC, "Confirm Password"),
                      SizedBox(height: 10,),
                      c(passwordC, "Your Phone Number"),
                      SizedBox(height: 10,),
                      c(passwordC, "Your Coupon"),
                      SizedBox(height: 20,),
                      InkWell(
                        onTap: (){
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              childBuilder: (context) => MyNavigationPage()
                            ),
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
                              Icon(Icons.login,color: Colors.black,),
                              SizedBox(width: 8),
                              Text(
                                "Create Account",
                                style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Not New? ",style: GoogleFonts.roboto(
                            textStyle: const TextStyle(color: Colors.black,
                                fontSize: 17,fontWeight: FontWeight.w600),
                          ),),
                          Text("Login",style: GoogleFonts.roboto(
                            textStyle: const TextStyle(color: Colors.blue,
                                fontSize: 17,fontWeight: FontWeight.w900),
                          ),),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25,),
            ],
          ),
        ),
      )
          :Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/background.jpg")
                ,fit: BoxFit.cover)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 35,),
            Container(
              width: 120,height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: GlobalColor.green.withOpacity(0.2),
                border: Border.all(
                  color: GlobalColor.green,width: 3
                )
              ),
              child: Center(
                child: Image.asset("assets/logo_noback.png",height: 70,),
              ),
            ),
            Text("FUNSBIT",style: GoogleFonts.robotoSlab(
              textStyle: const TextStyle(color: Color(0xff16603B), letterSpacing: .5,fontSize: 27,fontWeight: FontWeight.w900),
            ),),
            Text("PLAY | MINE | EARN",style: GoogleFonts.robotoSlab(
              textStyle: TextStyle(color:GlobalColor.green, letterSpacing: .5,fontSize: 18,fontWeight: FontWeight.w700),
            ),),
            SizedBox(height: 35,),
            Container(
              width: w-30,
              height: h*(1.6/3),
              decoration: BoxDecoration(
                color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25), // soft shadow
                      blurRadius: 12,
                      spreadRadius: 1,
                      offset: const Offset(0, 6), // vertical drop
                    ),
                  ],
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome Back ! 👋",style: GoogleFonts.robotoSlab(
                      textStyle: const TextStyle(color: Colors.black,
                          fontSize: 20,fontWeight: FontWeight.w900),
                    ),),
                    Text("Signing to continue your Progress",style: GoogleFonts.roboto(
                      textStyle: const TextStyle(color: Colors.black,
                          fontSize: 12,fontWeight: FontWeight.w400),
                    ),),
                    SizedBox(height: 20,),
                    c(usernameC, "Your Phone Number"),
                    SizedBox(height: 10,),
                    c(passwordC, "Your Password"),
                    SizedBox(height: 20,),
                    InkWell(
                      onTap: login,
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
                              "Login",
                              style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't Have? ",style: GoogleFonts.roboto(
                          textStyle: const TextStyle(color: Colors.black,
                              fontSize: 17,fontWeight: FontWeight.w600),
                        ),),
                        Text("Create Account",style: GoogleFonts.roboto(
                          textStyle: const TextStyle(color: Colors.blue,
                              fontSize: 17,fontWeight: FontWeight.w900),
                        ),),
                      ],
                    )
                  ],
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
  Widget c(TextEditingController c, String str){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: c,
        style: const TextStyle(color: Colors.black),
        cursorColor: Colors.black,
        decoration:  InputDecoration(
          hintText: str,
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
}