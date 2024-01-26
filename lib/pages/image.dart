import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedImagePath = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade800,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                selectImage();
                setState(() {});
              },
              child: selectedImagePath == ''
                  ? Image.asset(
                      'lib/images/image_placeholder.png',
                      height: 200,
                      width: 200,
                      fit: BoxFit.fill,
                    )
                  : Image.file(
                      File(selectedImagePath),
                      height: 200,
                      width: 200,
                      fit: BoxFit.fill,
                    ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future selectImage() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            height: 150,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const Text(
                    'Select Image From !',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          selectedImagePath = await selectImageFromGallery();
                          if (selectedImagePath != '') {
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                            setState(() {});
                          } else {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("No Image Selected !"),
                              ),
                            );
                          }
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              'lib/images/gallery.png',
                              height: 60,
                              width: 60,
                            ),
                            SizedBox(height: 5),
                            Text('Gallery'),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          selectedImagePath = await selectImageFromCamera();
                          if (selectedImagePath != '') {
                            Navigator.pop(context);
                            setState(() {});
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("No Image Captured !"),
                              ),
                            );
                          }
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              'lib/images/camera.png',
                              height: 60,
                              width: 60,
                            ),
                            SizedBox(height: 5),
                            Text('Camera'),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future selectImageFromGallery() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 10);
    return file?.path ?? '';
  }

  Future selectImageFromCamera() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
    return file?.path ?? '';
  }
}
