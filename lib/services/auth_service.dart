import 'package:firebase_auth/firebase_auth.dart';

import '../helpers/helper_functions.dart';
import './database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future registerUser(String fullName, String email, String password) async {
    try {
      User? user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user != null) {
        // call our database service
        await DatabaseService(uid: user.uid).saveUserData(fullName, email);

        return true;
      }
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }

  Future loginUser(String email, String password) async {
    try {
      User? user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }

  Future signoutUser() async {
    try {
      await HelperFunctions.saveUserLoggedIn(false);
      await HelperFunctions.saveUserName('');
      await HelperFunctions.saveUserEmail('');

      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }
}
