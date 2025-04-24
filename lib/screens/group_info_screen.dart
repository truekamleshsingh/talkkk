import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../shared/constants.dart';
import '../services/database_service.dart';
import './home_screen.dart';

class GroupInfoScreen extends StatefulWidget {
  static const routeName = '/group-info-screen';

  final String groupId;
  final String groupName;
  final String groupAdmin;

  const GroupInfoScreen({
    required this.groupId,
    required this.groupName,
    required this.groupAdmin,
    Key? key,
  }) : super(key: key);

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  Stream? members;

  getGroupMeembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((value) {
      setState(() {
        members = value;
      });
    });
  }

  Widget memberList(context) {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['members'].length,
                shrinkWrap: true,
                itemBuilder: (context, index) => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Constants.primaryColor,
                      child: Text(
                        snapshot.data['members'][index]
                            .substring(
                                snapshot.data['members'][index].indexOf('_') +
                                    1)
                            .substring(0, 1)
                            .toUpperCase(),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: Text(
                      snapshot.data['members'][index].substring(
                          snapshot.data['members'][index].indexOf('_') + 1),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      snapshot.data['members'][index].substring(
                        0,
                        snapshot.data['members'][index].indexOf('_'),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                child: Text(
                  'No Members',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.withOpacity(0.7),
                  ),
                ),
              );
            }
          } else {
            return Center(
              child: Text(
                'No Members',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.withOpacity(0.7),
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
    );
  }

  @override
  void initState() {
    getGroupMeembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 70,
        title: const Text('Group Info'),
        actions: [
          IconButton(
            onPressed: () {
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
                    'Exit the group?',
                  ),
                  content: const Text(
                    'Are you sure you want to exit?',
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
                            DatabaseService(
                                    uid: FirebaseAuth.instance.currentUser!.uid)
                                .toggleGroupJoin(
                                  widget.groupId,
                                  widget.groupName,
                                  widget.groupAdmin.substring(
                                      widget.groupAdmin.indexOf('_') + 1),
                                )
                                .whenComplete(
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(),
                                    ),
                                  ),
                                );
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
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Constants.primaryColor.withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Constants.primaryColor,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Group: ${widget.groupName}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Admin: ${widget.groupAdmin.substring(widget.groupAdmin.indexOf('_') + 1)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            memberList(context),
          ],
        ),
      ),
    );
  }
}
