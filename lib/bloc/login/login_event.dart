part of 'login_bloc.dart';


abstract class LoginEvent {}
class LoginSubmitEvent extends LoginEvent{
  String mobNum;
  // String password;
  LoginSubmitEvent(this.mobNum);
  
}
class OtpSubmitEvent extends LoginEvent{
  String mobNum;
  String otp;
  OtpSubmitEvent({required this.mobNum,required this.otp});
}