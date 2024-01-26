import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../pages/chat/chat_page.dart';

class UserID extends StatelessWidget {
  final String email;

  UserID({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(email);
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection("user")
          .where('email', isEqualTo: email)
          .get()
          .then((querySnapshot) => querySnapshot.docs.first),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.done) {
          if (userSnapshot.hasData && userSnapshot.data != null) {
            Map<String, dynamic>? userData =
                userSnapshot.data!.data() as Map<String, dynamic>?;

            // Now you have the user data, you can use it in your widget
            if (userData != null) {
              return ChatPage(
                receiverUserEmail: userData['email'],
                receiverUserID: userData['uid'],
                receiverUsername: userData['username'],
              );
            } else {
              return const Text('User data is null');
            }
          } else {
            return const Text('User document does not exist');
          }
        } else {
          // Handle the loading state of the user data
          return const LinearProgressIndicator();
        }
      },
    );
  }
}
