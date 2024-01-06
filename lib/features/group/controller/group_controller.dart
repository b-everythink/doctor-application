import 'package:doctor_application/features/group/repository/group_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:doctor_application/model/group.dart' as model;

final groupControllerProvider = Provider.autoDispose(
  (ref) => GroupController(
    ref: ref,
    groupRepository: ref.watch(groupRepositoryProvider),
  ),
);

class GroupController {
  final ProviderRef ref;
  final GroupRepository groupRepository;

  GroupController({
    required this.ref,
    required this.groupRepository,
  });

  void createGroup(
    BuildContext context,
    String name,
    List<String> selectedUserEmails,
  ) {
    print('Create Group method started');
    groupRepository.createGroup(context, name, selectedUserEmails);
    print('Create Group mehtod completed');
  }

  Future<List<String>> getUsers() async {
    try {
      return await groupRepository.getUsers();
    } catch (e) {
      if (kDebugMode) {
        print('Error during sign in: $e');
      }
      // You may want to throw the exception again or handle it appropriately
      rethrow;
    }
  }
}
