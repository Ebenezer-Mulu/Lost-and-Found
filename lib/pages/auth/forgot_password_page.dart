import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/button.dart';
import '../../components/inputfeild.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text("Password reset link sent! Check your email"),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 40.0),
          child: Text(
            "Forgot Password",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Enter your email for password reset",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          InputFeild(
            controller: _emailController,
            hintText: "Email",
            obscureText: false,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 25),
          Button(
            onTap: passwordReset,
            text: "Reset Password",
          ),
        ],
      ),
    );
  }
}
