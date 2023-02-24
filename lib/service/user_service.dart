import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  Future<bool> login(String email, String password) async {
    try {
      UserCredential result =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user == null) {
        throw Exception('ERROR_USER_NOT_FOUND');
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(UserService.getUserId())
          .set({'name': name, 'password': password, 'email': email});
    } catch (e) {
      return false;
    }
    return true;
  }

  static Future<String> getUserName() async {
    if (isUserLogged()) {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(getUserId())
          .get();
      if(!documentSnapshot.exists){
        return '';
      }
      return documentSnapshot.get('name');
    }
    return '';
  }

  static String getUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  static bool isUserLogged() {
    return FirebaseAuth.instance.currentUser != null;
  }

  static void logout() {
    FirebaseAuth.instance.signOut();
  }
}
