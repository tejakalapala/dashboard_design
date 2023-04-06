part of 'login_bloc.dart';


abstract class LoginState {}

class LoginInitial extends LoginState {}
class OtpSucessState extends LoginState{}
class LoginFailureState extends LoginState{}
class LoginLoadingState extends LoginState{}
class LoginSuccessState extends LoginState{}