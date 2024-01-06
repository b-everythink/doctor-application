import 'package:doctor_application/common/widget/error.dart';
import 'package:doctor_application/common/widget/loader.dart';
import 'package:doctor_application/features/auth/controller/auth_controller.dart';
import 'package:doctor_application/features/auth/screens/login_screen.dart';
import 'package:doctor_application/firebase_options.dart';
import 'package:doctor_application/features/landing/landing_screen.dart';
import 'package:doctor_application/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        onGenerateRoute: (settings) => generateRoute(settings),
        home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const LoginScreen();
              }
              return const Home();
            },
            error: (err, trace) {
              return ErrorScreen(
                error: err.toString(),
              );
            },
            loading: () => const Loader()),
      );
  }
}
