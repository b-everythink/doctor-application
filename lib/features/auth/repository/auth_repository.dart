import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_application/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.auth, required this.firestore});

  Future<UserModel?> getCurrentUserData() async {
    final userData = await firestore.collection('users').doc(auth.currentUser?.uid).get();
    return userData.data() != null ? UserModel.fromMap(userData.data()!) : null;
  }

  Future<UserCredential> _signInWithCredentials(
      Future<UserCredential> Function() signInMethod,
      String email,
      String password) async {
    try {
      final userCredential = await signInMethod();

      // Add a new document for the user in the users collection if it doesn't already exist
      await firestore.collection('users').doc(userCredential.user!.uid).set(
        {'uid': userCredential.user!.uid, 'email': email},
        SetOptions(merge: true),
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    return _signInWithCredentials(
      () => auth.signInWithEmailAndPassword(email: email, password: password),
      email,
      password,
    );
  }

  Future<UserCredential> signUpWithEmailAndPassword(String email, String password) async {
    return _signInWithCredentials(
      () => auth.createUserWithEmailAndPassword(email: email, password: password),
      email,
      password,
    );
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);
