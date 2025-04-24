import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../shared/constants.dart';
import '../widgets/widgets.dart';
import '../widgets/group_tile.dart';
import '../helpers/helper_functions.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import './login_screen.dart';
import './profile_screen.dart';
import './search_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = '';
  String email = '';
  String groupName = '';
  AuthService authService = AuthService();
  Stream? group;
  bool _isLoading = false;

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

    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroup()
        .then((snapshot) {
      setState(() {
        group = snapshot;
      });
    });
  }

  String getGroupId(String response) {
    return response.substring(0, response.indexOf('_'));
  }

  String getGroupName(String response) {
    return response.substring(response.indexOf('_') + 1);
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
        toolbarHeight: 70,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Talkrr Groups',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchScreen.routeName);
            },
            icon: const Icon(Icons.search),
          ),
        ],
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
              onTap: () {},
              selectedColor: Constants.primaryColor,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              leading: const Icon(Icons.group, size: 35),
              title: const Text(
                'Groups',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, ProfileScreen.routeName);
              },
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
      body: StreamBuilder(
        stream: group,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['groups'] != null) {
              if (snapshot.data['groups'].length != 0) {
                return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  itemBuilder: (context, index) {
                    int reverseIndex =
                        snapshot.data['groups'].length - index - 1;

                    return GroupTile(
                      userName: snapshot.data['fullName'],
                      groupId:
                          getGroupId(snapshot.data['groups'][reverseIndex]),
                      groupName:
                          getGroupName(snapshot.data['groups'][reverseIndex]),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    'You haven\'t joined any groups!\n\nSearch for groups by using the search icon in the appbar or create your own using the add button below',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                );
              }
            } else {
              return const Center(
                child: Text(
                  textAlign: TextAlign.center,
                  'You haven\'t joined any groups!\n\nSearch for groups by using the search icon in the appbar or create your own using the add button below',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Constants.primaryColor),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Constants.primaryColor,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => StatefulBuilder(
              builder: ((context, setState) {
                return AlertDialog(
                  // ignore: prefer_const_constructors
                  title: Text(
                    textAlign: TextAlign.center,
                    'Create a group',
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Constants.primaryColor,
                              ),
                            )
                          : TextField(
                              onChanged: (value) {
                                setState(() {
                                  groupName = value;
                                });
                              },
                              decoration: textInputDecoration,
                            ),
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.primaryColor,
                      ),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (groupName != '') {
                          setState(() {
                            _isLoading = true;
                          });

                          DatabaseService(
                                  uid: FirebaseAuth.instance.currentUser!.uid)
                              .createGroup(userName, groupName)
                              .whenComplete(() {
                            setState(() {
                              _isLoading = false;
                            });
                          });

                          Navigator.of(context).pop();
                          showSnackBar(context, Colors.green,
                              'Group created Successfully!');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.primaryColor,
                      ),
                      child: const Text('Create'),
                    ),
                  ],
                );
              }),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
