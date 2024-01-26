import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../components/user_id.dart';
import '../chat/chat_page.dart';

class FoundItemsDetails extends StatelessWidget {
  final String documentId;

  const FoundItemsDetails({required this.documentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Found Item Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Container(
          width: 300,
          height: 600,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection("find_Items")
                .doc(documentId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data != null) {
                  Map<String, dynamic>? data =
                      snapshot.data!.data() as Map<String, dynamic>?;

                  if (data != null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: ListTile(
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Hero(
                                  tag: 'imageHero-$documentId',
                                  child: Center(
                                    child: Container(
                                      width: double.infinity,
                                      height: 300,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(data['image']),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(8.0),
                                          topRight: Radius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text('Item Name: ${data['item_Name']}'),
                                Text('Description: ${data['description']}'),
                                Text('Location: ${data['location']}'),
                                Text('Date: ${data['Date']}'),
                                const SizedBox(height: 10),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: IconButton(
                                    icon: const Icon(Icons.message),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UserID(email: data['email']),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Text('Document data is null');
                  }
                } else {
                  return const Text('Document does not exist');
                }
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
