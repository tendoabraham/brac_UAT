import 'package:brac_mobile/src/auth/extensions.dart';
import 'package:brac_mobile/src/home/success_view.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:contact_picker_platform_interface/contact_picker_platform_interface.dart';
import 'package:fluttercontactpicker/src/interface.dart';

import '../other/base_screen.dart';
import '../theme/app_theme.dart';

class AddBeneficiary extends StatefulWidget {
  const AddBeneficiary({Key? key}) : super(key: key);

  @override
  State<AddBeneficiary> createState() => _AddBeneficiaryState();
}

class _AddBeneficiaryState extends State<AddBeneficiary> {
  BillerName? selectedBillerName;
  BillerType? selectedBillerType;
  String selectedBiller = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isSubmitting = false;
  bool isMMoney = false;
  bool isLoading = true;
  TextEditingController accountController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController aliasController = TextEditingController();
  List<BillerType> billerTypes = [];
  List<BillerName> billerNames = [];

  @override
  void initState() {
    getBillerTypes();
    super.initState();
  }

  getBillerTypes() {
    final _api_service = APIService();
    _api_service.getBillerTypes().then((value) {
      setState(() {
        isLoading = false;
      });
      if (value.status == StatusCode.success.statusCode) {

        var filteredList = value.dynamicList!
            .where((item) => item['RelationID'] != 'MMoney')
            .toList();
        setState(() {
          billerTypes = filteredList
              .map((item) => BillerType.fromJson(item))
              .toList();
        });
      } else {
        _showDialogue(value.message.toString());
      }
    });
  }

