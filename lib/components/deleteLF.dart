import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> deleteDocumentByEmail(String email, String collection) async {
  try {
    // Query for the document with the specified email
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where('email', isEqualTo: email)
        .get();

    // Check if there's a matching document
    if (querySnapshot.docs.isNotEmpty) {
      // Delete the first matching document (assuming there's only one)
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(querySnapshot.docs.first.id)
          .delete();

      print('Document deleted successfully');
    } else {
      print('No document found with the specified email');
    }
  } catch (e) {
    print('Failed to delete document: $e');
  }
}
