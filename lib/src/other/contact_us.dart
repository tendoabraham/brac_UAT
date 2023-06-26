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
      child: ListView(
          children: [
            AppBar(title: const Text("Our Contacts"),
              titleTextStyle: const TextStyle(fontFamily: "Mulish",
                  fontWeight: FontWeight.bold,
                  fontSize: 18),),
            const SizedBox(
              height: 36,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20.0),
              child: Image.asset('assets/images/brac.png',
                alignment: Alignment.centerLeft,
                height: 50,
                width: 50,),
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
              child:                           Label(
                text: "Address",
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              margin: const EdgeInsets.only(left: 20.0),
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
                child: SizedBox(
                  height: 35.0,
                  child: Row(
                    children: const [
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
                child: SizedBox(
                  height: 35.0,
                  child: Row(
                    children: const [
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
              child: Label(
                text: "Connect",
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              margin: const EdgeInsets.only(left: 20.0),
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
          ]),
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
