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

extension BillerTypes on APIService{

  Future<DynamicResponse> getBillerTypes() async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    innerMap["HEADER"] = "GETBILLERS";
    innerMap["INFOFIELD1"] = "BILLERTYPE";
    // innerMap["BANKID"] = "58";
    // innerMap["COUNTRY"] = "UGANDATEST";
    requestObj[RequestParam.DynamicForm.name] = innerMap;

    final route = await _sharedPref.getRoute(RouteUrl.other.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("DBCALL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("GETBillers response : $res");
    } catch (e) {
      CommonUtils.showToast("Biller names fetch failed");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension BillerNames on APIService{

  Future<DynamicResponse> getBillerNames(String utility,) async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    innerMap["HEADER"] = "GETBILLERSNAMES";
    innerMap["INFOFIELD1"] = "BILLERNAME";
    innerMap["INFOFIELD2"] = utility;
    // innerMap["COUNTRY"] = "UGANDATEST";
    requestObj[RequestParam.DynamicForm.name] = innerMap;

    final route = await _sharedPref.getRoute(RouteUrl.other.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("DBCALL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("GETBillers response : $res");
    } catch (e) {
      CommonUtils.showToast("Biller names fetch failed");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}

extension SaveBeneficiary on APIService{

  Future<DynamicResponse> saveBen(String billerType,
      String billerName,
      String alias,
      String account) async {
    String? res;
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    requestObj["ModuleID"] = "ADDBENEFICIARY";
    requestObj["MerchantID"] = "BENEFICIARY";
    innerMap["HEADER"] = "BENEFICIARY";
    innerMap["INFOFIELD1"] = billerType;
    innerMap["INFOFIELD2"] = billerName;
    innerMap["INFOFIELD3"] = alias;
    innerMap["INFOFIELD4"] = account;
    innerMap["MerchantID"] = "BENEFICIARY";
    requestObj[RequestParam.DynamicForm.name] = innerMap;

    final route = await _sharedPref.getRoute(RouteUrl.other.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("DBCALL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("GETBillers response : $res");
    } catch (e) {
      CommonUtils.showToast("Biller names fetch failed");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }
}