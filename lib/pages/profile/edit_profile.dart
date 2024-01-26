import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../components/text_box.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  final usersCollection = FirebaseFirestore.instance.collection('user');
  File? _image;
  String? imageUrl; // Store the image URL

  Future<void> imagePicker() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    // Generate a more robust unique filename
    String uniqueFileName =
        '${DateTime.now().millisecondsSinceEpoch}_${UniqueKey()}';

    // Upload to Firebase
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('profile');

    // Create a reference for the image
    Reference referenceImageToupload = referenceDirImages.child(uniqueFileName);

    // Store the file
    try {
      await referenceImageToupload.putFile(File(file.path));
      imageUrl = await referenceImageToupload.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('user')
          .doc(currentUser?.uid)
          .update({
        'Profile': imageUrl,
      });

      print('Image uploaded successfully. URL: $imageUrl');

      // Reload user details after updating the profile picture
      setState(() {});

      // Alternatively, you can use a FutureBuilder to reload the data
      // based on a new Future that fetches the updated user details.
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> editField(String field, String? defaultValue) async {
    String? newValue;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit $field",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          controller: TextEditingController(text: defaultValue),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              // Update in Firestore
              if (newValue != null && newValue!.trim().isNotEmpty) {
                await updateUserField(field, newValue!);
                // Rebuild the widget to reflect the changes
                setState(() {});
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> updateUserField(String field, String value) async {
    try {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(currentUser?.uid)
          .update({field: value});
    } catch (e) {
      print("Error updating user $field: $e");
      // Handle the error appropriately.
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection("user")
          .doc(currentUser?.uid)
          .get();

      if (snapshot.exists) {
        return snapshot;
      } else {
        print("User document does not exist for UID: ${currentUser?.uid}");
        return snapshot;
      }
    } catch (e) {
      print("Error fetching user details: $e");
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // Implement the logic to fetch and reload user details
          setState(() {});
        },
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: getUserDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              Map<String, dynamic>? user = snapshot.data?.data();

              if (user != null) {
                return ListView(
                  children: [
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100),
                      child: Row(
                        children: [
                          user['Profile'] != null
                              ? CircleAvatar(
                                  radius: 70,
                                  backgroundImage:
                                      NetworkImage(user['Profile']),
                                )
                              : _image != null
                                  ? CircleAvatar(
                                      radius: 50,
                                      backgroundImage: FileImage(_image!),
                                    )
                                  : const CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.grey,
                                    ),
                          Padding(
                            padding: const EdgeInsets.only(top: 88.0),
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt),
                              onPressed: imagePicker,
                              tooltip: 'Change Profile Picture',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      user['email'] ?? 'No email',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text(
                        'My Details',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    TextBoxs(
                      text: user['email'],
                      sectionName: "Email",
                      onPressed: () => editField('email', user['email']),
                    ),
                    TextBoxs(
                      text: user['username'],
                      sectionName: "Username",
                      onPressed: () => editField('username', user['username']),
                    ),
                  ],
                );
              } else {
                return const Text('User data is null');
              }
            } else {
              return const Text('No data');
            }
          },
        ),
      ),
    );
  }
}
