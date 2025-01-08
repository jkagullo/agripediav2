import 'package:flutter/material.dart';

class AddCropButton extends StatelessWidget {

  final Function()? onTap;
  final String text;
  const AddCropButton({
    super.key,
    required this.onTap,
    required this.text,
});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 35.0),
        decoration: BoxDecoration(
          color: Colors.lightGreen[900],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text( text,
            style: TextStyle(
              color: Colors.lightGreen[50],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
