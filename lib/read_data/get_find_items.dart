import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../pages/found_items/found_items_details.dart';

class GetFoundItem extends StatelessWidget {
  final String documentId;

  GetFoundItem({Key? key, required this.documentId}) : super(key: key);

  void navigateToFoundItemsDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoundItemsDetails(documentId: documentId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("find_Items").doc(documentId);

    return FutureBuilder<DocumentSnapshot>(
      future: documentReference.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loading state
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Error state
          return const Center(child: Text('Error loading data'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          // Document does not exist
          return const Center(child: Text('Document does not exist'));
        }

        // Data loaded successfully
        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;

        return GestureDetector(
          onTap: () => navigateToFoundItemsDetails(context),
          child: Card(
            elevation: 4.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'imageHero-$documentId',
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      height: 285,
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            const Text(
                              "Item Name :",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              data['item_Name'],
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 0),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          children: [
                            const Text(
                              "Date :",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              data['Date'],
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
