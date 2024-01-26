import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/button.dart';
import '../../components/notification.dart';

class LostItemPage extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final String? documentId;

  LostItemPage({Key? key, this.initialData, this.documentId}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;
  final String userToken = "";

  @override
  State<LostItemPage> createState() => _LostItemPageState();
}

class _LostItemPageState extends State<LostItemPage> {
  final CustomNotification _customNotification = CustomNotification();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  DateTime _dateTime = DateTime.now();
  String formattedDate = "";
  String formattedTime = "";

  bool get isEditing => widget.initialData != null;

  @override
  void initState() {
    super.initState();

    if (widget.initialData != null) {
      _itemNameController.text = widget.initialData!['Item_Name'];
      _descriptionController.text = widget.initialData!['Description'];
      _locationController.text = widget.initialData!['Location'];
      formattedDate = widget.initialData!['Date'];
      formattedTime = widget.initialData!['Time'];
      _dateTimeController.text = formattedDate;
    }
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _dateTimeController.dispose();
    super.dispose();
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

  Future addItemDetail(BuildContext context) async {
    if (_itemNameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _dateTimeController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Incomplete Form'),
            content: Text('Please fill in all the fields.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      BuildContext dialogContext = context;

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

      await FirebaseFirestore.instance.collection('lost_Items').add({
        'email': widget.user.email,
        'Item_Name': _itemNameController.text.trim(),
        'Description': _descriptionController.text.trim(),
        'Location': _locationController.text.trim(),
        'Date': formattedDate,
        'Time': formattedTime,
      });

      String message =
          'You have added a new Lost item ${_descriptionController.text.trim()}';
      _customNotification.triggerNotification(message);
      await FirebaseFirestore.instance.collection('notification').add({
        'email': widget.user.email,
        'message': message,
      });

      // ignore: use_build_context_synchronously
      Navigator.pop(dialogContext);
      _itemNameController.clear();
      _descriptionController.clear();
      _locationController.clear();
      _dateTimeController.clear();
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit item. Please try again.'),
        ),
      );
    }
  }

  Future<void> editItemDetail(BuildContext context, String documentId) async {
    if (_itemNameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _dateTimeController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Incomplete Form'),
            content: Text('Please fill in all the fields.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      BuildContext dialogContext = context;

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

      await FirebaseFirestore.instance
          .collection('lost_Items')
          .doc(documentId)
          .update({
        'email': widget.user.email,
        'Ttem_Name': _itemNameController.text.trim(),
        'Description': _descriptionController.text.trim(),
        'Location': _locationController.text.trim(),
        'Date': formattedDate,
        'Time': formattedTime,
      });
      print(_itemNameController.text.trim());
      Navigator.pop(dialogContext);

      _itemNameController.clear();
      _descriptionController.clear();
      _locationController.clear();
      _dateTimeController.clear(); // Close the submitting dialog

      // Trigger a rebuild of the widget tree in the previous screen
      // Pass true as a result to indicate that an item was edited
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to edit item. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              TextFormField(
                controller: _itemNameController,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  hintText: 'Enter the item name',
                  prefixIcon: const Icon(Icons.shopping_bag),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _itemNameController.clear();
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
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter a description',
                  prefixIcon: const Icon(Icons.description),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _descriptionController.clear();
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
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location where it was lost',
                  hintText: 'Enter the location',
                  prefixIcon: const Icon(Icons.location_on),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _locationController.clear();
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
              const SizedBox(height: 30),
              Button(
                onTap: () async {
                  if (isEditing) {
                    await editItemDetail(context, widget.documentId ?? '');
                  } else {
                    await addItemDetail(context);
                  }

                  if (isEditing) {
                    Navigator.pop(context);
                  }
                },
                text: 'Submit',
              ),
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
