import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:doctor_application/features/group/controller/group_controller.dart';

final groupNameController = TextEditingController();
final selectedContactsProvider =
    StateNotifierProvider.autoDispose<SelectedContactsNotifier, List<String>>(
  (ref) => SelectedContactsNotifier(),
);

class SelectedContactsNotifier extends StateNotifier<List<String>> {
  SelectedContactsNotifier() : super([]);

  void toggleContact(String contactEmail) {
    if (state.contains(contactEmail)) {
      state = List.from(state)..remove(contactEmail);
    } else {
      state = List.from(state)..add(contactEmail);
    }
  }
}

class CreateGroupScreen extends ConsumerWidget {
  static const String routeName = '/create-group-screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupController = ref.read(groupControllerProvider);
    final selectedContacts = ref.watch(selectedContactsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Create Group', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            TextField(
              controller: groupNameController,
              decoration: const InputDecoration(
                hintText: 'Group Name',
              ),
            ),
            const SizedBox(height: 16),
            const Text('Select Contacts', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<String>>(
                future: groupController.getUsers(),
                builder: (context, snapshot) {
                  try {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final users = snapshot.data ?? [];

                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final userEmail = users[index];
                        final isSelected = selectedContacts.contains(userEmail);

                        return ListTile(
                          title: Text(
                            userEmail,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              backgroundColor:
                                  isSelected ? Colors.black : Colors.transparent,
                            ),
                          ),
                          onTap: () {
                            ref
                                .read(selectedContactsProvider.notifier)
                                .toggleContact(userEmail);
                          },
                        );
                      },
                    );
                  } catch (e) {
                    // Handle the exception or log it
                    print('Exception in FutureBuilder: $e');
                    return Center(child: Text('Error: $e'));
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                try {
                  final groupName = groupNameController.text;
                  final selectedUserEmails = ref.read(selectedContactsProvider);

                  if (groupName.isNotEmpty && selectedUserEmails.isNotEmpty) {
                    groupController.createGroup(
                        context, groupName, selectedUserEmails);
                    // Optionally, navigate to a different screen after creating the group
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Group name and at least one contact are required',
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  // Handle the exception or log it
                  print('Exception in onPressed: $e');
                }
              },
              child: const Text('Create Group'),
            ),
          ],
        ),
      ),
    );
  }
}
