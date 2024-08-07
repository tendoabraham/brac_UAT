import 'package:brac_mobile/src/auth/extensions.dart';
import 'package:brac_mobile/src/home/Data_Purchase.dart';
import 'package:brac_mobile/src/home/success_view.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:contact_picker_platform_interface/contact_picker_platform_interface.dart';
import 'package:fluttercontactpicker/src/interface.dart';
////import 'package:no_screenshot/no_screenshot.dart';

import '../theme/app_theme.dart';

class Data extends StatefulWidget {
  const Data({Key? key}) : super(key: key);

  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {
  DataBundle? selectedDataBundle;
  DataFreq? selectedDataFreq;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isSubmitting = false;
  bool isLoading = true;
  TextEditingController accountController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController aliasController = TextEditingController();
  List<DataFreq> DataFreqs = [];
  List<DataBundle> DataBundles = [];
  String _selectedDirection = 'Beneficiary';
  final _benRepository = BeneficiaryRepository();
  List<Beneficiary> beneficiaries = [];
  getBeneficiaries() => _benRepository.getBeneficiariesByMerchantID("MTNDB");
  int totalBens = 0;
  var ben;
  var _currentValue;
  bool isBenSelected = true;
  var selectedBeneficiary;
  // final _noScreenshot = NoScreenshot.instance;

  @override
  void initState() {
    // _noScreenshot.screenshotOff();
    getDataFreqs();
    super.initState();
  }

  getDataFreqs() {
    final _api_service = APIService();
    _api_service.getDataFreqs().then((value) {
      setState(() {
        isLoading = false;
      });
      if (value.status == StatusCode.success.statusCode) {
        var filteredList = value.dynamicList!
            .where((item) => item['RelationID'] != 'MMoney')
            .toList();
        setState(() {
          DataFreqs =
              filteredList.map((item) => DataFreq.fromJson(item)).toList();
        });
      } else {
        _showDialogue(value.message.toString());
      }
    });
  }

  getDataBundles(String DataFreq) {
    final _api_service = APIService();
    _api_service.getDataBundles(DataFreq).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value.status == StatusCode.success.statusCode) {
        setState(() {
          DataBundles = value.dynamicList!
              .map((item) => DataBundle.fromJson(item))
              .toList();
        });
      } else {
        _showDialogue(value.message.toString());
      }
    });
  }

  valData(String ID, String category, String mobile, String description) {
    final _api_service = APIService();
    _api_service.dataValidation(category, ID, mobile).then((value) {
      if (value.status == StatusCode.success.statusCode) {
        List? results = value.display;
        String amount = results?[0]['BillAmount'];

        CommonUtils.navigateToRoute(
            context: context,
            widget: DataPurchase(
              ID: ID,
              category: category,
              mobile: mobile,
              amount: amount,
              description: description,
            ));
        setState(() {
          isSubmitting = false;
        });
      } else {
        _showDialogue(value.message.toString());
        setState(() {
          isSubmitting = false;
        });
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

  _showDialogue(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Alert",
            style: TextStyle(fontFamily: "Mulish", fontWeight: FontWeight.bold),
          ),
          content: Text(
            message,
            style: TextStyle(
              fontFamily: "Mulish",
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
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Make the status bar transparent
      ),
      child: FutureBuilder<List<Beneficiary>?>(
          future: getBeneficiaries(),
          builder: (BuildContext context,
              AsyncSnapshot<List<Beneficiary>?> snapshot) {
            Widget child = SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Center(child: LoadUtil()),
            );
            if (snapshot.hasData) {
              totalBens = snapshot.data?.length ?? 0;
              beneficiaries = snapshot.data ?? [];


              var dropdownPicks = beneficiaries
                  .fold<Map<String, dynamic>>(
                      {},
                      (acc, curr) => acc
                        ..[curr.accountID] = curr.accountAlias.isEmpty
                            ? curr.accountID
                            : curr.accountAlias)
                  .entries
                  .map((item) => DropdownMenuItem(
                        value: item.key,
                        child: Text(
                          item.value,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontFamily: "Mulish",
                          ),
                        ),
                      ))
                  .toList();
              dropdownPicks.toSet().toList();
              if (dropdownPicks.isNotEmpty) {
                _currentValue = dropdownPicks[0].value;
                ben ??= dropdownPicks[0].value;
              }
              child = Scaffold(
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
                        alignment: Alignment.topCenter),
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
                                onTap: () {
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
                                    ))),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: IntrinsicWidth(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    "MTN Data",
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Mulish",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 40,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.032,
                        ),
                        SingleChildScrollView(
                            padding:
                            EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _selectedDirection =
                                                    'Beneficiary';
                                                  });
                                                },
                                                style: ElevatedButton
                                                    .styleFrom(
                                                  primary: _selectedDirection ==
                                                      'Beneficiary'
                                                      ? primaryColor
                                                      : Colors
                                                      .white, // Use primary color for active button
                                                  shape:
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        8.0), // Reduce border radius
                                                    side: BorderSide(
                                                        color:
                                                        primaryColor), // Solid line border of primary color
                                                  ),
                                                ),
                                                child: Text(
                                                  'Select Beneficiary',
                                                  style: TextStyle(
                                                    color: _selectedDirection ==
                                                        'Beneficiary'
                                                        ? Colors.white
                                                        : primaryColor, // Change text color based on _selectedDirection
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 7),
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _selectedDirection =
                                                    'Other';
                                                  });
                                                },
                                                style: ElevatedButton
                                                    .styleFrom(
                                                  primary: _selectedDirection ==
                                                      'Beneficiary'
                                                      ? Colors.white
                                                      : primaryColor, // Use primary color for active button
                                                  shape:
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        8.0), // Reduce border radius
                                                    side: BorderSide(
                                                        color:
                                                        primaryColor), // Solid line border of primary color
                                                  ),
                                                ),
                                                child: Text(
                                                  'Others',
                                                  style: TextStyle(
                                                    color: _selectedDirection ==
                                                        'Beneficiary'
                                                        ? primaryColor
                                                        : Colors
                                                        .white, // Change text color based on _selectedDirection
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        DropdownButtonFormField<
                                            DataFreq>(
                                          decoration:
                                          const InputDecoration(
                                            labelText:
                                            'Select Data Frequency',
                                            labelStyle: TextStyle(
                                                fontSize: 12,
                                                fontFamily: "Mulish",
                                                color: Colors.black,
                                                fontWeight:
                                                FontWeight.bold),
                                            hintText: 'DataFreq',
                                            hintStyle: TextStyle(
                                                fontSize: 12,
                                                fontFamily: "Mulish"),
                                            contentPadding:
                                            EdgeInsets.symmetric(
                                                vertical: 15.0,
                                                horizontal: 10.0),
                                          ),
                                          value:
                                          selectedDataFreq, // Provide the currently selected value (can be null initially)
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedDataFreq =
                                                  newValue;
                                              selectedDataBundle = null;
                                              accountController.text =
                                              "";
                                              aliasController.text = "";
                                              getDataBundles(
                                                  selectedDataFreq!
                                                      .category);
                                              isLoading = true;
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Please select an option';
                                            }
                                            return null;
                                          },
                                          items: DataFreqs.map(
                                                  (DataFreq item) {
                                                return DropdownMenuItem<
                                                    DataFreq>(
                                                  value: item,
                                                  child: Text(
                                                    item.category,
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        fontFamily:
                                                        "Mulish",
                                                        fontWeight:
                                                        FontWeight
                                                            .bold),
                                                  ),
                                                );
                                              }).toList(),
                                        ),
                                        const SizedBox(
                                          height: 14,
                                        ),
                                        DropdownButtonFormField<
                                            DataBundle>(
                                          decoration:
                                          const InputDecoration(
                                            labelText:
                                            'Select a DataBundle',
                                            labelStyle: TextStyle(
                                                fontSize: 12,
                                                fontFamily: "Mulish",
                                                color: Colors.black,
                                                fontWeight:
                                                FontWeight.bold),
                                            hintText: 'DataBundle',
                                            hintStyle: TextStyle(
                                                fontSize: 12,
                                                fontFamily: "Mulish"),
                                            contentPadding:
                                            EdgeInsets.symmetric(
                                                vertical: 15.0,
                                                horizontal: 10.0),
                                          ),
                                          value:
                                          selectedDataBundle, // Provide the currently selected value (can be null initially)
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedDataBundle =
                                                  newValue;
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Please select an option';
                                            }
                                            return null;
                                          },
                                          items: DataBundles.map(
                                                  (DataBundle item) {
                                                return DropdownMenuItem<
                                                    DataBundle>(
                                                  value: item,
                                                  child: Text(
                                                    item.description,
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        fontFamily:
                                                        "Mulish",
                                                        fontWeight:
                                                        FontWeight
                                                            .bold),
                                                  ),
                                                );
                                              }).toList(),
                                        ),
                                        const SizedBox(
                                          height: 14,
                                        ),
                                        _selectedDirection == "Beneficiary" ?
                                        DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                            labelText: 'Select Beneficiary',
                                            labelStyle: TextStyle(fontSize: 12, fontFamily: 'Mulish', color: Colors.black, fontWeight: FontWeight.bold),
                                            hintStyle: TextStyle(fontSize: 12, fontFamily: 'Mulish'),
                                            contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                                            hintText: 'Select an option',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.zero,
                                            ),
                                          ),
                                          iconEnabledColor: Colors.black,
                                          style: TextStyle(fontSize: 12, fontFamily: 'Mulish', color: Colors.black, fontWeight: FontWeight.bold),
                                          value: selectedBeneficiary,
                                          items: beneficiaries.map<DropdownMenuItem<String>>((Beneficiary beneficiary) {
                                            return DropdownMenuItem<String>(
                                              value: beneficiary.accountID,
                                              child: Text(
                                                beneficiary.accountAlias.isNotEmpty ? beneficiary.accountAlias : beneficiary.accountID,
                                                style: TextStyle(fontSize: 12, color: Colors.black, fontFamily: 'Mulish'),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String? value) {
                                            setState(() {
                                              selectedBeneficiary = value!;
                                              print('Selected beneficiary: $selectedBeneficiary');
                                            });
                                          },
                                        ) :
                                        TextFormField(
                                          keyboardType:
                                          TextInputType.phone,
                                          controller: phoneController,
                                          onChanged: (value) {
                                            setState(() {
                                              phoneController.text =
                                                  value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            labelText: 'Mobile Number',
                                            labelStyle: const TextStyle(
                                                fontSize: 12,
                                                fontFamily: "Mulish",
                                                color: Colors.black,
                                                fontWeight:
                                                FontWeight.bold),
                                            hintText: 'Mobile Number',
                                            hintStyle: const TextStyle(
                                                fontSize: 12,
                                                fontFamily: "Mulish"),
                                            contentPadding:
                                            EdgeInsets.symmetric(
                                                vertical: 15.0,
                                                horizontal: 10.0),
                                            suffixIcon: IconButton(
                                                onPressed:
                                                pickPhoneContact,
                                                icon: const Icon(
                                                    Icons.contacts,
                                                    color:
                                                    primaryColor)),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter the phone number';
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
                                          if (_formKey
                                              .currentState!
                                              .validate()) {
                                            String mobile = "";
                                            if (_selectedDirection == "Beneficiary"){
                                              mobile = selectedBeneficiary;
                                            } else {
                                              mobile = phoneController
                                                  .text;
                                            }
                                            valData(
                                                selectedDataBundle!
                                                    .ID,
                                                selectedDataFreq!
                                                    .category,
                                                mobile,
                                                selectedDataBundle!
                                                    .description);
                                            setState(() {
                                              isSubmitting = true;
                                            });
                                          }
                                        }, "Submit",
                                            color: primaryColor),
                                      ],
                                    )),
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
              ));
            }
            return child;
          }));
}

class DataFreq {
  final String category;
  // final String relationID;

  DataFreq({required this.category});

  factory DataFreq.fromJson(Map<String, dynamic> json) {
    return DataFreq(
      category: json['Category'],
      // relationID: json['RelationID'],
    );
  }
}

class DataBundle {
  final String description;
  final String ID;

  DataBundle({required this.description, required this.ID});

  factory DataBundle.fromJson(Map<String, dynamic> json) {
    return DataBundle(
      description: json['Desciption'],
      ID: json['ID'],
    );
  }
}
