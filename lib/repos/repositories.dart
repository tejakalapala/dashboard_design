import 'dart:convert';
import 'package:dashboard_design/models/stock_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';


class WatchlistRepository {
  var contactUrl = Uri.parse(AppConstants.watchlistUrl);

  Future<List<Symbols>> getSymbols() async {
    if (kDebugMode) {
      print('$contactUrl request sending');
    }
    try{
    final response = await http.get(contactUrl);
   
      final extractedData = json.decode(response.body) as Map<dynamic,dynamic>;
    final List<Symbols> loadedSymbols = [];
    
    for(var symbolData in extractedData["response"]["data"]["symbols"]){
      loadedSymbols.add(Symbols(
        companyName: symbolData["companyName"],
        dispSym: symbolData["dispSym"],
        excToken: symbolData['excToken'],
        sym: Sym(
          exc: symbolData['sym']['exc'],
          id: symbolData['sym']['id'],
        ),
      ));
    }
    
    return loadedSymbols;
    }catch(error){
      rethrow;
    }
  }
}

class LoginRepository {
  Future<String> getOtpRequestInfo(String mobNo) async {
    var getOtpUrl = Uri.parse(AppConstants.getOtpUrl);
    var reqBody = {};
    
    var data = {};
    var request = {};
    data["mobNo"] = "+91$mobNo";
    request["appID"] = "f79f65f1b98e116f40633dbb46fd5e21";
    request["data"] = data;
    reqBody["request"] = request;
    print(json.encode(reqBody));

    final response = await http.post(getOtpUrl,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "X-ENCRYPT": "false"
    },
    
    body:json.encode(reqBody));
    print(response.body);
    try{
    final extractedData = json.decode(response.body) as Map<dynamic,dynamic>;
    return extractedData["response"]["infoID"];
    }catch(e){
      rethrow;
    }
  }

  Future<String> getLoginRequestInfo(String mobNo,String otp) async {
   var loginUrl = Uri.parse(AppConstants.loginUrl);
    var reqBody = {};
    
    var data = {};
    var request = {};
    data["mobNo"] = "+91$mobNo";
    data["userType"] = "virtual";
    data["otp"] = otp;
    request["appID"] = "45370504ab27eed7327a1df46403a30a";
    request["data"] = data;
    reqBody["request"] = request;
    print(json.encode(reqBody));

    final response = await http.post(loginUrl,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "X-ENCRYPT": "false"
    },
    
    body:json.encode(reqBody));
    print(response.body);
    try{
    final extractedData = json.decode(response.body) as Map<dynamic,dynamic>;
    return extractedData["response"]["infoID"];
    }catch(e){
      rethrow;
    }
  }

}

