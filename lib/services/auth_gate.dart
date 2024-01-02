import 'package:doctor_application/pages/home.dart';
import 'package:doctor_application/services/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (constext, snapshot) {
            if (snapshot.hasData) {
              return const Home();
            } else {
              return const LoginOrRegister();
            }
          }),
    );
  }
}
