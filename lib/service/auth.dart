import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore
      .instance; // Create Firestore instance


  // Register with email and password
  Future<CustomUser?> registerWithEmailAndPassword(String email,
      String password, String fullName) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // Update the user's display name
      if (user != null) {
        await user.updateProfile(displayName: fullName);
        await user.reload(); // Reload the user to fetch the updated profile
        user = _auth.currentUser; // Get the updated user instance
      }

      return _userFromFirebaseUser(user);
    } catch (e) {
      print("Error registering user: $e");
      return null;
    }
  }

  // Sign in with email and password
  Future<CustomUser?> signInWithEmailAndPassword(String email,
      String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Convert Firebase User to Custom User
  CustomUser? _userFromFirebaseUser(User? user) {
    return user != null ? CustomUser(
        uid: user.uid, displayName: user.displayName) : null;
  }

  // Auth change user stream
  Stream<CustomUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // Sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}