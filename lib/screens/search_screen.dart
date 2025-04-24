import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../shared/constants.dart';
import '../widgets/widgets.dart';
import '../helpers/helper_functions.dart';
import '../services/database_service.dart';
import './chat_screen.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search-screen';

  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  QuerySnapshot? searchSnapshot;

  String userName = '';
  User? user;

  bool _isLoading = false;
  bool _hasUserSearched = false;
  bool _isJoined = false;

  Future getCurrentUserIdAndName() async {
    HelperFunctions.getUserName().then((value) {
      setState(() {
        userName = value!;
      });
    });

    user = FirebaseAuth.instance.currentUser;
  }

  Future initiateSearch() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      await DatabaseService()
          .searchByName(searchController.text)
          .then((snapshots) {
        setState(() {
          searchSnapshot = snapshots;
          _isLoading = false;
          _hasUserSearched = true;
        });
      });
    }
  }

  joinedOrNot(
      String userName, String groupId, String groupname, String admin) async {
    await DatabaseService(uid: user!.uid)
        .isUserJoined(groupname, groupId, userName)
        .then((value) {
      setState(() {
        _isJoined = value;
      });
    });
  }

  Widget groupTile(
      String userName, String groupId, String groupName, String admin) {
    joinedOrNot(userName, groupId, groupName, admin);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Constants.primaryColor,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      title: Text(
        groupName,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
      subtitle: Text(
        'Admin: ${admin.substring(admin.indexOf('_') + 1)}',
      ),
      trailing: InkWell(
        onTap: () async {
          await DatabaseService(uid: user!.uid)
              .toggleGroupJoin(groupId, groupName, userName);

          if (_isJoined) {
            setState(() {
              _isJoined = !_isJoined;
            });

            if (mounted) {
              showSnackBar(context, Colors.green,
                  'Successfully Joined the group: $groupName');
            }

            Future.delayed(const Duration(seconds: 2), () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    groupId: groupId,
                    groupName: groupName,
                    userName: userName,
                  ),
                ),
              );
            });
          } else {
            setState(() {
              _isJoined = !_isJoined;
            });

            if (mounted) {
              showSnackBar(context, Colors.red,
                  'Successfully left the group: $groupName');
            }
          }
        },
        child: _isJoined
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.black.withOpacity(0.8),
                ),
                child: const Text(
                  'Joined',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(30),
                  color: Constants.primaryColor.withOpacity(0.8),
                ),
                child: const Text(
                  'Join Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
      ),
    );
  }

  Widget groupList() {
    return _hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) => groupTile(
              userName,
              searchSnapshot!.docs[index]['groupId'],
              searchSnapshot!.docs[index]['groupName'],
              searchSnapshot!.docs[index]['admin'],
            ),
          )
        : Container();
  }

  @override
  void initState() {
    getCurrentUserIdAndName();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 70,
        title: const Text(
          'Search',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: Constants.primaryColor,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search Groups',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    initiateSearch();
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Constants.primaryColor,
                  ),
                )
              : groupList(),
        ],
      ),
    );
  }
}
