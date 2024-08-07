import 'package:brac_mobile/src/home/LastCrDrLoading.dart';
import 'package:brac_mobile/src/home/dashboard_screen.dart';
import 'package:brac_mobile/src/other/home_load.dart';
import 'package:brac_mobile/src/theme/app_theme.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:no_screenshot/no_screenshot.dart';
import '../other/base_screen.dart';
import 'LastCrDrWidget.dart';
import 'account_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  double value = 0;
  String? firstName, lastName, lastLogin;
  final _sharedPref = CommonSharedPref();
  // final _noScreenshot = NoScreenshot.instance;

  @override
  initState() {
    super.initState();
    // _noScreenshot.screenshotOff();
    getUserInfo();
  }

  getUserInfo() async {
    await _sharedPref
        .getUserAccountInfo(UserAccountData.FirstName)
        .then((value) {
      setState(() {
        firstName = value;
      });
    });
    await _sharedPref
        .getUserAccountInfo(UserAccountData.LastName)
        .then((value) {
      setState(() {
        lastName = value;
      });
    });
    await _sharedPref
        .getUserAccountInfo(UserAccountData.LastLoginDateTime)
        .then((value) {
      setState(() {
        lastLogin = value;
      });
    });
    @override
    Widget build(BuildContext context) {
      // TODO: implement build
      throw UnimplementedError();
    }
  }

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

    String name = '$firstName $lastName';

    return WillPopScope(
        onWillPop: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  "Alert",
                  style: TextStyle(
                    fontFamily: "Mulish",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: const Text(
                  "Are you sure you want to Logout?",
                  style: TextStyle(
                    fontFamily: "Mulish",
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontFamily: "Mulish", fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true); // Allow back navigation
                    },
                  ),
                  TextButton(
                    child: const Text(
                      "Yes",
                      style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontFamily: "Mulish", fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const Dashboard()),
                            (route) => false,
                      ); // Allow back navigation
                    },
                  ),
                ],
              );
            },
          );
          return false;
        },
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor:
                Colors.transparent, // Make the status bar transparent
          ),
          child: Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/bk.png'),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter),
              ),
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 5),
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Text(
                    greeting,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontFamily: "Mulish",
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontFamily: "Mulish",
                        color: Colors.white,
                        fontSize: 13),
                  ),
                  AccountWidget(),
                  const SizedBox(
                    height: 1,
                  ),
                  LastCrDr(),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20.0),
                    child: const Text(
                      "FUNCTIONS",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: "Mulish",
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 0,
                  ),
                  MainModules(),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: const BorderSide(
                                        color:
                                            Color.fromRGBO(138, 29, 92, 1)))),
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromRGBO(138, 29, 92, 1)),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                "Alert",
                                style: TextStyle(
                                  fontFamily: "Mulish",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: const Text(
                                "Are you sure you want to Logout?",
                                style: TextStyle(
                                  fontFamily: "Mulish",
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontFamily: "Mulish", fontSize: 18),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(true); // Allow back navigation
                                  },
                                ),
                                TextButton(
                                  child: const Text(
                                    "Yes",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontFamily: "Mulish", fontSize: 18),
                                  ),
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => const Dashboard()),
                                          (route) => false,
                                    ); // Allow back navigation
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Logout'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class MainModules extends StatelessWidget {
  final _homeRepo = HomeRepository();

  MainModules({super.key});

  @override
  Widget build(BuildContext context) => FutureBuilder<List<ModuleItem>>(
        future: _homeRepo.getMainModules(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ModuleItem>> snapshot) {
          Widget child = Center(
            child: HomeLoad(
              child: const LastCrDrLoading(),
            ),
          );
          if (snapshot.hasData) {
            var moduleItems = snapshot.data;
            child = Center(
              child: LoadUtil(),
            );
            if (moduleItems != null && moduleItems.isNotEmpty) {
              child = GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                      left: 14, right: 14, top: 8, bottom: 8),
                  itemCount: snapshot.data?.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: .9,
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 4),
                  itemBuilder: (context, index) {
                    return ModuleItemWidget(
                      moduleItem: snapshot.data![index],
                    );
                  });
            }
          }
          return child;
        },
      );
}
