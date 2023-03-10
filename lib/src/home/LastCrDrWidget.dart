import 'package:blur/blur.dart';
import 'package:brac_mobile/src/auth/extensions.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LastCrDr extends StatefulWidget {
  LastCrDr({super.key});

  @override
  State<StatefulWidget> createState() => LastCrDrState();
  }

class LastCrDrState extends State<LastCrDr>{
  final _accountRepository = ProfileRepository();
  var _lastCr = "not available";
  var _lastDr = "not available";
  var _accountVisible = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          //set border radius more than 50% of height and width to make circle
        ),
        elevation: 5,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        child: Padding(padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            child: Column(
              children: [
                const SizedBox(
                  height: 2,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 18,
                      child: Padding(
                        padding: EdgeInsets.only(top: 2.0), // Add 8 pixels of top padding
                        child: Image(
                          image: AssetImage('assets/images/circle1.png'),
                          fit: BoxFit.cover,
                          alignment: Alignment.topRight,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        const Text("Last Credit",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontFamily: "Mulish",
                                fontWeight: FontWeight.bold
                            )),
                        _accountVisible
                            ? Text(_lastCr,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: "Mulish",
                                fontWeight: FontWeight.bold
                            ))  : const Blur(
                            blur: 3,
                            blurColor: Color.fromRGBO(138, 29, 92, 1),
                            child: Padding(
                                padding:
                                EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                child: Text("XXXXXXX",
                                  style: TextStyle(
                                      fontFamily: "Mulish"
                                  ),))),
                      ],
                    ),),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                      child: SizedBox(
                        height: 50,
                        child: VerticalDivider(
                          width: 2,
                          color: Colors.grey.shade400,
                        ),
                      ),),
                    const SizedBox(
                      height: 18,
                      child: Padding(
                        padding: EdgeInsets.only(top: 2.0), // Add 8 pixels of top padding
                        child: Image(
                          image: AssetImage('assets/images/circle2.png'),
                          fit: BoxFit.cover,
                          alignment: Alignment.topRight,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        const Text("Last Debit",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontFamily: "Mulish",
                                fontWeight: FontWeight.bold
                            )),
                        _accountVisible
                            ? Text(_lastDr,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: "Mulish",
                                fontWeight: FontWeight.bold
                            )) : const Blur(
                            blur: 3,
                            blurColor: Color.fromRGBO(138, 29, 92, 1),
                            child: Padding(
                                padding:
                                EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                child: Text("XXXXXXX",
                                  style: TextStyle(
                                      fontFamily: "Mulish"
                                  ),))),
                      ],
                    ),),
                  ],
                ),
                const SizedBox(
                    height: 5),
                          _isLoading
                              ? const SizedBox(
                            height: 12,
                            child: CircularProgressIndicator(
                              color: Color.fromRGBO(225, 0, 134, 1),
                            ),
                          )
                    :
                Center(
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        _isLoading = true;
                      });

                      final _api_service = APIService();
                      _api_service.checkRecentCrDr()
                      // _accountRepository.checkRecentCrDr()
                          .then((value) {
                        if (value != null) {
                          if (value.status == StatusCode.success.statusCode) {

                            final response = value.dynamicList;
                            final amounts = response?.first["Amount"].split("|");

                            _lastCr = amounts[1]; // this will be "0"
                            _lastDr = amounts[3]; // this will be "2,000.00"

                            setState(() {
                              _accountVisible = !_accountVisible;
                              _isLoading = false;
                            });

                          } else {
                            AlertUtil.showAlertDialog(
                                context, value.message ?? "Error");
                          }
                        }
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center aligns the children horizontally
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _accountVisible
                          ? "Hide Details" : "View Details",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromRGBO(138, 29, 92, 1),
                            fontFamily: "Mulish",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _accountVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                          color: const Color.fromRGBO(138, 29, 92, 1),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),);
  }
}