import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../found_items/found_items.dart';

class FoundPost extends StatefulWidget {
  const FoundPost({Key? key}) : super(key: key);

  @override
  _FoundPostState createState() => _FoundPostState();
}

class _FoundPostState extends State<FoundPost> {
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> _deleteItem(String documentId) async {
    await FirebaseFirestore.instance
        .collection("find_Items")
        .doc(documentId)
        .delete();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference findItemsCollection =
        FirebaseFirestore.instance.collection("find_Items");

    return FutureBuilder<QuerySnapshot>(
      future: findItemsCollection.where('email', isEqualTo: user!.email).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('Document does not exist'));
        }

        List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: documents.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data =
                  documents[index].data() as Map<String, dynamic>;
              String documentId = documents[index].id;

              return Card(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (data['image'] != null)
                          Container(
                            width: 300, // Set a fixed width for each card
                            height: 300,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(data['image']),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        const SizedBox(height: 20.0),
                        Row(
                          children: [
                            const Text(
                              "Item Name : ",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              data['item_Name'],
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Description: ",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              data['description'],
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Location: ",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              data['location'],
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Date: ",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              data['Date'],
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FoundItems(
                                      initialData: {
                                        'Item_Name': data['item_Name'],
                                        'Description': data['description'],
                                        'Location': data['location'],
                                        'Date': data['Date'],
                                        'Time': data['Time'],
                                        'Image': data['image'],
                                      },
                                      documentId:
                                          documentId, // Pass the document ID to FoundItems
                                    ),
                                  ),
                                ).then((value) {
                                  setState(() {});
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Delete Item'),
                                      content: const Text(
                                        'Are you sure you want to delete this item?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _deleteItem(documentId);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                ).then((value) {
                                  setState(() {});
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
