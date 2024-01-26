import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../components/Text_form.dart';
import '../../components/button.dart';
import '../../components/notification.dart';

class FoundItems extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final String? documentId;
  FoundItems({Key? key, this.initialData, this.documentId}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;

  @override
  State<FoundItems> createState() => _FoundItemsState();
}

class _FoundItemsState extends State<FoundItems> {
  final CustomNotification _customNotification = CustomNotification();
  late TextEditingController _itemNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _dateTimeController;
  late TextEditingController _imageController;

  DateTime _dateTime = DateTime.now();
  String imageUrl = "";
  String formattedDate = "";
  String formattedTime = "";

  @override
  void initState() {
    super.initState();

    _itemNameController =
        TextEditingController(text: widget.initialData?['Item_Name'] ?? '');
    _descriptionController =
        TextEditingController(text: widget.initialData?['Description'] ?? '');
    _locationController =
        TextEditingController(text: widget.initialData?['Location'] ?? '');

    _imageController =
        TextEditingController(text: widget.initialData?['Image'] ?? imageUrl);

    if (widget.initialData != null) {
      formattedDate = widget.initialData!['Date'] ?? '';
      formattedTime = widget.initialData!['Time'] ?? '';
      _dateTimeController = TextEditingController(text: formattedDate);
    } else {
      _dateTimeController = TextEditingController();
    }
  }

  void imagePicker() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    // Generate a more robust unique filename
    String uniqueFileName =
        '${DateTime.now().millisecondsSinceEpoch}_${UniqueKey()}';

    // Upload to Firebase
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    // Create a reference for the image
    Reference referenceImageToupload = referenceDirImages.child(uniqueFileName);

    // Store the file
    try {
      File imageFile = File(file.path);
      await referenceImageToupload.putFile(imageFile);

      // Ensure that the URI is a valid download URL
      imageUrl = await referenceImageToupload.getDownloadURL();
      print('Image uploaded successfully. URL: $imageUrl');

      // Update the _imageController with the selected image URL
      _imageController.text = imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  void _showDatePicker() {
    DateTime thirtyDaysAgo = DateTime.now().subtract(Duration(days: 30));

    showDatePicker(
      context: context,
      firstDate: thirtyDaysAgo,
      lastDate: DateTime.now(),
      initialDate: _dateTime.isAfter(thirtyDaysAgo) ? _dateTime : thirtyDaysAgo,
    ).then((value) {
      if (value != null) {
        setState(() {
          _dateTime = value;
          formattedDate = DateFormat('MMM d, y').format(_dateTime);
          formattedTime = DateFormat.jm().format(_dateTime);
          _dateTimeController.text = formattedDate; // Update text field
        });
      }
    });
  }

  Future updateItemDetail(BuildContext context, String documentId) async {
    try {
      // Get the reference to the document
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('find_Items').doc(documentId);

      // Update the document
      await documentReference.update({
        'item_Name': _itemNameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'location': _locationController.text.trim(),
        'Date': formattedDate,
        'Time': formattedTime,
        'image': imageUrl,
      });

      // Close the loading indicator
      Navigator.pop(context);

      // Reload data on the FoundPost screen
      setState(() {});
    } catch (e) {
      print("Error updating item: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update item. Please try again.'),
        ),
      );
    }
  }

