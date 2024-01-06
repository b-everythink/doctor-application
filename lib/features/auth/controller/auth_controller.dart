import 'package:doctor_application/model/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/auth_repository.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({
    required this.authRepository,
    required this.ref,
  });

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  Future<void> signIn(String email, String password) async {
    try {
      await authRepository.signInWithEmailAndPassword(email, password);
    } catch (e) {
      if (kDebugMode) {
        print('Error during sign in: $e');
      }
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await authRepository.signUpWithEmailAndPassword(email, password);
    } catch (e) {
      if (kDebugMode) {
        print('Error during sign in: $e');
      }
    }
  }

  Future<void> signOut() async {
    try {
      await authRepository.signOut();
    } catch (e) {
      if (kDebugMode) {
        print('Error during sign in: $e');
      }
    }
  }
}
