import 'package:flutter/material.dart';

import '../shared/constants.dart';
import '../helpers/helper_functions.dart';
import '../services/auth_service.dart';
import './login_screen.dart';
import './home_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile-screen';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = '';
  String email = '';
  AuthService authService = AuthService();

  void getUserData() async {
    await HelperFunctions.getUserName().then((value) {
      setState(() {
        userName = value ?? '';
      });
    });

    await HelperFunctions.getUserEmail().then((value) {
      setState(() {
        email = value ?? '';
      });
    });
  }

  @override
  void initState() {
    getUserData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 70,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 10),
            Text(
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 50),
            ListTile(
              onTap: () {
                Navigator.pushReplacementNamed(context, HomeScreen.routeName);
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              leading: const Icon(Icons.group, size: 35),
              title: const Text(
                'Groups',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            ListTile(
              onTap: () {},
              selectedColor: Constants.primaryColor,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              leading: const Icon(Icons.person, size: 35),
              title: const Text(
                'Profile',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    elevation: 5,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    title: const Text(
                      'Log Out?',
                    ),
                    content: const Text(
                      'Are you sure you want to logout?',
                    ),
                    actions: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.cancel,
                                  color: Colors.green,
                                  size: 30,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'No',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              authService.signoutUser().whenComplete(() {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  LoginScreen.routeName,
                                  (route) => false,
                                );
                              });
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.done,
                                  color: Colors.red,
                                  size: 30,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'yes',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              selectedColor: Constants.primaryColor,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              leading: const Icon(Icons.exit_to_app, size: 35),
              title: const Text(
                'Log Out',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
        child: Column(
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 200,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Full Name: ',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Email: ',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
