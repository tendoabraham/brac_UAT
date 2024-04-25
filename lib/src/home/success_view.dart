import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../home/home_screen.dart';
import '../theme/app_theme.dart';

class SuccessView extends StatefulWidget {
  final String message;

  const SuccessView({Key? key, required this.message}) : super(key: key);

  @override
  _SuccessViewState createState() => _SuccessViewState();
}

class _SuccessViewState extends State<SuccessView> {
  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Make the status bar transparent
      ),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              // Transparent card
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     Row(
                      children: [
                        Spacer(),
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            color: primaryColor,
                            size: 35,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 12),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Image(
                        image: AssetImage("assets/images/success.png"),
                        width: 80,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Dear customer, ${widget.message}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontFamily: "Mulish",
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 35),
                    SizedBox(
                      width: 180, // Set the width as desired
                      height: 45, // Set the height as desired
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(primaryColor),
                        ),
                        child: const Text(
                          "Done",
                          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Mulish",),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ));
}
