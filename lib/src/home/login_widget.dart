import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../other/app_state.dart';
import '../other/common_widget.dart';

final _pinController = TextEditingController();
final _phoneController = TextEditingController();

class LoginWidget extends StatelessWidget {
  LoginWidget({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool isActivation =
        Provider.of<AppState>(context, listen: false).showActivation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: isActivation
              ? "Activate your app to proceed."
              : "Enter your PIN to login to the app and do more.",
          fontSize: 22,
        ),
        const SizedBox(
          height: 18,
        ),
        Form(
            key: _formKey,
            child: Column(
              children: [
                isActivation
                    ? WidgetFactory.buildTextField(
                        context,
                        TextFormFieldProperties(
                            isEnabled: true,
                            controller: _phoneController,
                            textInputType: TextInputType.text,
                            inputDecoration:
                                const InputDecoration(hintText: "Enter Phone")),
                        (value) {
                        if (_phoneController.text.length < 8) {
                          return "Enter valid phone";
                        }
                      })
                    : const SizedBox(),
                isActivation
                    ? const SizedBox(
                        height: 18,
                      )
                    : const SizedBox(),
                WidgetFactory.buildTextField(
                    context,
                    TextFormFieldProperties(
                        isEnabled: true,
                        controller: _pinController,
                        textInputType: TextInputType.text,
                        inputDecoration:
                            const InputDecoration(hintText: "Enter PIN")),
                    (value) {
                  if (_pinController.text.length < 4) {
                    return "Enter a valid PIN";
                  }
                }),
                const SizedBox(
                  height: 18,
                ),
                WidgetFactory.buildButton(context, () {
                  if (_formKey.currentState!.validate()) {
                    isActivation ? activate() : login(context);
                  }
                }, isActivation ? "Activate" : "Login")
              ],
            ))
      ],
    );
  }

  login(context) {
    Provider.of<AppState>(context, listen: false).updateShowLogin(false);
  }

  activate() {}
}
