import 'dart:ui';
import 'package:blur/blur.dart';
import 'package:brac_mobile/src/home/ministatement_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:craft_dynamic/database.dart';
import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:flutter/material.dart';

import 'package:craft_dynamic/craft_dynamic.dart';

class AccountWidget extends StatefulWidget {
  @override
  AccountWidgetState createState() => AccountWidgetState();
}

class AccountWidgetState extends State<AccountWidget> {
  final _bankRepository = BankAccountRepository();

  // AccountWidgetState({super.key});

  getBankAccounts() => _bankRepository.getAllBankAccounts();
  final CarouselController _controller = CarouselController();

  int? currentIndex = 0;

  @override
  Widget build(BuildContext context) => FutureBuilder<List<BankAccount>>(
      future: getBankAccounts(),
      builder:
          (BuildContext context, AsyncSnapshot<List<BankAccount>> snapshot) {
        Widget child = SizedBox(
          height: 200,
          child: Center(child: LoadUtil()),
        );
        if (snapshot.hasData) {
          int? count = snapshot.data?.length;
          child = SizedBox(
            height: 210,
            child: Column(
              children: [
                Expanded(child: CarouselSlider.builder(
                  carouselController: _controller,
                  itemCount: snapshot.data?.length,
                  itemBuilder:
                      (BuildContext context, int itemIndex, int pageViewIndex) =>
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Card(
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
                                  alignment: Alignment.topCenter
                              ),
                            ),
                            child: AccountCard(
                              bankAccount: snapshot.data![itemIndex],
                            ),
                          ),
                        ),
                      ),
                  options: CarouselOptions(
                    disableCenter: false,
                    autoPlay: false,
                    enlargeCenterPage: true,
                    viewportFraction: .95,
                    aspectRatio: 2.0,
                    initialPage: 0,
                    scrollDirection: Axis.horizontal,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      }); // Rebuild the widget to update the slide indicator
                    },),
                ),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (count != null) // Check that count is not null
                      for (int i = 0; i < count; i++)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.fiber_manual_record,
                            size: currentIndex == i ? 12 : 8,
                            color: currentIndex == i ? const Color.fromRGBO(138, 29, 92, 1) : Colors.grey,
                          ),
                        ),
                  ],
                ),
              ],
            )
          );
        }
        return child;
      });
}

class AccountCard extends StatefulWidget {
  final BankAccount bankAccount;

  const AccountCard({super.key, required this.bankAccount});

  @override
  State<StatefulWidget> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  bool _isLoading = false;
  var _accountVisible = false;
  var _balance = "Not available";
  final _accountRepository = ProfileRepository();


  @override
  Widget build(BuildContext context) {
    final bankAccount = widget.bankAccount;

    String bankAccountID = bankAccount.bankAccountId;
    String maskedNumber = "${bankAccountID.substring(0,1)}XXXXXXX${bankAccountID.substring(8)}";

    return Center(
      child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
          ),
          child: Stack(
            children: [
              Container(
                  height: 200,
                  decoration: const BoxDecoration(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                          margin: const EdgeInsets.only(left: 4.0),
                          child: const Text("Available Balance",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontFamily: "Mulish",
                                fontWeight: FontWeight.bold
                            )),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 4.0),
                        child:
                          Text(maskedNumber,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 13, fontFamily: "Mulish",
                                  fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 4.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _accountVisible = !_accountVisible;
                            });

                            if (_accountVisible) {
                              _isLoading = true;
                              _accountRepository
                                  .checkAccountBalance(bankAccount.bankAccountId)
                                  .then((value) {
                                setState(() {
                                  _isLoading = false;
                                });
                                if (value != null) {
                                  if (value.status == StatusCode.success.statusCode) {
                                    _balance = value.resultsData
                                        ?.firstWhere(
                                            (e) => e["ControlID"] == "BALTEXT")[                    "ControlValue"] ??
                                        "Not available";
                                  } else {
                                    AlertUtil.showAlertDialog(
                                        context, value.message ?? "Error");
                                  }
                                }
                              });
                            }
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Show Balance",
                                style: TextStyle(
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
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: _accountVisible
                            ? Text(
                          _balance,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Mulish"),
                        )
                            : const Blur(
                            blur: 3,
                            blurColor: Color.fromRGBO(138, 29, 92, 1),
                            child: Padding(
                                padding:
                                EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                child: Text("XXXXXXX",
                                  style: TextStyle(
                                      fontFamily: "Mulish"
                                  ),))),
                      ),
                      Expanded(child: GestureDetector(
                        onTap: (){
                          AlertUtil.showAlertDialog(context,
                              "Continue to view account ministatement",
                              isConfirm: true)
                              .then((value) {
                            if (value) {
                              checkMiniStatement();
                            }
                          });
                        },
                        child: Row(
                          children: const [
                            Icon(
                              Icons.library_books_sharp,
                              size: 24,
                              color: Color.fromRGBO(138, 29, 92, 1),
                            ),
                            SizedBox(width: 8), // add some spacing between the Icon and Text
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Mini Statement",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Mulish",
                                  fontSize: 12,
                                  color: Color.fromRGBO(138, 29, 92, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                    ],
                  )),
              _isLoading
                  ? ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 0.6, sigmaY: 0.6),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                              color: Colors.transparent),
                        ),
                      ),
                    )
                  : const SizedBox(),
              _isLoading
                  ? const Positioned(
                      right: 0,
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: SizedBox(
                          height: 24,
                          width: 24,
                          child: Center(child: SizedBox(
                            height: 12,
                            child: CircularProgressIndicator(
                              color: Color.fromRGBO(225, 0, 134, 1),
                            ),
                          ))),
                    )
                  : const SizedBox()
            ],
          )),
    );
  }

  checkMiniStatement() {
    CommonUtils.navigateToRoute(
        context: context, widget: MiniStatementScreen(accounts: widget.bankAccount.bankAccountId,));
    // setState(() {
    //   _isLoading = true;
    // });
    // _accountRepository
    //     .checkMiniStatement(widget.bankAccount.bankAccountId)
    //     .then((value) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   if (value?.status == StatusCode.success.statusCode) {
    //
    //   } else {
    //     AlertUtil.showAlertDialog(context, value?.message ?? "Error");
    //   }
    // });
  }
}
