import 'package:earning_app/global/widget.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

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
              GlobalWidget.appbar(context, "About Us",show: true),

              /// App Intro
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
                        Icon(Icons.star, color: Color(0xff12BD6E)),
                        Text(
                          "  FUNSBIT Gaming Platform",
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
              _card(
                w,
                icon: Icons.people,
                title: "Who We Are",
                children: [
                  t2(
                      "FUNSBIT is a gaming and rewards platform where users can play games, earn coins, and redeem them for real money."),
                  s(6),
                  t2(
                      "We focus on providing fun, fair, and rewarding experiences for everyone."),
                ],
              ),

              s(15),

              /// Our Mission
              _card(
                w,
                icon: Icons.flag,
                title: "Our Mission",
                children: [
                  t1("Make gaming more rewarding"),
                  t1("Provide safe earning options"),
                  t1("Create a trusted community"),
                  t1("Ensure fair play for all users"),
                ],
              ),

              s(15),

              /// What We Offer
              _card(
                w,
                icon: Icons.videogame_asset,
                title: "What We Offer",
                children: [
                  t1("Fun and simple games"),
                  t1("Coin rewards system"),
                  t1("Easy withdrawals"),
                  t1("Daily earning opportunities"),
                  t1("Secure login system"),
                ],
              ),

              s(15),

              /// Why Choose Us
              _card(
                w,
                icon: Icons.thumb_up,
                title: "Why Choose FUNSBIT",
                children: [
                  t1("100% transparent system"),
                  t1("No hidden charges"),
                  t1("Fast support"),
                  t1("Privacy focused"),
                  t1("User-friendly interface"),
                ],
              ),

              s(15),

              /// Our Values
              _card(
                w,
                icon: Icons.favorite,
                title: "Our Values",
                children: [
                  t1("Honesty"),
                  t1("User Trust"),
                  t1("Security"),
                  t1("Innovation"),
                  t1("Quality Service"),
                ],
              ),

              s(15),

              /// Community
              _card(
                w,
                icon: Icons.forum,
                title: "Our Community",
                children: [
                  t2(
                      "We believe in building a strong and positive gaming community."),
                  s(6),
                  t2(
                      "Users can share feedback, report issues, and connect through the in-app forum."),
                ],
              ),

              s(15),

              /// Contact
              _card(
                w,
                icon: Icons.support_agent,
                title: "Contact Us",
                children: [
                  t2(
                      "For any questions, suggestions, or support, please contact us through the in-app forum."),
                  s(6),
                  t2(
                      "Your feedback helps us improve FUNSBIT."),
                ],
              ),

              s(25),
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable Card
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
