import 'dart:async';

import 'package:brac_mobile/src/theme/app_theme.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../home/app_drawer.dart';
import '../other/base_screen.dart';
import '../other/common_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authRepo = AuthRepository();
  final _formKey = GlobalKey<FormState>();
  final _pinController = TextEditingController();
  final _moduleRepository = ModuleRepository();
  final _sharedPref = CommonSharedPref();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    SessionRepository().startSession();
  }

  _checkBioLogin() async {
    String? bioEnabled = await _sharedPref.getBio();
    if (bioEnabled != null) {
      Completer<void> dialogCompleter = Completer<void>();

      if (bioEnabled == "true") {
        if (await BioMetricUtil.biometricAuthenticate()) {
          String bioPin = await _sharedPref.getBioPin();
          _pinController.text = CryptLib.decryptField(encrypted: bioPin);
          login(pin: _pinController.text);
        }
      } else {
        _showAlertDialog(dialogCompleter);
      }

      // Wait for the dialog to be dismissed before continuing
      await dialogCompleter.future;
    }
  }

  void _showAlertDialog(Completer<void> dialogCompleter) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Alert",
            style: TextStyle(
              fontFamily: "Myriad Pro",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "Please login with your PIN, select 'Account Settings' on the main menu and navigate to 'Biometrics Login' to enable fingerprint login",
            style: TextStyle(
              fontFamily: "Myriad Pro",
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "OK",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                dialogCompleter.complete(); // Complete the Future when the dialog is dismissed
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Make the status bar transparent
        ),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bk1.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            Positioned.fill(
              top: MediaQuery.of(context).padding.top,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Card(
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
                            alignment: Alignment.topCenter),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppLogo(),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.037,
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.045,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 12.0),
                                child: Label(
                                  text: "Input your login PIN",
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        child: WidgetFactory.buildTextField(
                                            context,
                                            TextFormFieldProperties(
                                                isEnabled: true,
                                                isObscured: true,
                                                controller: _pinController,
                                                textInputType:
                                                TextInputType.number,
                                                inputDecoration: InputDecoration(
                                                  hintText: "Login PIN",
                                                  suffixIcon: IconButton(
                                                    onPressed: () {
                                                      _checkBioLogin();
                                                    },
                                                    icon: const Icon(
                                                        Icons.fingerprint),
                                                  ),
                                                  contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0.0,
                                                      horizontal: 16.0),
                                                  hintStyle: const TextStyle(
                                                      fontSize: 13,
                                                      fontFamily: 'Mulish'),
                                                ),
                                                boxDecoration:
                                                const BoxDecoration(
                                                    shape:
                                                    BoxShape.rectangle)),
                                                (value) {
                                              if (_pinController.text.length < 4) {
                                                return "Please enter a valid PIN";
                                              }
                                            }),
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.037,
                                      ),
                                      _isLoading
                                          ? LoadUtil()
                                          : SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.05,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(30),
                                                    side: const BorderSide(
                                                        color:
                                                        Color.fromRGBO(
                                                            138,
                                                            29,
                                                            92,
                                                            1)))),
                                            backgroundColor:
                                            MaterialStateProperty.all(
                                                const Color.fromRGBO(
                                                    138, 29, 92, 1)),
                                          ),
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              login();
                                            }
                                          },
                                          child: const Text('Login'),
                                        ),
                                      ),
                                    ],
                                  )),
                              const SizedBox(
                                height: 20,
                              ),
                              // Center(
                              //   child: Label(
                              //     text: "Forgot Pin?",
                              //     fontSize: 14,
                              //     fontWeight: FontWeight.bold,
                              //     textColor: primaryColor,
                              //   ),
                              // ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 80,
                  // ),
                  // Center(
                  //   child: Label(
                  //     text: "Not Registered? Sign Up here",
                  //     fontSize: 14,
                  //     fontWeight: FontWeight.bold,
                  //     textColor: primaryColor,
                  //   ),
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  login({pin}) {
    setState(() {
      _isLoading = true;
    });
    _authRepo.login(pin ?? _pinController.text).then((value) {
      setState(() {
        _isLoading = false;
      });
      if (value.status == StatusCode.success.statusCode) {
        _pinController.clear();
        CommonUtils.navigateToRoute(context: context, widget: DrawerAnimated());
      } else if (value.status == StatusCode.changePin.statusCode) {
        _moduleRepository.getModuleById("PIN").then((module) {
          CommonUtils.navigateToRoute(
            context: context,
            widget: DynamicWidget(
              moduleItem: module,
            ),
          );
        });
      } else {
        AlertUtil.showAlertDialog(context, value.message ?? "Error");
      }
    });
  }

  // login() {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   _authRepo.login(_pinController.text).then((value) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     if (value.status == StatusCode.success.statusCode) {
  //       _pinController.clear();
  //       CommonUtils.navigateToRoute(context: context, widget: DrawerAnimated());
  //     } else if (value.status == StatusCode.changePin.statusCode) {
  //       _moduleRepository.getModuleById("PIN").then((module) {
  //         CommonUtils.navigateToRoute(
  //             context: context,
  //             widget: DynamicWidget(
  //               moduleItem: module,
  //             ));
  //       });
  //     } else {
  //       AlertUtil.showAlertDialog(context, value.message ?? "Error");
  //     }
  //   });
  // }
}
