import 'package:earning_app/global/widget.dart';
import 'package:flutter/material.dart';

class Terms extends StatelessWidget {
  Terms({super.key});

  final Color green = const Color(0xff12BD6E);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
            opacity: 0.2,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// App Bar
              GlobalWidget.appbar(context, "Terms & Privacy Policy",show: true),

              /// Last Updated
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  width: w * 2 / 3,
                  decoration: BoxDecoration(
                    color: const Color(0xffE5FDF0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14.0, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.calendar_month,
                            color: Color(0xff12BD6E)),
                        Text(
                          "  Last Updated : Feb 2, 2026",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            color: Color(0xff12BD6E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              s(5),

              /// Privacy Highlights
              _card(
                w,
                icon: Icons.security,
                title: "Privacy Highlights",
                children: [
                  t1("We never share your data"),
                  t1("Your email is safe with us"),
                  t1("Mobile number is optional"),
                  t1("Secure login with Google"),
                ],
              ),

              s(15),

              /// Information We Collect
              _card(
                w,
                icon: Icons.info_outline,
                title: "Information We Collect",
                children: [
                  t2(
                      "We collect your email address through Google Login for account management and security."),
                  s(6),
                  t2(
                      "Mobile number is optional and used only for better support."),
                ],
              ),

              s(15),

              /// How We Use Data
              _card(
                w,
                icon: Icons.settings,
                title: "How We Use Your Data",
                children: [
                  t1("To manage your account"),
                  t1("To provide rewards"),
                  t1("To improve app performance"),
                  t1("To prevent fraud"),
                ],
              ),

              s(15),

              /// Rewards & Coins
              _card(
                w,
                icon: Icons.monetization_on,
                title: "Coins & Rewards",
                children: [
                  t2(
                      "Users can earn coins by playing games and watching ads."),
                  s(6),
                  t2(
                      "1000 points = ₹1 INR. Minimum withdrawal may apply."),
                  s(6),
                  t2(
                      "Rewards may change due to technical or legal reasons."),
                ],
              ),

              s(15),

              /// User Responsibility
              _card(
                w,
                icon: Icons.person,
                title: "User Responsibility",
                children: [
                  t1("Only one account per user"),
                  t1("No cheating or hacking"),
                  t1("No fake accounts"),
                  t1("Follow fair play rules"),
                ],
              ),

              s(15),

              /// Account Termination
              _card(
                w,
                icon: Icons.block,
                title: "Account Termination",
                children: [
                  t2(
                      "We reserve the right to suspend or ban accounts involved in misuse, fraud, or unfair activities."),
                  s(6),
                  t2(
                      "Such actions may be taken without prior notice."),
                ],
              ),

              s(15),

              /// Contact Us
              _card(
                w,
                icon: Icons.support_agent,
                title: "Contact & Support",
                children: [
                  t2(
                      "If you have any doubts, issues, or complaints, please contact us through the in-app forum."),
                  s(6),
                  t2(
                      "We aim to respond as quickly as possible."),
                ],
              ),

              s(25),
            ],
          ),
        ),
      ),
    );
  }

  /// Card Widget
  Widget _card(double w,
      {required IconData icon,
        required String title,
        required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Container(
        width: w - 30,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0xffE5FDF0).withOpacity(0.9),
              blurRadius: 8,
              spreadRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: green, size: 35),
                  t(title),
                ],
              ),
              s(10),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  /// Your Widgets

  Widget t2(String str) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 9.0),
    child: Text(
      str,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 15,
      ),
    ),
  );

  Widget t1(String str) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 5),
    child: Row(
      children: [
        Icon(Icons.verified_rounded, color: green, size: 25),
        Text(
          "  $str",
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ],
    ),
  );

  Widget t(String str) => Text(
    " $str",
    style: const TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 19,
    ),
  );

  Widget s(double w) => SizedBox(height: w);
}
