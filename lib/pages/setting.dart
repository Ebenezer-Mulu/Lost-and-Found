import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lost_and_found_items/components/button.dart';

class Setting extends StatelessWidget {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Change Password',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: currentPasswordController,
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: 'Current Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your current password.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: 'New Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a new password.';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Button(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  _showChangePasswordDialog(context);
                }
              },
              text: "Change Password",
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Change Password')),
          content: SizedBox(
            height: 150, // Set your desired height
            child: Column(
              children: [
                TextFormField(
                  controller: currentPasswordController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Current Password'),
                ),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'New Password'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String currentPassword = currentPasswordController.text;
                String newPassword = newPasswordController.text;

                await _changePassword(currentPassword, newPassword, context);

                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              child: const Text(
                'Change',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _changePassword(
      String currentPassword, String newPassword, BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Reauthenticate the user with their current password before updating it
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);

        // Update the user's password
        await user.updatePassword(newPassword);

        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Password changed successfully.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('User not found.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Error changing password: $e'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
