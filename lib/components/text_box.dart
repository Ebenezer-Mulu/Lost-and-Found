import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextBoxs extends StatelessWidget {
  final String text;
  final String sectionName;
  void Function()? onPressed;

  TextBoxs(
      {super.key,
      required this.text,
      required this.sectionName,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // section Name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: TextStyle(color: Colors.grey[500]),
              ),
              IconButton(
                  onPressed: onPressed,
                  icon: const Icon(Icons.edit),
                  color: Colors.grey[400])
            ],
          ),
          // text
          Text(text),
        ],
      ),
    );
  }
}
