import 'package:doctor_application/features/select_contact/repository/select_contact_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getContactProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final selectContactRepository = ref.watch(selectContactRepositoryProvider);
  return selectContactRepository.getContacts();
});

final selectContactControllerProvider = Provider((ref) {
  final selectContactRepository = ref.watch(selectContactRepositoryProvider);
  return SelectContactController(
    ref: ref,
    selectContactRepository: selectContactRepository,
  );
});

class SelectContactController {
  final ProviderRef ref;
  final SelectContactRepository selectContactRepository;
  SelectContactController({
    required this.ref,
    required this.selectContactRepository,
  });

  // void selectContact(Contact selectedContact, BuildContext context) {
  //   selectContactRepository.selectContact(selectedContact, context);
  // }
}