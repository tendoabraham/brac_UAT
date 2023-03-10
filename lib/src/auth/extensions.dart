import 'dart:convert';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/cupertino.dart';

import '../other/LastCrDrModel.dart';


final _sharedPref = CommonSharedPref();

extension LastCrDr on APIService{

  Future<LastCrDrResponse?> checkRecentCrDr(
      {formId = "DBCALL"}) async {
    String res, decrypted = "";
    LastCrDrResponse? lastCrDrResponse;
    Map<String, dynamic> innerMap = {};
    Map<String, dynamic> requestObj = {};
    innerMap["HEADER"] = "GETRECENTCREDITDEBIT";
    requestObj["DynamicForm"] = innerMap;

    final route = await _sharedPref.getRoute("other".toLowerCase());
    await performDioRequest(
        await dioRequestBodySetUp(formId, objectMap: requestObj),
        route: route)
        .then((value) async => {
      res = value?.data["Response"],
      decrypted = await CryptLib.decryptResponse(res),
      debugPrint("Logg:$decrypted")
    });
    try {
      lastCrDrResponse = LastCrDrResponse.fromJson(jsonDecode(decrypted));
    } catch (e) {
      // AppLogger.appLogE(tag: "DECODE:ERROR", message: e.toString());
    }
    return lastCrDrResponse ?? LastCrDrResponse(status: "XXX");
  }
}