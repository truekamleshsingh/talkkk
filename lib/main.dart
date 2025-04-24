import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import './firebase_options.dart';

import './shared/constants.dart';
import './helpers/helper_functions.dart';
import './router.dart';
import './screens/login_screen.dart';
import './screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // Run firebase initialization for web
    await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
  } else {
    // Run firebase initialization for android or IOS (if you have xcode)
    await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

  void getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  void initState() {
    getUserLoggedInStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Project Chat App Talkrr',
      theme: ThemeData(
        // useMaterial3: true,
        primaryColor: Constants.primaryColor,
        colorScheme: const ColorScheme.light(
          primary: Constants.primaryColor,
        ),
      ),
      onGenerateRoute: (settings) => generateRoutes(settings),
      home: _isSignedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
