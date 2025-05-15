import 'package:flutter/material.dart';
import 'package:uncommon_grounds/utils/constants.dart';

class ButtonPrimary extends StatelessWidget {
  // Customize background color and font color to make he widget reusable
  final Color backgroundColor;
  final Color fontColor;
  final String label;
  // in order to accept a function instead of just a route
  final VoidCallback onPressed; 

  const ButtonPrimary({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = green,
    this.fontColor = black,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        padding: EdgeInsets.zero, // making sure to add no extra padding
      ),
      child: SizedBox(
        width: double.infinity,
        height: 80, 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: fontColor,
                  fontSize: 24,
                  fontFamily: 'WorkSans',
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}