import 'package:flutter/material.dart';

class TextForm extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final String hintText;
  final IconData iconData;
  final int maxLines;
  final void Function()? onPressed;

  const TextForm({
    Key? key,
    required this.text,
    required this.controller,
    required this.hintText,
    required this.iconData,
    required this.maxLines,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines, // Add maxLines property
      decoration: InputDecoration(
        labelText: text,
        hintText: hintText,
        prefixIcon: Icon(iconData),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: onPressed,
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
    );
  }
}
