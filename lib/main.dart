import 'package:dashboard_design/app_route_config.dart';
import 'package:dashboard_design/cubit/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Trading App',
            theme: state,
            routerConfig: AppRouteConfig().router,
            debugShowCheckedModeBanner: false,
            
          );
        },
      ),
    );
  }
}
