import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../components/button.dart';
import '../../components/notification.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CustomNotification _customNotification = CustomNotification();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  String _errorMessage = '';
  bool _isPasswordChanged = false;
  bool _isProcessing = false;

  final user = FirebaseAuth.instance.currentUser!;

  Future<void> _updatePassword() async {
    try {
      setState(() {
        _isProcessing = true;
      });

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: user.email!,
        password: _currentPasswordController.text,
      );

      await userCredential.user?.updatePassword(_newPasswordController.text);

      // Password updated successfully
      setState(() {
        _isPasswordChanged = true;
        _errorMessage = '';
        _currentPasswordController.text = '';
        _newPasswordController.text = '';
        _isProcessing = false;
      });

      String message = 'Password updated successfully';
      _customNotification.triggerNotification(message);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isPasswordChanged = false;
        _errorMessage = e.message ?? 'An error occurred';
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Update Password",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Current Password'),
            ),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'New Password'),
            ),
            SizedBox(height: 16.0),
            Button(
              text: _isProcessing ? 'Updating...' : 'Update Password',
              onTap: _isProcessing ? null : () => _updatePassword(),
            ),
            if (_isPasswordChanged)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Password changed successfully!',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
