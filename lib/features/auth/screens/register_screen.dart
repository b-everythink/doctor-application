// ignore_for_file: use_build_context_synchronously

import 'package:doctor_application/common/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/auth_controller.dart';

class RegisterScreen extends ConsumerWidget {
  static const String routeName = '/register-screen';
  const RegisterScreen({Key? key}) : super(key: key);

  void navigateToRegister(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(authControllerProvider);

    // text editing controllers
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    void signUp() async {
      try {
        if (passwordController.text != confirmPasswordController.text) {
          showSnackBar(context: context, content: "Passwords do not match");
        }
        await authController.signIn(
          emailController.text,
          passwordController.text,
        );

        // Navigate to the next screen upon successful sign-in
        // You can replace the line below with your navigation logic
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        // Handle the error (show snackbar or any other UI feedback)
        // You can replace the line below with your error handling logic
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
            ),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF86B6F6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),

                // DOC
                const Text(
                  'DOC',
                  style: TextStyle(
                    color: Color(0xFF176B87),
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

                // welcome back
                const Text(
                  'Create Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 25),

                // email textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // password textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // password textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      hintText: 'Confirm Password',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // forgot password?
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // sign in button
                GestureDetector(
                  onTap: signUp,
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    margin: const EdgeInsets.symmetric(horizontal: 35),
                    decoration: BoxDecoration(
                      color: const Color(0xFF176B87),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFB4D4FF)),
                    ),
                    child: const Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already a member?',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => navigateToRegister(context),
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
