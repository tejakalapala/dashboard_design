import 'package:dashboard_design/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../constants/constants.dart';
import '../../cubit/theme/theme_cubit.dart';
import '../../utils/auth_service.dart';



class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.child});
  final Widget child;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool isExtended = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: state.scaffoldBackgroundColor,
          // appBar: AppBar(
          //   title: const Text("Navigator Rail Sample"),
          // ),
          body: 
              
                 Stack(
                  children: [
                    
                            Padding(
                              padding: const EdgeInsets.only(left:100),
                              child: Container(
                                width: MediaQuery.of(context).size.width - 100,
                                color: state.scaffoldBackgroundColor, child: widget.child),
                            ),
                    GestureDetector(
                      // onTap: () {
                      //   setState(() {
                      //     isExtended = !isExtended;
                      //   });
                      // },
                      
                      child: SizedBox(
                        width: isExtended ? 200 : 100,
                        child: MouseRegion(
                          onEnter: (_) => setState(() => isExtended = true),
                          onExit: (_) => setState(() => isExtended = false),
                          child: NavigationRail(
                            
                            destinations:  const[
                              NavigationRailDestination(
                                icon: Icon(
                                  Icons.remove_red_eye,
                                  
                                ),
                                label: Text(
                                  AppConstants.watchlist,
                                  
                                ),
                              ),
                              NavigationRailDestination(
                                  icon: Icon(Icons.currency_rupee_outlined,
                                      ),
                                  label: Text(
                                    AppConstants.limits,
                                    
                                  )),
                              NavigationRailDestination(
                                  icon: Icon(Icons.person, ),
                                  label: Text(
                                    AppConstants.myAccount,
                                    ),
                                    
                                  ),
                              NavigationRailDestination(
                                  icon: Icon(Icons.settings,),
                                  label: Text(
                                    AppConstants.settings,
                                    
                                  )),
                              NavigationRailDestination(
                                  icon: Icon(Icons.close,),
                                  label: Text(
                                    AppConstants.logout,
                                    
                                  ))
                            ],
                            extended: isExtended,
                            
                            backgroundColor: AppColors.sbiColor,
                            labelType: isExtended
                                ? NavigationRailLabelType.none
                                : NavigationRailLabelType.selected,
                            selectedIndex: _selectedIndex,
                            selectedIconTheme:
                                const IconThemeData(color: Colors.white),
                            selectedLabelTextStyle:
                                state.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white
                                ),
                                unselectedIconTheme: const IconThemeData(color: Colors.white),
                                unselectedLabelTextStyle: state.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white
                                ),
                            onDestinationSelected: (value) {
                              // setState(() {
                              //   _selectedIndex = value;
                              // });
                              _goOtherTab(context, value);
                            },
                          ),
                        ),
                      ),
                    ),
                    
                  ],
                ),
              
            
        
        );
      },
    );
  }

  void _goOtherTab(BuildContext context, int index) {
    if (index == _selectedIndex) return;
    GoRouter router = GoRouter.of(context);

    setState(() {
      if (index != 4) {
        _selectedIndex = index;
      }
    });

    if (index == 0) {
      router.go(AppConstants.watchlistLocation);
    } else if (index == 1) {
      router.go(AppConstants.limitsLocation);
    } else if (index == 2) {
      router.go(AppConstants.accountLocation);
    } else if (index == 3) {
      router.go(AppConstants.settingsLocation);
    } else if (index == 4) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(AppConstants.logout),
              content: const Text(AppConstants.logoutMsg),
              actions: [
                TextButton(
                  child: const Text(AppConstants.strCancel),
                  onPressed: () {
                    router.pop();
                  },
                ),
                TextButton(
                  child: const Text(AppConstants.strOk),
                  onPressed: () {
                    router.pop();
                    AuthService.authenticated = false;
                    router.go(AppConstants.loginLocation);
                  },
                ),
              ],
            );
          });
    } else {
      router.go(AppConstants.watchlistLocation);
    }
  }

  
}
