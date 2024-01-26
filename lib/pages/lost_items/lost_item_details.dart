import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../components/user_id.dart';




class LostItemDetails extends StatelessWidget {
  final String documentId;

  
  const LostItemDetails({Key? key,required this.documentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost Item Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Container(
          width: 300,
          height: 225,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection("lost_Items")
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
                                Text('Item Name: ${data['Item_Name']}'),
                                Text('Description: ${data['Description']}'),
                                Text('Location: ${data['Location']}'),
                                Text('Date: ${data['Date']}'),
                                Text('Time: ${data['Time']}'),
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
