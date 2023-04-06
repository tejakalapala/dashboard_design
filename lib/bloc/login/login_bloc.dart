
import 'dart:convert';

import 'package:dashboard_design/repos/repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
part 'login_event.dart';
part 'login_state.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _loginRepository;
  LoginBloc(this._loginRepository) : super(LoginInitial()) {
   on<LoginSubmitEvent>(_sendOtpRequest);
   on<OtpSubmitEvent>(_sendLoginRequest);
  }

  Future _sendOtpRequest(LoginSubmitEvent event,Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    // var getOtpUrl = Uri.parse(AppConstants.getOtpUrl);
    // var reqBody = {};
    
    // var data = {};
    // var request = {};
    // data["mobNo"] = "+91${event.mobNum}";
    // request["appID"] = "f79f65f1b98e116f40633dbb46fd5e21";
    // request["data"] = data;
    // reqBody["request"] = request;
    // print(json.encode(reqBody));

    // final response = await http.post(getOtpUrl,
    // headers: <String, String>{
    //   'Content-Type': 'application/json; charset=UTF-8',
    //   "X-ENCRYPT": "false"
    // },
    
    // body:json.encode(reqBody));
    // print(response.body);
    // try{
    // final extractedData = json.decode(response.body) as Map<dynamic,dynamic>;
    try{
      final infoID = await _loginRepository.getOtpRequestInfo(event.mobNum);
      if(infoID == "0"){
      emit(OtpSucessState());
    }else{
      emit(LoginFailureState());
    }
    }catch(e){
      emit(LoginFailureState());
    }
  
    
    }
  

  Future _sendLoginRequest(OtpSubmitEvent event,Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    
    try{
    final infoID = await _loginRepository.getLoginRequestInfo(event.mobNum,event.otp);
    
    if(infoID == "0"){
      emit(LoginSuccessState());
    }else{
      emit(LoginFailureState());
    }
    }catch(e){
      emit(LoginFailureState());
    }
  }
}
