// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uncommon_grounds/providers/input_provider.dart';
import 'package:uncommon_grounds/utils/constants.dart';

import 'package:provider/provider.dart';

class PhoneInputField extends StatefulWidget {
  const PhoneInputField({super.key});

  @override
  _PhoneInputFieldState createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  // final TextEditingController _controller = TextEditingController();
  final phoneNumber = TextEditingController();

  // Create a list of controllers for each pin digit.
  final List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());

  @override
  void dispose() {
    // Clean up the controller when the widget is removed.
    phoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phoneInputProvider = Provider.of<InputProvider>(context);
    return GestureDetector(
      // Setting the behavior to opaque ensures taps on empty space are detected.
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // Unfocus removes the focus from the TextField and dismisses the keyboard.
        FocusScope.of(context).unfocus();
      },
      child: TextField(
        controller: phoneNumber, //takes the value of the input
        keyboardType: TextInputType.phone,
        inputFormatters: [
          // Allows only digits and the plus sign (+) to be entered.
          FilteringTextInputFormatter.allow(RegExp(r'[+\d]')),
        ],
        style: TextStyle(
          color: white,
          fontFamily: 'Figtree',
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: white, // Sets the cursor color.
        decoration: InputDecoration(
          fillColor: Color(0xFF2B272D),
          filled: true,
          //With filled=true I can change the color of the input
          labelText: 'Phone Number',
          labelStyle: TextStyle(
              color: grey,
              fontSize: 16,
              fontFamily: 'Figtree',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.42),
          hintText: '+359 1122 4567',
          hintStyle: TextStyle(
              color: grey,
              fontSize: 14,
              fontFamily: 'Figtree',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.42),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: grey, // Color for the enabled border.
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: green, // Color for the focused border.
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),

        onChanged: (value) {
          debugPrint('Phone number: $value');
          phoneInputProvider.updatePhoneNumber(value);
          print(phoneInputProvider.phoneNumber);
        },
      ),
    );
  }
}
