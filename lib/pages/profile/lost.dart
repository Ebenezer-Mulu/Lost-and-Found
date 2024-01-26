import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../lost_items/lost_item.dart';

class LostPost extends StatefulWidget {
  LostPost({Key? key}) : super(key: key);

  @override
  _LostPostState createState() => _LostPostState();
}

class _LostPostState extends State<LostPost> {
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> _deleteItem(String documentId) async {
    await FirebaseFirestore.instance
        .collection("lost_Items")
        .doc(documentId)
        .delete();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference lostItemsCollection =
        FirebaseFirestore.instance.collection("lost_Items");

    return FutureBuilder<QuerySnapshot>(
      future: lostItemsCollection.where('email', isEqualTo: user!.email).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            QuerySnapshot querySnapshot = snapshot.data!;
            if (querySnapshot.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: querySnapshot.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data =
                      querySnapshot.docs[index].data() as Map<String, dynamic>;
                  String documentId = querySnapshot.docs[index].id;

                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Container(
                      color: Colors.grey[100],
                      child: ListTile(
                        subtitle: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Item Name:",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    ' ${data['Item_Name']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Description:",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '${data['Description']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Location:",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '${data['Location']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Date:",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '${data['Date']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(left: 85.0),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      color: Colors.grey[400],
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LostItemPage(
                                              initialData: {
                                                'Item_Name': data['Item_Name'],
                                                'Description':
                                                    data['Description'],
                                                'Location': data['Location'],
                                                'Date': data['Date'],
                                                'Time': data['Time'],
                                              },
                                              documentId: documentId,
                                            ),
                                          ),
                                        );
                                        setState(() {});
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      color: Colors.grey[400],
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
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text('You haven\'t added any lost items yet.'),
              );
            }
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
