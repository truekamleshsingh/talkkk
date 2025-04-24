import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');

  DatabaseService({this.uid});

  // Saving the user data
  Future saveUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'groups': [],
      'profilePic': '',
    });
  }

  // Getting user data
  Future getUserData(String email) async {
    QuerySnapshot querySnapshot =
        await userCollection.where('email', isEqualTo: email).get();

    return querySnapshot;
  }

  // Getting user's groups
  Future getUserGroup() async {
    return userCollection.doc(uid).snapshots();
  }

  // Creating a group
  Future createGroup(String userName, String groupName) async {
    DocumentReference groupDocRef = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': '',
      'admin': '${uid}_$userName',
      'members': [],
      'groupId': '',
      'recentMessage': '',
      'recentMessageSender': '',
      'recentMessageTime': '',
    });

    await groupDocRef.update({
      'members': FieldValue.arrayUnion(['${uid}_$userName']),
      'groupId': groupDocRef.id,
    });

    DocumentReference userDocRef = userCollection.doc(uid);
    return await userDocRef.update({
      'groups': FieldValue.arrayUnion(['${groupDocRef.id}_$groupName']),
    });
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference docRef = groupCollection.doc(groupId);
    DocumentSnapshot docSnap = await docRef.get();

    return docSnap['admin'];
  }

  Future getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  Future getGroupMembers(String groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  Future searchByName(String groupName) async {
    return groupCollection.where('groupName', isEqualTo: groupName).get();
  }

  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot docSnap = await userDocRef.get();

    List<dynamic> groups = await docSnap['groups'];
    if (groups.contains('${groupId}_$groupName')) {
      return true;
    } else {
      return false;
    }
  }

  Future toggleGroupJoin(
      String groupId, String groupName, String userName) async {
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentReference groupDocRef = groupCollection.doc(groupId);

    DocumentSnapshot docSnap = await userDocRef.get();

    List<dynamic> groups = await docSnap['groups'];

    if (groups.contains('${groupId}_$groupName')) {
      await userDocRef.update({
        'groups': FieldValue.arrayRemove(['${groupId}_$groupName']),
      });

      await groupDocRef.update({
        'members': FieldValue.arrayRemove(['${uid}_$userName']),
      });
    } else {
      await userDocRef.update({
        'groups': FieldValue.arrayUnion(['${groupId}_$groupName']),
      });

      await groupDocRef.update({
        'members': FieldValue.arrayUnion(['${uid}_$userName']),
      });
    }
  }

  Future sendMessage(String groupId, Map<String, dynamic> messagesData) async {
    groupCollection.doc(groupId).collection('messages').add(messagesData);
    groupCollection.doc(groupId).update({
      'recentMessage': messagesData['message'],
      'recentMessageSender': messagesData['sender'],
      'recentMessageTime': messagesData['time'].toString(),
    });
  }
}
