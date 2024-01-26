import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lf/pages/lost_items/lost_item_details.dart';

class GetNotification extends StatelessWidget {
  User? user;
  String? email;

  @override
  Widget build(BuildContext context) {
    user = FirebaseAuth.instance.currentUser;
    email = user?.email;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text(
          "Notification",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('notification')
            .where('email', isEqualTo: email)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No Notifications Available for $email',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            );
          }

          var notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notification = notifications[index];
              var notificationContent = notification['message'] as String;
              var documentId = notification.id;

              return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) async {
                  // Remove the item from the database
                  await FirebaseFirestore.instance
                      .collection('notification')
                      .doc(documentId)
                      .delete();
                },
                background: Container(
                  color: Colors
                      .black, // Set your preferred delete background color
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16.0),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LostItemDetails(documentId: documentId),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      notificationContent,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
