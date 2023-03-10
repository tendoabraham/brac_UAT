import 'dart:math';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../other/app_state.dart';
import '../other/common_widget.dart';
import 'home_screen.dart';

class DrawerAnimated extends StatefulWidget {
  const DrawerAnimated({Key? key}) : super(key: key);

  @override
  _DrawerAnimatedState createState() => _DrawerAnimatedState();
}

class _DrawerAnimatedState extends State<DrawerAnimated> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ! Here Color Of Page Drawer !
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff81BE41), Color(0xff0D4C92)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter)),
          ),

          // ! simple navigation menu !
          SafeArea(
              child: Container(
            width: 200,
            // color: Colors.amberAccent,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                DrawerHeader(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 45,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Label(
                          text: "$firstName $lastName",
                          textColor: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Label(
                    text: "Home",
                    textColor: Colors.white,
                  ),
                  leading: Icon(Icons.home),
                ),
                ListTile(
                  title: Label(
                    text: "Settings",
                    textColor: Colors.white,
                  ),
                  leading: Icon(Icons.settings),
                ),
                ListTile(
                  title: Label(
                    text: "Exit",
                    textColor: Colors.white,
                  ),
                  leading: Icon(Icons.exit_to_app),
                ),
              ],
            ),
          )),

          // ! : MainScreen
          TweenAnimationBuilder(
              // ? Here Change Animation
              curve: Curves.easeInOut,
              tween: Tween<double>(begin: 0, end: drawerStatus.value),
              // ? and here change
              duration: const Duration(milliseconds: 500),
              builder: (_, double val, __) {
                return (Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..setEntry(0, 3, 200 * val)
                      ..rotateY((pi / 6) * val),
                    child: const HomeScreen(
                    //     header: Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Label(
                    //           text: "Hello ${firstName ?? ""}",
                    //           fontSize: 24,
                    //           fontWeight: FontWeight.bold,
                    //           textColor: Colors.white,
                    //         ),
                    //         const SizedBox(
                    //           height: 8,
                    //         ),
                    //         Label(
                    //           text: " Last Login: ${lastLogin ?? ""}",
                    //           textColor: Colors.white,
                    //         )
                    //       ],
                    //     ),
                    //     const Spacer(),
                    //     CircleAvatar(
                    //         radius: 24,
                    //         child: InkWell(
                    //           onTap: () {
                    //             setState(() {
                    //               drawerStatus.value == 0
                    //                   ? drawerStatus.value = 1
                    //                   : drawerStatus.value = 0;
                    //             });
                    //           },
                    //           child: const Icon(Icons.person),
                    //         )),
                    //     // IconButton(
                    //     //     onPressed: () {
                    //     //       AlertUtil.showAlertDialog(context, "Would you like to logout",
                    //     //               isConfirm: true)
                    //     //           .then((value) {
                    //     //         if (value) {
                    //     //           Navigator.of(context).pop();
                    //     //         }
                    //     //       });
                    //     //     },
                    //     //     icon: Icon(
                    //     //       Icons.power_settings_new,
                    //     //       size: 28,
                    //     //     ))
                    //   ],
                    // )
                    )));
              }),

          //! Gesture For Slide
          GestureDetector(
            // onHorizontalDragUpdate: (e) {
            //   if (e.delta.dx > 0) {
            //     setState(() {
            //       drawerStatus.value = 1;
            //     });
            //   } else {
            //     setState(() {
            //       drawerStatus.value = 0;
            //     });
            //   }
            // },
          )
        ],
      ),
    );
  }
}