  getBillerNames(String billerType) {
    final _api_service = APIService();
    _api_service.getBillerNames(billerType).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value.status == StatusCode.success.statusCode) {
        setState(() {
          billerNames = value.dynamicList!
              .map((item) => BillerName.fromJson(item))
              .toList();
        });
      } else {
        _showDialogue(value.message.toString());
      }
    });
  }

  saveBen(String billerType, String billerName, String alias, String account) {
    final _api_service = APIService();
    _api_service.saveBen(billerType, billerName, alias, account).then((value) {
      if (value.status == StatusCode.success.statusCode) {
        CommonUtils.navigateToRoute(
            context: context,
            widget: SuccessView(message: value.message.toString()));
        setState(() {
          isSubmitting = false;
        });
      } else {
        _showDialogue(value.message.toString());
      }
    });
  }

  void showCustomSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3), // Adjust the duration as needed
      ),
    );
  }


  _showDialogue(String message){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Alert",
            style: TextStyle(
                fontFamily: "Myriad Pro", fontWeight: FontWeight.bold),
          ),
          content: Text(
            message,
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
              },
            ),
          ],
        );
      },
    );
  }

  pickPhoneContact() async {
    final PhoneContact contact = await FlutterContactPicker.pickPhoneContact();
    setState(() {
      phoneController.text = formatPhone(contact.phoneNumber?.number ?? "")
          .replaceAll(RegExp(r'^0'), '');
    });
  }

  String formatPhone(String phone) {
    return phone.replaceAll(RegExp(r'\+\d{1,3}'), '');
  }

  @override
  Widget build(BuildContext context)  => AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Make the status bar transparent
      ),
      child:  Scaffold(
        body: ModalProgressHUD(
            inAsyncCall:
                isLoading, // Set this variable to true when you want to show the loading indicator
            opacity:
                0.5, // Customize the opacity of the background when the loading indicator is displayed
            progressIndicator: LoadUtil(),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/trx_bk2.png'),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.zero,
                                  child: Image.asset(
                                    'assets/images/back2.png',
                                    height: 30,
                                    width: 30,
                                  ),
                                )
                            )
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: IntrinsicWidth(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text("Add Beneficiary",
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: "Mulish",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20
                                ),),
                            ),
                          ),),
                        SizedBox(
                          width: 40,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.032,
                    ),
                    Expanded(child: SizedBox(
                        height: double.infinity,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        DropdownButtonFormField<BillerType>(
                                          decoration: const InputDecoration(
                                            labelText: 'Select a BillerType',
                                            labelStyle: TextStyle(fontSize: 12, fontFamily: "Mulish", color: Colors.black, fontWeight: FontWeight.bold),
                                            hintText: 'BillerType',
                                            hintStyle: TextStyle(fontSize: 12, fontFamily: "Mulish"),
                                            contentPadding: EdgeInsets.symmetric(
                                                vertical: 15.0, horizontal: 10.0),
                                          ),
                                          value:
                                          selectedBillerType, // Provide the currently selected value (can be null initially)
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedBillerType = newValue;
                                              selectedBillerName = null;
                                              accountController.text = "";
                                              aliasController.text = "";
                                              getBillerNames(
                                                  selectedBillerType!.relationID);
                                              isLoading = true;
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Please select an option';
                                            }
                                            return null;
                                          },
                                          items: billerTypes.map((BillerType item) {
                                            return DropdownMenuItem<BillerType>(
                                              value: item,
                                              child: Text(
                                                item.description,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: "Mulish",
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        const SizedBox(
                                          height: 14,
                                        ),
                                        DropdownButtonFormField<BillerName>(
                                          decoration: const InputDecoration(
                                            labelText: 'Select a BillerName',
                                            labelStyle: TextStyle(fontSize: 12, fontFamily: "Mulish", color: Colors.black, fontWeight: FontWeight.bold),
                                            hintText: 'BillerName',
                                            hintStyle: TextStyle(fontSize: 12, fontFamily: "Mulish"),
                                            contentPadding: EdgeInsets.symmetric(
                                                vertical: 15.0, horizontal: 10.0),
                                          ),
                                          value:
                                          selectedBillerName, // Provide the currently selected value (can be null initially)
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedBillerName = newValue;
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Please select an option';
                                            }
                                            return null;
                                          },
                                          items: billerNames.map((BillerName item) {
                                            return DropdownMenuItem<BillerName>(
                                              value: item,
                                              child: Text(
                                                item.description,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: "Mulish",
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        const SizedBox(
                                          height: 14,
                                        ),
                                        TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: accountController,
                                          onChanged: (value) {
                                            setState(() {
                                              accountController.text = value;
                                            });
                                          },
                                          decoration: const InputDecoration(
                                            labelText: 'Beneficiary Number',
                                            labelStyle: TextStyle(fontSize: 12, fontFamily: "Mulish", color: Colors.black, fontWeight: FontWeight.bold),
                                            hintText: 'Beneficiary Number',
                                            hintStyle: TextStyle(fontSize: 12, fontFamily: "Mulish"),
                                            contentPadding:
                                            EdgeInsets.symmetric(
                                                vertical: 15.0,
                                                horizontal: 10.0),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter the account number';
                                            }
                                            return null;
                                          },
                                          // onChanged and initialValue can be added as needed
                                        ),
                                        const SizedBox(
                                          height: 14,
                                        ),
                                        TextFormField(
                                          keyboardType: TextInputType.text,
                                          controller: aliasController,
                                          onChanged: (value) {
                                            setState(() {
                                              print(value);
                                            });
                                          },
                                          decoration: const InputDecoration(
                                            labelText: 'Beneficiary Name',
                                            labelStyle: TextStyle(fontSize: 12, fontFamily: "Mulish", color: Colors.black, fontWeight: FontWeight.bold),
                                            hintText: 'Beneficiary Name',
                                            hintStyle: TextStyle(fontSize: 12, fontFamily: "Mulish"),
                                            contentPadding:
                                            EdgeInsets.symmetric(
                                                vertical: 15.0,
                                                horizontal: 10.0),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter the Beneficiary Name';
                                            }
                                            return null;
                                          },
                                          // onChanged and initialValue can be added as needed
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        isSubmitting
                                            ? LoadUtil()
                                            : WidgetFactory.buildButton(
                                            context, () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            saveBen(
                                                selectedBillerType!
                                                    .relationID,
                                                selectedBillerName!
                                                    .subCodeID,
                                                aliasController.text,
                                                accountController.text);
                                            setState(() {
                                              isSubmitting = true;
                                            });
                                          }
                                        }, "Save Beneficiary",
                                            color: primaryColor),
                                      ],
                                    )),
                              ],
                            ))))
                  ],
                ),
              ),
            ),))
    );

}

class BillerType {
  final String description;
  final String relationID;

  BillerType({required this.description, required this.relationID});

  factory BillerType.fromJson(Map<String, dynamic> json) {
    return BillerType(
      description: json['Description'],
      relationID: json['RelationID'],
    );
  }
}

class BillerName {
  final String description;
  final String subCodeID;

  BillerName({required this.description, required this.subCodeID});

  factory BillerName.fromJson(Map<String, dynamic> json) {
    return BillerName(
      description: json['Description'],
      subCodeID: json['SubCodeID'],
    );
  }
}
