import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lf/components/data_fetch.dart';

import '../../read_data/get_find_items.dart';

class ViewFoundItem extends StatefulWidget {
  const ViewFoundItem({Key? key}) : super(key: key);

  @override
  _ViewFoundItemState createState() => _ViewFoundItemState();
}

class _ViewFoundItemState extends State<ViewFoundItem> {
  List<String> docIds = [];
  final TextEditingController _searchController = TextEditingController();
  late StreamController<List<String>> _filteredDocIdsController;

  @override
  void initState() {
    super.initState();
    _filteredDocIdsController = StreamController<List<String>>.broadcast();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      docIds = await DataFetcher.getFoundDocIds();
      _filteredDocIdsController.add(docIds);
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  void searchItem() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('find_Items')
          .where('item_Name',
              isGreaterThanOrEqualTo: _searchController.text.trim())
          .where('item_Name', isLessThan: _searchController.text.trim() + 'z')
          .get();

      List<DocumentSnapshot> documents = querySnapshot.docs;

      List<String> filteredDocIds = documents
          .where((doc) {
            String itemName = doc['item_Name'].toString().toLowerCase();
            String date = doc['Date'].toString().toLowerCase();
            return itemName
                    .contains(_searchController.text.trim().toLowerCase()) ||
                date.contains(_searchController.text.trim().toLowerCase());
          })
          .map((doc) => doc.id)
          .toList();

      _filteredDocIdsController.add(filteredDocIds);
    } catch (e) {
      print('Error searching items: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _filteredDocIdsController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.only(left: 25),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    onTap: searchItem,
                    child: const Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<String>>(
              stream: _filteredDocIdsController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final filteredDocIds = snapshot.data ?? docIds;
                return ListView.builder(
                  itemCount: filteredDocIds.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: ListTile(
                          title:
                              GetFoundItem(documentId: filteredDocIds[index]),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
