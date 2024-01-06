import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_application/common/widget/snack_bar.dart';
import 'package:doctor_application/model/group.dart' as model;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final groupRepositoryProvider = Provider(
  (ref) => GroupRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class GroupRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  GroupRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  Future<List<String>> getUsers() async {
    List<String> users = [];

    try {
      var userCollection = await firestore.collection('users').get();

      users = userCollection.docs
          .map<String>((doc) => doc.data()['email'].toString())
          .where((email) => email !=auth.currentUser!.email)
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching users: $e');
      }
    }

    return users;
  }

  Future<void> createGroup(
    BuildContext context,
    String name,
    List<String> selectedUserEmails,
  ) async {
    try {
      // Get UIDs of selected users
      List<String> selectedUserUIDs = [];

      for (String userEmail in selectedUserEmails) {
        var userCollection = await firestore
            .collection('users')
            .where('email', isEqualTo: userEmail)
            .get();

        if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
          selectedUserUIDs.add(userCollection.docs[0].data()['uid']);
        }
      }

      // Create a new group
      var groupId = const Uuid().v1();

      model.Group group = model.Group(
        senderId: auth.currentUser!.uid,
        name: name,
        groupId: groupId,
        lastMessage: '',
        membersUid: [auth.currentUser!.uid, ...selectedUserUIDs],
      );

      // Store group data in Firestore
      await firestore.collection('groups').doc(groupId).set(group.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
