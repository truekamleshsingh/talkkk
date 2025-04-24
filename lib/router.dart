import 'package:flutter/material.dart';

import './screens/register_screen.dart';
import './screens/login_screen.dart';
import './screens/home_screen.dart';
import './screens/profile_screen.dart';
import './screens/search_screen.dart';
// import './screens/chat_screen.dart';

Route<dynamic> generateRoutes(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case RegisterScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const RegisterScreen(),
      );

    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const LoginScreen(),
      );

    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const HomeScreen(),
      );

    case ProfileScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const ProfileScreen(),
      );

    case SearchScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const SearchScreen(),
      );

    // case ChatScreen.routeName:
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (context) => const ChatScreen(),
    //   );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const Scaffold(
          body: Center(
            child: Text(
              'This Page has been removed or does not exist',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          ),
        ),
      );
  }
}
