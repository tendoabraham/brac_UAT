import 'package:brac_mobile/src/auth/extensions.dart';
import 'package:brac_mobile/src/theme/app_theme.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:no_screenshot/no_screenshot.dart';

import '../other/base_screen.dart';
import '../other/common_widget.dart';
import '../other/numberFormatter.dart';

class MiniStatementScreen extends StatefulWidget {
  final String accounts;

  MiniStatementScreen({required this.accounts});


  @override
  State<StatefulWidget> createState() => _MiniStatementScreenState();
}

class _MiniStatementScreenState extends State<MiniStatementScreen> {
  bool _isLoading = true;
  final _accountRepository = ProfileRepository();
  var _currentValue, ministatement;
  bool querySuccess = false;
  bool showTransactionList = false;
  // final _noScreenshot = NoScreenshot.instance;

  @override
  void initState() {
    super.initState();
    // _noScreenshot.screenshotOff();
    _currentValue = widget.accounts;
    checkMiniStatement(_currentValue);
  }


  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bk4.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mini Statement',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: primaryColor,
                        fontFamily: "Mulish",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                        ),
                        child: const Icon(
                          Icons.close,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 1.0, // Line height
                color: Colors.grey[300], // Line color
              ),
              const SizedBox(
                height: 20,
              ),
              _isLoading
                  ? Center(
                child: LoadUtil(),) // show a progress indicator while loading
                  : showTransactionList // show the transaction list if available
                  ? Expanded(child: TransactionsList(miniStatement: ministatement))
                  : const SizedBox()
            ],
          )
      ),
    );
  }
  void checkMiniStatement(String bankAccountId) {
    setState(() {
      _isLoading = true;
    });
    final _api_service = APIService();
    _api_service.checkMiniStmnt(bankAccountID: bankAccountId).then((value) {
      setState(() {
        _isLoading = false;
      });
      if (value?.status == StatusCode.success.statusCode) {
        setState(() {
          showTransactionList = true;
          if (value?.accountStatement != null) { // check if the statement is not empty
            querySuccess = true;
            ministatement = value?.accountStatement;
          } else {
            querySuccess = false;
            ministatement = null;
          }
        });
      } else {
        AlertUtil.showAlertDialog(context, value?.message ?? "Error");
      }
    });
  }
}

class TransactionsList extends StatelessWidget {
  List<dynamic> miniStatement = [];
  List<Transaction> transactionList = [];

  TransactionsList({required this.miniStatement});

  @override
  Widget build(BuildContext context) {
    addTransactions(list: miniStatement);
    return ListView.builder(
      itemCount: transactionList.length,
      itemBuilder: (BuildContext context, index) {
        Color textColor =
        transactionList[index].trxType == "DR" ? Colors.green : Colors.red;

        return Card(
          margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date: ${transactionList[index].date}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0,
                          fontFamily: "Mulish",
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        transactionList[index].narration,
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.grey[600],
                          fontFamily: "Mulish",
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Amount",
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.grey[600],
                          fontFamily: "Mulish",
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        formatAmount(transactionList[index].amount),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: textColor,
                          fontFamily: "Mulish",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  addTransactions({required list}) {
    list.forEach((item) {
      transactionList.add(Transaction.fromJson(item));
    });
  }
  
  formatAmount(String amount){
    String formatedBal = formatCurrency(amount);
    String wholeBal = formatedBal.split('.')[0];
    String _balance = "UGX $wholeBal";
    return _balance;
  }
}


class Transaction {
  String date;
  String amount;
  String narration;
  String trxType;

  Transaction({required this.date, required this.amount, required this.narration, required this.trxType});

  Transaction.fromJson(Map<String, dynamic> json)
      : date = json["Date"],
        amount = json["Amount"],
        narration = json['Narration'],
        trxType = json['TransType'];

  String formattedDate() {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(date));
    final formatter = DateFormat.yMd().add_jm();
    return formatter.format(dateTime);
  }
}
