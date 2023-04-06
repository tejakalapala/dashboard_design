import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const  Scaffold(
      body: Center(child:Text(AppConstants.settings)),
    );
  }
}