  Future addItemDetail(BuildContext context) async {
    try {
      if (_itemNameController.text.trim().isEmpty ||
          _descriptionController.text.trim().isEmpty ||
          _locationController.text.trim().isEmpty ||
          _imageController.text.trim().isEmpty ||
          _dateTimeController.text.trim().isEmpty) {
        // Show a pop-up message if any field is empty
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Incomplete Form'),
              content: const Text('Please fill in all the fields.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return; // Stop the process if any field is empty
      }

      // Capture the context
      BuildContext dialogContext = context;

      // Show a loading indicator
      showDialog(
        context: dialogContext,
        builder: (context) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Submitting...'),
              ],
            ),
          );
        },
      );

      // Add item detail
      await FirebaseFirestore.instance.collection('find_Items').add({
        'email': widget.user.email,
        'item_Name': _itemNameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'location': _locationController.text.trim(),
        'Date': formattedDate,
        'Time': formattedTime,
        'image': imageUrl,
      });
      String message =
          'You have added a new Found item${_descriptionController.text.trim()}';
      _customNotification.triggerNotification(message);
      await FirebaseFirestore.instance.collection('notification').add({
        'email': widget.user.email,
        'message': message,
      });

      // Close the loading indicator
      // ignore: use_build_context_synchronously
      Navigator.pop(dialogContext);

      // Clear input fields
      _itemNameController.clear();
      _descriptionController.clear();
      _locationController.clear();
      _imageController.clear();
      _dateTimeController.clear();
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit item. Please try again.'),
        ),
      );
    }
  }

  Future editItemDetail(BuildContext context, String documentId) async {
    try {
      if (_itemNameController.text.trim().isEmpty ||
          _descriptionController.text.trim().isEmpty ||
          _locationController.text.trim().isEmpty ||
          _imageController.text.trim().isEmpty ||
          _dateTimeController.text.trim().isEmpty) {
        // Show a pop-up message if any field is empty
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Incomplete Form'),
              content: const Text('Please fill in all the fields.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return; // Stop the process if any field is empty
      }

      // Capture the context
      BuildContext dialogContext = context;

      // Show a loading indicator
      showDialog(
        context: dialogContext,
        builder: (context) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Submitting...'),
              ],
            ),
          );
        },
      );

      // edit item detail
      await FirebaseFirestore.instance
          .collection('find_Items')
          .doc(widget.documentId)
          .update({
        'email': widget.user.email,
        'item_Name': _itemNameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'location': _locationController.text.trim(),
        'Date': formattedDate,
        'Time': formattedTime,
        'image': _imageController.text.trim() ?? imageUrl,
      });

      // Close the loading indicator
      // ignore: use_build_context_synchronously
      Navigator.pop(dialogContext);

      // Clear input fields
      _itemNameController.clear();
      _descriptionController.clear();
      _locationController.clear();
      _imageController.clear();
      _dateTimeController.clear();
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit item. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if the widget is used for editing
    bool isEditing = widget.initialData != null;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Fill the Form",
                  style: TextStyle(fontSize: 40, color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 30),
              TextForm(
                text: 'Item Name',
                controller: _itemNameController,
                hintText: 'Enter the item name',
                iconData: Icons.shopping_bag,
                maxLines: 1,
                onPressed: () {
                  _itemNameController.clear();
                },
              ),
              const SizedBox(height: 16),
              TextForm(
                text: 'Description',
                controller: _descriptionController,
                hintText: 'Enter a description',
                iconData: Icons.description,
                maxLines: 3,
                onPressed: () {
                  _descriptionController.clear();
                },
              ),
              const SizedBox(height: 16),
              TextForm(
                text: 'Enter the location',
                controller: _locationController,
                hintText: "Location where it was lost",
                iconData: Icons.location_on,
                maxLines: 1,
                onPressed: () {
                  _locationController.clear();
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Image of the item',
                  hintText: 'Load Image',
                  prefixIcon: const Icon(Icons.camera_alt),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _imageController.clear();
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(12.0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey.shade900),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                onTap: imagePicker,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateTimeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date when it was lost',
                  hintText: 'Enter the date',
                  prefixIcon: const Icon(Icons.calendar_month_outlined),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _dateTimeController.clear();
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(12.0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey.shade900),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                onTap: _showDatePicker,
              ),
              const SizedBox(height: 16),
              Button(
                onTap: () async {
                  if (isEditing) {
                    await editItemDetail(context, widget.documentId ?? '');
                  } else {
                    await addItemDetail(context);
                  }

                  // If used for editing, pop the current screen after adding the item
                  if (isEditing) {
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  }
                },
                text: 'Submit',
              ),

              // Show the back button only when editing
              if (isEditing) ...[
                const SizedBox(height: 16),
                Button(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  text: 'Back',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
