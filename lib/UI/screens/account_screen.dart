import 'package:flutter/material.dart';

import '../../constants/constants.dart';


class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text(AppConstants.myAccount),),
      
    );
  }
}