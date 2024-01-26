import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../pages/lost_items/lost_item_details.dart';

class GetLostItem extends StatelessWidget {
  final String documentId;

  GetLostItem({
    Key? key,
    required this.documentId,
  }) : super(key: key);

  void navigateToLostItemDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LostItemDetails(documentId: documentId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("lost_Items").doc(documentId);

    return FutureBuilder<DocumentSnapshot>(
      future: documentReference.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            Map<String, dynamic>? data =
                snapshot.data!.data() as Map<String, dynamic>?;

            if (data != null) {
              return GestureDetector(
                onTap: () => navigateToLostItemDetails(context),
                child: SizedBox(
                  // width: 300,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: ListTile(
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Item Name :",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(' ${data['Item_Name']}',
                                    style: const TextStyle(fontSize: 20)),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Date :",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  ' ${data['Date']}',
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return const Text('Document data is null');
            }
          } else {
            return const Text('Document does not exist');
          }
        }
        return const Text('Loading ...');
      },
    );
  }
}
