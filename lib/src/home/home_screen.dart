import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:flutter/material.dart';

import '../other/base_screen.dart';
import '../other/common_widget.dart';
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

  @override
  initState() {
    super.initState();
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

    return  BaseScreen(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bk.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter
          ),
        ),
        child: ListView(
          children: [
            const SizedBox(
              height: 30,
            ),
            Text(greeting,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: "Mulish",
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold
            ),),
            Text(name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: "Mulish",
                  color: Colors.white,
                  fontSize: 13
              ),),
            AccountWidget(),
            const SizedBox(
              height: 1,
            ),
            LastCrDr(),
            const SizedBox(
              height: 12,
            ),
            Container(
              margin: const EdgeInsets.only(left: 15.0),
              child:  const Text("FUNCTIONS",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: "Mulish",
                    fontSize: 13,
                  fontWeight: FontWeight.bold
                ),),
            ),
            const SizedBox(
              height: 12,
            ),
            MainModules(),
            const SizedBox(
              height: 12,
            ),
            // Padding(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            // child: ElevatedButton(
            //   style: ButtonStyle(
            //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //         RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(30),
            //             side: const BorderSide(color: Color.fromRGBO(138, 29, 92, 1)))),
            //     backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(138, 29, 92, 1)),
            //   ),
            //   onPressed: () {
            //     AlertUtil.showAlertDialog(context, "Proceed to logout?",
            //         isConfirm: true)
            //         .then((value) {
            //       if (value) {
            //         Navigator.of(context).pop();
            //       }
            //     });
            //   },
            //   child: const Text('Logout'),
            // ),)
          ],
        )
        ,),);
  }


  // @override
  // Widget build(BuildContext context) => WillPopScope(
  //     onWillPop: () async {
  //       return AlertUtil.showAlertDialog(context, "Would you like to logout",
  //                   isConfirm: true)
  //               .then((value) {
  //             if (value) {
  //               Navigator.of(context).pop();
  //             }
  //           }) ??
  //           false;
  //     },
  //     child: BaseScreen(
  //         child: Container(
  //           decoration: const BoxDecoration(
  //             image: DecorationImage(
  //                 image: AssetImage('assets/images/bk.png'),
  //                 fit: BoxFit.cover,
  //                 alignment: Alignment.topCenter
  //             ),
  //           ),
  //           child: ListView(
  //             children: [
  //               const SizedBox(
  //                 height: 12,
  //               ),
  //               Center(
  //                   child: Label(
  //                     text: "Accounts",
  //                     fontSize: 12,
  //                   )),
  //               Center(
  //                   child: Label(
  //                     text: "Accounts",
  //                     fontSize: 12,
  //                   )),
  //               AccountWidget(),
  //               const SizedBox(
  //                 height: 12,
  //               ),
  //               Padding(
  //                   padding: const EdgeInsets.symmetric(horizontal: 14),
  //                   child: Label(
  //                     text: "Features",
  //                     fontSize: 18,
  //                   )),
  //               MainModules()
  //             ],
  //           )
  //         ,),));
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
            child: LoadUtil(),
          );
          if (snapshot.hasData) {
            var moduleItems = snapshot.data;
            child = Center(
              child: LoadUtil(),
            );
            if (moduleItems != null && moduleItems.isNotEmpty) {
              child =
                  // Card(
                  // elevation: 12,
                  // surfaceTintColor: Colors.white,
                  // shape: const RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.all(
                  //         Radius.circular(12.0))),
                  // child:
                  GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      itemCount: snapshot.data?.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 16 / 18,
                              crossAxisCount: 3,
                              mainAxisSpacing: 1,
                              crossAxisSpacing: 1),
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
