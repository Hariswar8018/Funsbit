import 'package:earning_app/global/widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          GlobalWidget.appbar(context, "Help and Support"),
          SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Contact Us",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 18),),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: w-25,
            height: 220,
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                list(Icon(Icons.email, color:Colors.red,size: 25,), "Email Support", "mailto:satyabratam433@gmail.com"),
                list(Icon(Icons.mark_chat_read, color:Colors.green,size: 25,), "Whatsapp", "https://wa.me/918260566251"),
                list(Icon(Icons.telegram, color:Colors.blue,size: 25,), "Telegram", "https://t.me/+6y6Lnkhk13E3NzE1"),
              ],
            ),
          ),
          SizedBox(height: 25,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Legal",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 18),),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: w-25,
            height: 220,
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                list2(Icon(Icons.info, color:Colors.black,size: 25,), "About Us", "about"),
                list2(Icon(Icons.security_sharp, color:Colors.orange,size: 25,), "Terms & Privacy", "terms"),
                list(Icon(Icons.admin_panel_settings_rounded, color:Colors.red,size: 25,), "Online Privacy", "https://sites.google.com/view/funsbit/home"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget list2(Widget icon, String str, String navigate)=>ListTile(
    onTap: () async {
      context.push("/${navigate}");
    },
    leading: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: icon,
        )),
    title: Text(str,style: TextStyle(fontWeight: FontWeight.w700),),
    trailing: Icon(Icons.arrow_forward,color: Colors.grey,),
  );

  Widget list(Widget icon, String str, String navigate)=>ListTile(
    onTap: () async {
      final Uri _url = Uri.parse(navigate);
      if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
      }
    },
    leading: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: icon,
        )),
    title: Text(str,style: TextStyle(fontWeight: FontWeight.w700),),
    trailing: Icon(Icons.arrow_forward,color: Colors.grey,),
  );
}
