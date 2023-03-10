import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:vibration/vibration.dart';

import '../other/base_screen.dart';
import '../other/common_widget.dart';
import 'login_screen.dart';

class OTPVerification extends StatefulWidget {
  OTPVerification({Key? key, required this.mobileNumber}) : super(key: key);
  String mobileNumber;

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> with CodeAutoFill {
  final _authRepository = AuthRepository();
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool isLoading = false;
  String? appSignature;
  String? otpCode;

  @override
  void codeUpdated() {
    setState(() {
      otpCode = code!;
    });
  }

  @override
  void initState() {
    super.initState();
    listenForCode();

    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        debugPrint("App signature...$signature");
        appSignature = signature;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: ListView(
          children: [
            AppBar(title: const Text("Activation"),
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
              child:                           Label(
                text: "OTP",
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20.0),
              child:                           Label(
                text: "Please enter the One-Time Password\nsent to Your Mobile Number or Email",
                fontSize: 12,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: PinFieldAutoFill(
                          controller: _otpController,
                          decoration: BoxLooseDecoration(
                              gapSpace: 8,
                              bgColorBuilder:
                                  FixedColorBuilder(Colors.grey[200]!),
                              strokeColorBuilder:
                                  const FixedColorBuilder(Colors.transparent)),
                          currentCode: otpCode,
                          onCodeSubmitted: (code) {},
                          onCodeChanged: (code) {
                            if (code!.length == 6) {
                              FocusScope.of(context).requestFocus(FocusNode());
                            }
                          },
                        )),
                    const SizedBox(
                      height: 58,
                    ),
                    isLoading
                        ? Center(
                            child:
                                Lottie.asset("assets/lottie/loading.json"))
                        : SizedBox(
                      height: 40,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: const BorderSide(color: Color.fromRGBO(138, 29, 92, 1)))),
                            backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(138, 29, 92, 1)),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              verifyOTP();
                            }
                          },
                          child: const Text('Verify'),
                        ),
                      )
                    )
                  ],
                ))
          ]),
    );
  }

  verifyOTP() {
    String msg;
    if (_formKey.currentState!.validate()) {
      if (_otpController.text.length == 6) {
        setState(() {
          isLoading = true;
        });
        _authRepository
            .verifyOTP(
                mobileNumber: widget.mobileNumber, otp: _otpController.text)
            .then((value) async => {
                  if (value.status == StatusCode.success.statusCode)
                    {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                          (r) => false)
                    }
                  else
                    {
                      msg = value.message ?? "Unknown error",
                      AlertUtil.showAlertDialog(
                          context, msg.isNotEmpty ? msg : "Error")
                    },
                  setState(() {
                    isLoading = false;
                  })
                });
      } else {
        Vibration.vibrate();
        Fluttertoast.showToast(
            msg: "Enter correct OTP!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }
}
