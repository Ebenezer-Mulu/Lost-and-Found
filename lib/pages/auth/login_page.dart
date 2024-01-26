import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../components/button.dart';
import '../../components/imageholder.dart';
import '../../components/inputfeild.dart';
import '../../services/auth_service.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //sign user in
  void signUserIn() async {
    // check if email and password are empty
    if (emailController.text.isEmpty && passwordController.text.isEmpty) {
      showErrorMessage("Email and password cannot be empty");
    } else if (emailController.text.isEmpty) {
      showErrorMessage("Email cannot be empty");
    } else if (passwordController.text.isEmpty) {
      showErrorMessage("Password cannot be empty");
    } else {
      // show loading circle
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // update document if not exist
        _fireStore.collection('user').doc(userCredential.user!.uid).update({
          'uid': userCredential.user!.uid,
          'email': emailController.text,
        });

        // pop the loading circle
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // pop the loading circle
        // ignore: use_build_context_synchronously
        Navigator.pop(context);

        // show error to the user
        showErrorMessage(e.code);
      }
    }
  }

  //show Error Message
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
                const SizedBox(height: 50),
                // logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                // Welcome text
                const SizedBox(height: 50),
                const Text(
                  "Welcome",
                  style: TextStyle(
                    color: Color.fromARGB(255, 131, 126, 126),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                // email text field
                InputFeild(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 25),
                // password text field
                InputFeild(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
                // forgot password
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const ForgotPasswordPage();
                          }));
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                // sign in button
                Button(onTap: signUserIn, text: "Sign In"),
                // continue with google
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
                // Google sign-in image
                GestureDetector(
                  onTap: () => AuthService().signInWithGoogle(),
                  child: const ImageHolder(
                    imagepath: 'lib/images/google.png',
                  ),
                ),

                const SizedBox(height: 25),
                // register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Not a member?"),
                    const SizedBox(width: 4),
                    //  onclick
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Register Now?",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
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
