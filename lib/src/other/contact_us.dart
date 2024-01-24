import 'package:brac_mobile/src/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../other/base_screen.dart';
import '../other/common_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs>{

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bk4.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Our Contacts',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: primaryColor,
                          fontFamily: "Mulish",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                          ),
                          child: const Icon(
                            Icons.close,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 1.0, // Line height
                  color: Colors.grey[300], // Line color
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0),
                  alignment: Alignment.centerLeft,
                  child: Label(
                    text: "Let's talk",
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0),
                  alignment: Alignment.centerLeft,
                  child:                           Label(
                    text: "Get in touch with us\nAny time. Any day",
                    fontSize: 14,
                    textColor: CupertinoColors.systemGrey,
                  ),
                ),
                const SizedBox(
                  height: 36,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0),
                  alignment: Alignment.centerLeft,
                  child:                           Label(
                    text: "Address",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  margin: const EdgeInsets.only(left: 20.0),
                  alignment: Alignment.centerLeft,
                  child:                           Label(
                    text: "Plot 201, Mengo Kabuusu Rubaga \nP.O.BOX 6582, Kampala",
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0),
                  alignment: Alignment.centerLeft,
                  child:                           Label(
                    text: "Support",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: InkWell(
                    onTap: () {
                      _launchPhoneDialer('+256200900720');
                    },
                    child: const SizedBox(
                      height: 35.0,
                      child: Row(
                        children: [
                          Icon(Icons.phone),
                          SizedBox(width: 16.0),
                          Text('+256200900720'),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: InkWell(
                    onTap: () {
                      _launchEmail('bracugandabankltd@brac.net');
                    },
                    child: const SizedBox(
                      height: 35.0,
                      child: Row(
                        children: [
                          Icon(Icons.email),
                          SizedBox(width: 16.0),
                          Text('bracugandabankltd@brac.net'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0),
                  alignment: Alignment.centerLeft,
                  child: Label(
                    text: "Connect",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  margin: const EdgeInsets.only(left: 20.0),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          launch('https://www.facebook.com/BRACUgandaBank/?mibextid=LQQJ4d');
                        },
                        child:Image.asset('assets/images/fb_circled_.png',
                          alignment: Alignment.center,
                          height: 40,
                          width: 40,),
                      ),
                      const SizedBox(width: 8.0),
                      GestureDetector(
                        onTap: (){
                          launch('https://instagram.com/bracugandabank?igshid=YmMyMTA2M2Y=');
                        },
                        child:Image.asset('assets/images/insta.png',
                          alignment: Alignment.center,
                          height: 40,
                          width: 40,),
                      ),
                      const SizedBox(width: 8.0),
                      GestureDetector(
                        onTap: (){
                          launch('https://www.linkedin.com/company/brac-uganda-bank-ltd/');
                        },
                        child:Image.asset('assets/images/linked_in_circled.png',
                          alignment: Alignment.center,
                          height: 40,
                          width: 40,),
                      ),
                      const SizedBox(width: 8.0),
                      GestureDetector(
                        onTap: (){
                          launch('https://www.bracugandabankltd.com');
                        },
                        child:Image.asset('assets/images/website.png',
                          alignment: Alignment.center,
                          height: 40,
                          width: 40,),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

_launchPhoneDialer(String phoneNumber) async {
  final url = 'tel:$phoneNumber';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchEmail(String emailAddress) async {
  final Uri _emailLaunchUri = Uri(
    scheme: 'mailto',
    path: emailAddress,
  );
  String emailLaunchUri = _emailLaunchUri.toString();
  if (await canLaunch(emailLaunchUri)) {
    await launch(emailLaunchUri);
  } else {
    throw 'Could not launch $emailLaunchUri';
  }
}
