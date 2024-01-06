import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectContactRepositoryProvider = Provider(
  (ref) => SelectContactRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class SelectContactRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  SelectContactRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<List<Map<String, dynamic>>> getContacts() {
    return firestore
        .collection('users')
        .snapshots()
        .map<List<Map<String, dynamic>>>((snapshot) {
      List<Map<String, dynamic>> contacts = snapshot.docs
          .map<Map<String, dynamic>>((doc) => doc.data())
          .where((data) =>
              data != null && auth.currentUser!.email != data['email'])
          .toList();
      // You can now use 'contacts' for additional processing if needed
      return contacts;
    });
  }
}
