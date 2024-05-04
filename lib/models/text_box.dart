import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  void Function()? onPressed;
  TextBox(
      {super.key,
      required this.text,
      required this.sectionName,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: 320,
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.only(left: 15, bottom: 15),
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: TextStyle(color: Colors.grey[600]),
              ),
              IconButton(
                onPressed: onPressed,
                icon: Icon(
                  Icons.mode_edit_outline,
                  color: Colors.grey[600],
                  size: 20,
                ),
              ),
            ],
          ),
          Text(text)
        ]),
      ),
    );
  }
}
