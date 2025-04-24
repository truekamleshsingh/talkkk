import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import '../shared/constants.dart';
import '../helpers/helper_functions.dart';
import '../widgets/widgets.dart';
import '../services/auth_service.dart';
import './login_screen.dart';
import '../screens/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register-screen';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthService authService = AuthService();

  String fullName = '';
  String email = '';
  String password = '';

  void register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await authService
          .registerUser(fullName, email, password)
          .then((value) async {
        if (value == true) {
          //Saving login token in the local storage using Shared Preferences
          await HelperFunctions.saveUserLoggedIn(true);
          await HelperFunctions.saveUserName(fullName);
          await HelperFunctions.saveUserEmail(email);

          if (mounted) {
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          }
        } else {
          showSnackBar(context, Colors.red, value);

          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Constants.primaryColor),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Talkrr',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Create your account to explore with us',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Image.asset('assets/register.png'),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          labelText: 'Full Name',
                          prefixIcon: const Icon(Icons.person,
                              color: Constants.primaryColor),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return 'Name can\'t be empty';

                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            fullName = value;
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email,
                              color: Constants.primaryColor),
                        ),
                        validator: (value) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value!)
                              ? null
                              : "Please enter a valid email";
                        },
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        obscureText: true,
                        decoration: textInputDecoration.copyWith(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.key,
                              color: Constants.primaryColor),
                        ),
                        validator: (value) {
                          if (value!.length < 6) {
                            return 'Password must be at least 6 characters';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: register,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Register',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text.rich(
                        TextSpan(
                          text: 'Already have an account? ',
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Login now',
                              style: const TextStyle(
                                color: Constants.primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    LoginScreen.routeName,
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
