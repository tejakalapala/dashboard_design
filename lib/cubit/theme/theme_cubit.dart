import 'package:dashboard_design/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../UI/screens/watchlist_screen.dart';


class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(_lightTheme);
  static final _lightTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
    ),
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.grey.shade100,
    iconTheme:const  IconThemeData(color: Colors.black),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(iconColor: MaterialStateColor.resolveWith((states){
        return Colors.black;
      }))
    ),
    unselectedWidgetColor: AppColors.sbiColor,
    textTheme: 
    ThemeData.light().textTheme.copyWith(
      
                titleLarge: const TextStyle(
                  // fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.sbiColor
                ),
                bodyLarge: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),
                bodyMedium: const TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.normal),
                bodySmall: const TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.normal),
                labelSmall: const TextStyle(color: Colors.black,fontSize: 12),
                labelLarge: const TextStyle(color: Colors.black,fontSize: 20),
                
              ),
              indicatorColor: AppColors.sbiColor,
              colorScheme:const ColorScheme.light(
                background: Colors.white,
                secondaryContainer: Colors.white
              ) ,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
            
          )
        )
      ),
              )
               
  );

  static final _darkTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.black,
    ),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black45,
    iconTheme: const IconThemeData(color: Colors.white),
    unselectedWidgetColor: Colors.white,
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(iconColor: MaterialStateColor.resolveWith((states){
        return Colors.white;
      }))
    ),
     textTheme: ThemeData.dark().textTheme.copyWith(
                titleLarge: const TextStyle(
                  // fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white
                ),
                bodyLarge: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
                bodyMedium: const TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.normal),
                bodySmall: const TextStyle(color: Colors.white,fontSize: 10,fontWeight: FontWeight.normal),
                labelSmall: const TextStyle(color: Colors.white,fontSize: 15),
                
              ),
              indicatorColor: Colors.white,
              colorScheme:const ColorScheme.dark(
                background: Colors.black,
                secondaryContainer: Colors.black
              ) ,
               elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
            
          )
        )
      ),
              )
  );

  
  
  void setTheme(ThemePref theme) {
    if(theme == ThemePref.light){
      emit(_lightTheme);
    }else if(theme == ThemePref.dark){
      emit(_darkTheme);
    }
    else{
      var brightness = SchedulerBinding.instance.window.platformBrightness;
 emit(brightness == Brightness.dark ? _darkTheme :_lightTheme);
    }
  }

}
