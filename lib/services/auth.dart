import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatatrivia/private_classes/user.dart';
import 'package:whatatrivia/services/dbaseUser.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  //creates AppUser based on User from firebase_auth at the moment of signing in. Also returns null at the moment of signing out
  AppUser _userFromFirebaseUser(User? user){
    if (user != null) {
      return AppUser(userId: user.uid);
    }else{
      return AppUser(userId: 'none');
    }
  }

  //user authentication change stream
  Stream<AppUser> get user{
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user).userId;
    } catch (error) {
      //print(error.toString());
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email, String password, String role) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      //create a new record on the gbcUserCollection with the userId
      await UserDatabaseService(userId: user!.uid).updateUserData('Name', role, []);
      return _userFromFirebaseUser(user);
    }catch(error){
      //print(error.toString());
      return null;
    }
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    }catch(error){
      //print(error.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    }catch(error){
      //print(error.toString());
      return null;
    }
  }

}