import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lf/pages/auth/login_or_register.dart';
import 'package:lf/pages/home/home_page.dart';

import 'forgot_password_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              //user is logged in
              if (snapshot.hasData) {
                return const HomePage();
              } else {
                return const LoginOrRegisterPage();
              }
            }));
  }
}
