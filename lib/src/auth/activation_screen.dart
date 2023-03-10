import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:flutter/material.dart';
import '../other/base_screen.dart';
import '../other/common_widget.dart';
import 'otp_screen.dart';

class ActivationScreen extends StatefulWidget {
  const ActivationScreen({super.key});

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authRepo = AuthRepository();
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) => BaseScreen(
    child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bk.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter
          ),
        ),
        child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            children: [
              const SizedBox(
                height: 50,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  //set border radius more than 50% of height and width to make circle
                ),
                elevation: 50,
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
                          Container(
                            margin: const EdgeInsets.only(left: 12.0),
                            child:                           Label(
                              text: "Input your login credentials",
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
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
                                            isObscured: false,
                                            controller: _phoneController,
                                            textInputType: TextInputType.number,
                                            inputDecoration:
                                            const InputDecoration(hintText: "Enter your phone number",
                                              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                                              hintStyle: TextStyle(fontSize: 12,
                                                  fontFamily: 'Mulish'),),
                                            boxDecoration: const BoxDecoration(
                                                shape: BoxShape.rectangle
                                            )),
                                            (value) {
                                          if (_phoneController.text.length < 10) {
                                            return "Please enter a valid phone number";
                                          }
                                        }),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    child: WidgetFactory.buildTextField(
                                        context,
                                        TextFormFieldProperties(
                                            isEnabled: true,
                                            isObscured: true,
                                            controller: _pinController,
                                            textInputType: TextInputType.number,
                                            inputDecoration:
                                            const InputDecoration(hintText: "Login PIN",
                                              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                                              hintStyle: TextStyle(fontSize: 12,
                                                  fontFamily: 'Mulish'),),
                                            boxDecoration: const BoxDecoration(
                                                shape: BoxShape.rectangle
                                            )),
                                            (value) {
                                          if (_pinController.text.length < 4) {
                                            return "Please enter a valid pin";
                                          }
                                        }),
                                  ),
                                  const SizedBox(
                                    height: 34,
                                  ),
                                  _isLoading
                                      ? const SizedBox(
                                    height: 12,
                                    child: CircularProgressIndicator(
                                      color: Color.fromRGBO(225, 0, 134, 1),
                                    ),
                                  )
                                      : SizedBox(
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
                                        if (_formKey.currentState!.validate()) {
                                          activateApp();
                                        }
                                      },
                                      child: const Text('Login'),
                                    ),
                                  ),
                                ],
                              )),
                          const SizedBox(
                            height: 18,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      )
                  ),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
            ])
    ),

  );

  activateApp() {
    setState(() {
      _isLoading = true;
    });
    _authRepo
        .activate(mobileNumber: _phoneController.text, pin: _pinController.text)
        .then((value) {
      setState(() {
        _isLoading = false;
      });

      if (value.status == StatusCode.success.statusCode) {
        CommonUtils.navigateToRoute(
            context: context,
            widget: OTPVerification(mobileNumber: _phoneController.text));
      } else {
        AlertUtil.showAlertDialog(context, value.message ?? "Error");
      }
    });
  }

  void _showAlert(BuildContext context, String string) {
    final alert = AlertDialog(
      content: Text(string),
      contentPadding: const EdgeInsets.all(26.0),
      backgroundColor: const Color.fromRGBO(138, 29, 92, 1),
      contentTextStyle: const TextStyle(
        fontSize: 12,
        fontFamily: "Mulish",
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
        });
        return alert;
      },
    );
  }
}
