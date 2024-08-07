import 'package:brac_mobile/src/auth/extensions.dart';
import 'package:brac_mobile/src/home/reciept.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
//import 'package:no_screenshot/no_screenshot.dart';

import '../other/numberFormatter.dart';
import '../theme/app_theme.dart';

class DataPurchase extends StatefulWidget {
  final String ID;
  final String mobile;
  final String amount;
  final String category;
  final String description;

  const DataPurchase({
    required this.ID,
    required this.mobile,
    required this.amount,
    required this.category,
    required this.description,
});

  @override
  State<DataPurchase> createState() => _DataPurchaseState();
}

class _DataPurchaseState extends State<DataPurchase> {
  final _bankRepository = BankAccountRepository();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isSubmitting = false;
  int totalAccounts = 0;
  List<BankAccount> bankAccounts = [];
  var _currentValue;
  var bankAcc;
  final _pinController = TextEditingController();
  bool isObscured = true;
  // final _noScreenshot = NoScreenshot.instance;

  @override
  void initState() {
    super.initState();
    // _noScreenshot.screenshotOff();
  }

  getBankAccounts() => _bankRepository.getAllBankAccounts();

  payData() {
    final _api_service = APIService();
    _api_service.dataPayment(
      widget.category,
      widget.ID,
      widget.mobile,
      bankAcc,
      widget.amount,
      CryptLib.encryptField(_pinController.text),
    ).then((value) {

      setState(() {
        isSubmitting = false;
      });

      if (value.status == StatusCode.success.statusCode) {

        CommonUtils.navigateToRoute(
            context: context,
            widget: TrxReceipt(
              recieptDetails: value.receiptDetails,
            ));
        setState(() {

        });
      }else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "Alert",
                style: TextStyle(
                    fontFamily: "Myriad Pro", color: primaryColor, fontWeight: FontWeight.bold),
              ),
              content: Text(
                value.message.toString(),
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
    });
  }


  @override
  Widget build(BuildContext context)  => AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Make the status bar transparent
      ),
      child: FutureBuilder<List<BankAccount>?>(
          future: getBankAccounts(),
          builder:
              (BuildContext context, AsyncSnapshot<List<BankAccount>?> snapshot) {
                Widget child = SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  child: Center(child: LoadUtil()),
                );
                if (snapshot.hasData) {
                  totalAccounts =
                      snapshot.data?.length ?? 0;
                  bankAccounts = snapshot.data ?? [];

                  var dropdownPicks = bankAccounts
                      .fold<Map<String, dynamic>>(
                      {},
                          (acc, curr) =>
                      acc
                        ..[curr.bankAccountId] =
                        curr.aliasName.isEmpty ? curr.bankAccountId : curr
                            .aliasName)
                      .entries
                      .map((item) =>
                      DropdownMenuItem(
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
                    bankAcc ??= dropdownPicks[0].value;
                  }
                  child = Scaffold(
                    body: Container(
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
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.07,
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
                                        )
                                    )
                                ),
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
                                      child: const Text("MTN Data",
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
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.032,
                            ),
                            SingleChildScrollView(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .height * 0.032,
                                            ),
                                            Container(
                                              width: double.infinity,
                                              child:  Card(
                                                margin: EdgeInsets.zero,
                                                color: Colors.white,
                                                elevation: 2,
                                                shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .zero),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .all(16.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      const Text(
                                                        'Data Bundle',
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal,
                                                            fontFamily: "Myriad Pro",
                                                            color: Colors
                                                                .grey),
                                                      ),
                                                      Text(
                                                        removeAmount(widget.description),
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold,
                                                            fontFamily: "Myriad Pro",
                                                            color: primaryColor),
                                                      ),
                                                      const SizedBox(
                                                          height: 8),
                                                      const Text(
                                                        'Amount',
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .normal,
                                                            fontFamily: "Myriad Pro",
                                                            color: Colors
                                                                .grey),
                                                      ),
                                                      Text(
                                                        formatAmount(
                                                            widget.amount
                                                                .toString()),
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold,
                                                            fontFamily: "Myriad Pro",
                                                            color: primaryColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            DropdownButtonFormField(
                                                decoration: const InputDecoration(
                                                  labelText: "Select Transaction Account",
                                                  labelStyle: TextStyle(fontSize: 12, fontFamily: "Mulish", color: Colors.black, fontWeight: FontWeight.bold),
                                                  hintStyle: TextStyle(fontSize: 12, fontFamily: "Mulish"),
                                                  contentPadding: EdgeInsets.symmetric(
                                                      vertical: 15.0, horizontal: 10.0),
                                                  hintText: 'Select an option',
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius
                                                        .zero,
                                                  ),
                                                ),
                                                iconEnabledColor: primaryColor,
                                                style: const TextStyle(
                                                  fontFamily: "Mulish",
                                                  fontWeight: FontWeight
                                                      .bold,
                                                  color: Colors.black,
                                                ),
                                                borderRadius: BorderRadius
                                                    .zero,
                                                value: _currentValue,
                                                items: dropdownPicks,
                                                onChanged: (value) {
                                                  _currentValue =
                                                      value.toString();
                                                  setState(() {
                                                    bankAcc =
                                                        value.toString();
                                                  });
                                                }),
                                            const SizedBox(
                                              height: 14,
                                            ),
                                            WidgetFactory.buildTextField(
                                              context,
                                              TextFormFieldProperties(
                                                isEnabled: true,
                                                isObscured: isObscured,
                                                controller: _pinController,
                                                textInputType: TextInputType
                                                    .number,
                                                inputDecoration: InputDecoration(
                                                  labelText: "PIN",
                                                  labelStyle: const TextStyle(fontSize: 12, fontFamily: "Mulish", color: Colors.black, fontWeight: FontWeight.bold),
                                                  hintStyle: const TextStyle(fontSize: 12, fontFamily: "Mulish"),
                                                  contentPadding: EdgeInsets.symmetric(
                                                      vertical: 15.0, horizontal: 10.0),
                                                  hintText: "Enter PIN",
                                                  suffixIconColor: primaryColor,
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                        isObscured
                                                            ? Icons
                                                            .visibility
                                                            : Icons
                                                            .visibility_off),
                                                    onPressed: () {
                                                      setState(() {
                                                        isObscured =
                                                        !isObscured;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                                  (value) {},
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
                                                payData();
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
                    ),);
                }
                return child;
              }
      )
  );
}

String removeAmount(String desc){
  RegExp regex = RegExp(r'for.*$');
  String result = desc.replaceAll(regex, '');
  
  return result;
}

String formatAmount(String amount){
  String formatedBal = formatCurrency(removeDecimalPointAndZeroes(amount));
  String wholeBal = formatedBal.split('.')[0];
  String finalAmount = "UGX $wholeBal";

  return finalAmount;
}

String removeDecimalPointAndZeroes(String value) {
  double parsedValue = double.tryParse(value) ?? 0.0;
  return parsedValue.toInt().toString();
}