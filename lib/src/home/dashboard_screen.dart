import 'package:brac_mobile/src/other/branches.dart';
import 'package:brac_mobile/src/other/contact_us.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../auth/activation_screen.dart';
import '../auth/login_screen.dart';
import '../other/app_state.dart';
import '../other/common_widget.dart';

String imageBase = "assets/images/";

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _sharedPref = CommonSharedPref();
  bool isActivated = false;

  @override
  void initState() {
    super.initState();

    //TODO: Comment out activation data before sharing
    // _sharedPref.addActivationData("256783657395", "1671877299");
    _sharedPref.addActivationData("256757964471", "8082316600");
    // _sharedPref.addActivationData("256783657395", "1722542461");
    // _sharedPref.addActivationData("254719286101", "4654217730");
    checkIsActivated();
    // SystemChrome.setEnabledSystemUIOverlays([]);
  }

  checkIsActivated() async {
    await _sharedPref.getAppActivationStatus().then((value) {
      setState(() {
        if (value) {
          isActivated = true;
          Provider.of<AppState>(context, listen: false).updateShowLogin(true);
        }else{
          isActivated = false;
          Provider.of<AppState>(context, listen: false)
              .updateShowActivation(true);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bk.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    children: [
                      const SizedBox(
                        height: 32,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Header(isActivated: isActivated),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                Powered(),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }
}

class Header extends StatelessWidget {
  final bool isActivated;

  const Header({Key? key, required this.isActivated}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentTime = DateTime.now();
    final currentTimeOfDay = currentTime.hour;

    String greeting = '';

    if (currentTimeOfDay < 12) {
      greeting = 'Good Morning!';
    } else if (currentTimeOfDay < 18) {
      greeting = 'Good Afternoon!';
    } else {
      greeting = 'Good Evening!';
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        //set border radius more than 50% of height and width to make circle
      ),
      elevation: 5,
      shadowColor: Colors.black,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          image: const DecorationImage(
              image: AssetImage('assets/images/bk4.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppLogo(),
                const SizedBox(
                  height: 32,
                ),
                const SizedBox(
                  height: 24,
                ),
                Label(
                  text: greeting,
                  fontSize: 13,
                ),
                Label(
                  text: "Welcome to Brac Mobile",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 32,
                ),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: const BorderSide(color: Color.fromRGBO(138, 29, 92, 1)))),
                      backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(138, 29, 92, 1)),
                    ),
                    onPressed: () {
                      if(isActivated){
                        CommonUtils.navigateToRoute(
                            context: context, widget: const LoginScreen());
                      }else{
                        CommonUtils.navigateToRoute(
                            //TODO: update to activation
                            // context: context, widget: const ActivationScreen());
                      context: context, widget: const LoginScreen());
                      }
                    },
                    child: const Text('Login'),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                const Options(),
                const SizedBox(
                  height: 24,
                ),
              ],
            )
        ),
      ),
    );
  }
}

class Options extends StatelessWidget{
  const Options({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      CommonUtils.navigateToRoute(
                          context: context, widget: Branches());
                    },
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          'assets/images/branch1.png',
                          height: 30,
                          width: 30,
                        ),
                        Label(
                          text: "Branches",
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  )
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      CommonUtils.navigateToRoute(
                          context: context, widget: const ContactUs());
                    },
                    child: Column(
                      children: <Widget>[
                        Image.asset('assets/images/contactus.png',
                          height: 30,
                          width: 30,),
                        Label(
                          text: "Contact us",
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ],

                    ),
                  )
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}
class Powered extends StatelessWidget{
  const Powered({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/cs_logo_powered.png',
          height: 100,
          width: 100,),
      ],
    );
  }
}