import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../other/base_screen.dart';
import '../other/common_widget.dart';

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

  @override
  void initState() {
    super.initState();
    _currentValue = widget.accounts;
    checkMiniStatement(_currentValue);
  }


  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/trx_bk2.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      'assets/images/back2.png',
                      height: 30,
                      width: 30,
                    ),
                    const Text("Home",
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: "Mulish",
                          color: Colors.white
                      ),),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text("Mini Statement",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Mulish",
                    color: Colors.white,
                    fontSize: 30
                ),),
              const SizedBox(
                height: 24,
              ),
              _isLoading
                  ? const Center(
                child: SizedBox(
                  height: 12,
                  child: CircularProgressIndicator(
                    color: Color.fromRGBO(225, 0, 134, 1),
                  ),
                ),) // show a progress indicator while loading
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
    _accountRepository.checkMiniStatement(bankAccountId).then((value) {
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
    return ListView.separated(
      itemCount: transactionList.length,
      itemBuilder: (BuildContext context, index) {
        Color textColor =
        transactionList[index].trxType == "DR" ? Colors.green : Colors.red;
        return Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Date: ${transactionList[index].formattedDate()}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(transactionList[index].narration),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Amount"),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(transactionList[index].amount,
                        style: TextStyle(fontWeight: FontWeight.bold,
                        color: textColor))
                  ],
                )
              ],
            ));
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  addTransactions({required list}) {
    list.forEach((item) {
      transactionList.add(Transaction.fromJson(item));
    });
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
