import 'package:dashboard_design/UI/screens/account_screen.dart';
import 'package:dashboard_design/UI/screens/bookmark_screen.dart.dart';
import 'package:dashboard_design/UI/screens/seetings_screen.dart';
import 'package:dashboard_design/bloc/watchlist/watchlist_bloc.dart';
import 'package:dashboard_design/constants/constants.dart';
import 'package:dashboard_design/cubit/theme/theme_cubit.dart';
import 'package:dashboard_design/UI/screens/dashboard_screen.dart';
import 'package:dashboard_design/repos/repositories.dart';
import 'package:dashboard_design/utils/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'UI/screens/login_screen.dart';
import 'UI/screens/watchlist_screen.dart';
import 'bloc/login/login_bloc.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouteConfig {
  GoRouter router = GoRouter(
    
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppConstants.loginLocation,
    redirect: (context, state) {
      final isOnLogin = state.location == AppConstants.loginLocation;
      if (!isOnLogin && !AuthService.authenticated) return AppConstants.loginLocation;
      return null;
    },
    routes: <RouteBase>[
      ShellRoute(
          navigatorKey: _shellNavigatorKey,
          pageBuilder: (context, state, child) {
            return NoTransitionPage(
                child: BlocProvider(
              create: (context) => ThemeCubit(),
              child: DashboardScreen(
                child: child,
              ),
            ));
          },
          routes: [
            GoRoute(
              // parentNavigatorKey: _shellNavigatorKey,
              path: AppConstants.watchlistLocation, name: AppConstants.watchlist.toLowerCase(),
              pageBuilder: (context, state) {
                return NoTransitionPage(
                    child: BlocProvider(
                  create: (context) => WatchlistBloc(
                    WatchlistRepository(),
                  ),
                  child: const WatchlistScreen(),
                ));
              },
              // redirect: (context, state) => _redirect(context),
            ),
            GoRoute(
              
              path: AppConstants.limitsLocation, name: AppConstants.limits.toLowerCase(),
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: BookmarkScreen());
              },
              // redirect: (context, state) => _redirect(context),
            ),
            GoRoute(
              
              path: AppConstants.accountLocation, name: AppConstants.strAccount,
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: AccountScreen());
              },
             
            ),
            GoRoute(
              // parentNavigatorKey: _shellNavigatorKey,
              path: AppConstants.settingsLocation, name:AppConstants.settings.toLowerCase() ,
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: SettingsScreen());
              },
              // redirect: (context, state) => _redirect(context),
            ),
          ]),
      GoRoute(
        // parentNavigatorKey: _shellNavigatorKey,
        path: AppConstants.loginLocation, name: AppConstants.strLogin.toLowerCase(),

        pageBuilder: (context, state) {
          return NoTransitionPage(
              child: BlocProvider(
            lazy: false,
            create: (context) => LoginBloc(LoginRepository()),
            child: const LoginScreen(),
          ));
        },
      ),
    ],
  );
}
