import 'package:doctor_application/common/widget/error.dart';
import 'package:doctor_application/common/widget/loader.dart';
import 'package:doctor_application/features/select_contact/controller/select_contact_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectContactScreen extends ConsumerWidget {
  static const String routeName = '/select-contact';

  const SelectContactScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select contact'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: ref.watch(getContactProvider).when(
        data: (contactList) => ListView.builder(
          itemCount: contactList.length,
          itemBuilder: (context, index) {
            final contact = contactList[index];
            return ListTile(
              title: Text(contact['email']),
            );
          },
        ),
        error: (err, trace) => ErrorScreen(error: err.toString()),
        loading: () => const Loader(),
      ),
    );
  }
}
