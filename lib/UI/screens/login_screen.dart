import 'package:dashboard_design/bloc/login/login_bloc.dart';
import 'package:dashboard_design/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../constants/constants.dart';
import '../../utils/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool otpVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is OtpSucessState) {
          Navigator.of(context).pop();
          setState(() {
            otpVisible = true;
          });
        } else if (state is LoginLoadingState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return Container(
                color: Colors.transparent,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.sbiColor,
                  ),
                ),
              );
            },
          );
        } else if (state is LoginSuccessState) {
          AuthService.authenticated = true;
          Navigator.of(context, rootNavigator: true).pop();
          GoRouter.of(context).go(AppConstants.watchlistLocation);
        } else {
          if (state is LoginFailureState) {
            Navigator.of(context, rootNavigator: true).pop();
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text(AppConstants.loginFail)));
          }
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 300),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 160, bottom: 20),
                      width: 300,
                      child: TextField(
                        controller: userIdController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: AppConstants.strUserId),
                      ),
                    ),
                    Visibility(
                      visible: otpVisible,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 40),
                        width: 300,
                        child: TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              labelText: AppConstants.strEnterOtp),
                        ),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.sbiColor,
                            borderRadius: BorderRadius.circular(20)),
                        alignment: Alignment.center,
                        width: double.maxFinite,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20),
                        child: Text(
                          otpVisible
                              ? AppConstants.strLogin
                              : AppConstants.strGetOtp,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                      onTap: () {
                        if (otpVisible == false) {
                          if (userIdController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(AppConstants.credEmpty)));
                          } else {
                            context
                                .read<LoginBloc>()
                                .add(LoginSubmitEvent(userIdController.text));
                          }
                        } else {
                          if (userIdController.text.isEmpty || passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(AppConstants.credEmpty)));
                          } else {
                            context
                                .read<LoginBloc>()
                                .add(OtpSubmitEvent(mobNum: userIdController.text, otp: passwordController.text));
                          }
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}