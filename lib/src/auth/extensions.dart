import 'dart:convert';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/cupertino.dart';
import '../other/LastCrDrModel.dart';


final _sharedPref = CommonSharedPref();

extension LastCrDr on APIService{

  Future<LastCrDrResponse?> checkRecentCrDr({formId = "DBCALL"}) async {
    var decrypted;
    LastCrDrResponse? lastCrDrResponse;
    Map<String, dynamic> innerMap = {};
    Map<String, dynamic> requestObj = {};
    innerMap["HEADER"] = "GETRECENTCREDITDEBIT";
    requestObj["DynamicForm"] = innerMap;

    final route = await _sharedPref.getRoute("other".toLowerCase());
    var res = await performDioRequest(
        await dioRequestBodySetUp(formId, objectMap: requestObj),
        route: route);

    try {
      decrypted = jsonDecode(res ?? "{}") ?? "{}";
      logger.d("\n\nLAST-CRDR RESPONSE: $decrypted");
      lastCrDrResponse = LastCrDrResponse.fromJson(decrypted);
    } catch (e) {
      AppLogger.appLogE(tag: "DECODE:ERROR", message: e.toString());
    }
    return lastCrDrResponse ?? LastCrDrResponse(status: "XXX");
  }
}


extension ministatement on APIService{
  Future<DynamicResponse?> checkMiniStmnt(
      {required bankAccountID,
        formId = "PAYBILL"}) async {
    var decrypted;
    DynamicResponse? dynamicResponse;
    Map<String, dynamic> innerMap = {};
    Map<String, dynamic> requestObj = {};
    innerMap["BANKACCOUNTID"] = bankAccountID;
    innerMap["MerchantID"] = "STATEMENT";
    requestObj["ModuleID"] = "STATEMENT";
    requestObj["PayBill"] = innerMap;
    requestObj["MerchantID"] = "STATEMENT";

    final route = await _sharedPref.getRoute("account".toLowerCase());
    var res = await performDioRequest(
        await dioRequestBodySetUp(formId, objectMap: requestObj),
        route: route);

    try {
      decrypted = jsonDecode(res ?? "{}") ?? "{}";
      logger.d("\n\nMINI-STATEMENT RESPONSE: $decrypted");

      dynamicResponse = DynamicResponse.fromJson(decrypted);
    } catch (e) {
      AppLogger.appLogE(tag: "DECODE:ERROR", message: e.toString());
    }
    return dynamicResponse ?? DynamicResponse(status: "XXX");
  }
}