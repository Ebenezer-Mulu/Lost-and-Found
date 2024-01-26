import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../components/button.dart';
import '../../components/deleteLF.dart';

class DeleteAccount extends StatefulWidget {
  @override
  _DeleteAccountState createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _passwordController = TextEditingController();

  Future<void> _deleteAccount() async {
    String message = '';

    try {
      User? user = _auth.currentUser;

      if (user != null) {
        // Show dialog to get the user's password
        bool passwordMatched = await _showPasswordInputDialog();

        if (passwordMatched) {
          // Reauthenticate the user before deleting the account
          AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!,
            password: _passwordController.text,
          );

          await user.reauthenticateWithCredential(credential);

          // Delete the account
          await user.delete();

          // Delete documents from different collections
          List<String> collection = ["lost_Items", "user", "find_Items"];

          for (int i = 0; i < collection.length; i++) {
            deleteDocumentByEmail(user.email!, collection[i]);
          }

          message = 'User account deleted successfully';
        } else {
          message = 'Incorrect password entered';
        }
      } else {
        message = 'No user signed in';
      }
    } on FirebaseAuthException catch (e) {
      // Check specific error codes and provide more informative messages
      if (e.code == 'requires-recent-login') {
        message =
            'This operation is sensitive and requires recent authentication. Please log in again.';
      } else {
        message = 'Failed to delete account: ${e.message}';
      }
    }

    // Display message using a SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<bool> _showPasswordInputDialog() async {
    _passwordController.clear();
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Password'),
          content: TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUserDocuments(String userEmail) async {
    // List of collections to delete documents from
    List<String> collections = ["lost_Items", "user", "find_Items"];

    for (String collection in collections) {
      await deleteDocumentByEmail(userEmail, collection);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 100.0),
            child: Text(
              "Press the Button to Delete Account",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          const SizedBox(height: 100),
          GestureDetector(
            onTap: _deleteAccount,
            child: Container(
              height: 80,
              padding: const EdgeInsets.all(25),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(8)),
              child: const Center(
                child: Text(
                  "Delete Account",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
