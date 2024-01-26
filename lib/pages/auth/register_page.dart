import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lf/pages/auth/login_page.dart';

import '../../components/button.dart';
import '../../components/emailvalidator.dart';
import '../../components/imageholder.dart';
import '../../components/inputfeild.dart';
import '../../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({Key? key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _fireStore = FirebaseFirestore.instance;

  Future<void> signUserUp(String email, String password) async {
    // Validate input fields
    if (!validateFields()) {
      return;
    }

    try {
      // Validate email using ZeroBounce API
      // bool isEmailValid = await EmailValidator.validateEmail(email);
      // if (!isEmailValid) {
      //   showErrorMessage("Invalid email address");
      //   return;
      // }

      // Validate password matching
      if (passwordController.text == confirmPasswordController.text) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Get the FCM token
        String? fcmToken = await FirebaseMessaging.instance.getToken();

        // Store user details and FCM token in Firestore
        await _fireStore.collection('user').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email,
          'username': emailController.text.split('@')[0],
          'fcmToken': fcmToken,
        });

        // Navigate to the login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        showErrorMessage("Passwords don't match!");
      }
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.code);
    } catch (e) {
      showErrorMessage("Failed to sign up");
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
        );
      },
    );
  }

  bool validateFields() {
    if (emailController.text.isEmpty && passwordController.text.isEmpty) {
      showErrorMessage("Email and password cannot be empty");
      return false;
    } else if (emailController.text.isEmpty) {
      showErrorMessage("Email cannot be empty");
      return false;
    } else if (passwordController.text.isEmpty) {
      showErrorMessage("Password cannot be empty");
      return false;
    } else if (confirmPasswordController.text.isEmpty) {
      showErrorMessage("Rewrite Your Password ");
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                const Icon(
                  Icons.lock_sharp,
                  size: 100,
                ),
                const SizedBox(height: 25),
                const Text(
                  "Create an account",
                  style: TextStyle(
                    color: Color.fromARGB(255, 131, 126, 126),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 15),
                InputFeild(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),
                InputFeild(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 10),
                InputFeild(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 25),
                Button(
                  onTap: () => signUserUp(
                    emailController.text,
                    passwordController.text,
                  ),
                  text: "Sign Up",
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 25),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "Or continue with",
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
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
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () => AuthService().signInWithGoogle(),
                  child: const ImageHolder(
                    imagepath: 'lib/images/google.png',
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Login Now?",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
