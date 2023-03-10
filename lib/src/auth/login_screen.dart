import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/database.dart';
import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:flutter/material.dart';
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

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    SessionRepository().startSession();
  }

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
            padding: const EdgeInsets.symmetric(horizontal: 12),
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
                              text: "Input your login PIN",
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
                                            return "Please enter a valid PIN";
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
                                          login();
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
                          Center(
                            child: Label(
                              text: "Forgot Pin?",
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              textColor: Color.fromRGBO(138, 29, 92, 1),
                            ),
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

              Center(
                child: Label(
                  text: "Not Registered? Sign Up here",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  textColor: Color.fromRGBO(138, 29, 92, 1),
                ),
              )
            ])
    ),
  );

  login() {
    setState(() {
      _isLoading = true;
    });
    _authRepo.login(_pinController.text).then((value) {
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
              ));
        });
      }else {
        AlertUtil.showAlertDialog(context, value.message ?? "Error");
      }
    });
  }
}
