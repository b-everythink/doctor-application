import 'package:doctor_application/features/auth/screens/login_screen.dart';
import 'package:doctor_application/common/widget/error.dart';
import 'package:doctor_application/features/auth/screens/register_screen.dart';
import 'package:doctor_application/features/group/screens/create_group_screen.dart';
import 'package:doctor_application/features/landing/landing_screen.dart';
import 'package:doctor_application/features/select_contact/screen/select_contact.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case Home.routeName:
      return MaterialPageRoute(
        builder: (context) => const Home(),
      );
    case RegisterScreen.routeName:
      return MaterialPageRoute(builder: (context) => const RegisterScreen());
    case CreateGroupScreen.routeName:
      return MaterialPageRoute(builder: (context) => CreateGroupScreen());
    case SelectContactScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const SelectContactScreen());

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesn\'t exist'),
        ),
      );
  }
}
