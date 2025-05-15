// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uncommon_grounds/utils/constants.dart';
import 'package:uncommon_grounds/widgets/button_primary.dart';
import 'package:uncommon_grounds/pages/app_explanation_screen.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isCheckedTerms = false;
  bool isCheckedUpdates = false;

  void _saveUserData() async {
    String email = _emailController.text.trim();// remove any leading and trailing whitespace from the email

    if (email.isEmpty || !isCheckedTerms || !isCheckedUpdates) {
      // show an alert if validation fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter email and check both boxes.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // save data to database
      await _firestore.collection('users').doc('user_unique_id').set({
        'email': email,
      }, SetOptions(merge: true));
      

      // push the next screen into the navigation stack
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AppExplanation()),
      );
    } catch (error) {
      log("Error saving data: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving data. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // if the user has opened the keybpard and they click out of it
      // then the keyboard will close
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: black,
            iconTheme: const IconThemeData(color: purple),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Image.asset('assets/images/logo.png'),
              ),
            ],
          ),
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Enter your e-mail address",
                          style: TextStyle(
                            color: white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.50,
                          ),
                        ),
                        SizedBox(height: 30),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          inputFormatters: [
                            FilteringTextInputFormatter.singleLineFormatter
                          ],
                          style: TextStyle(
                            color: white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          cursorColor: white,
                          decoration: InputDecoration(
                            fillColor: Color(0xFF2B272D),
                            filled: true,
                            labelText: 'E-mail',
                            labelStyle: TextStyle(
                                color: grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.42),
                            hintText: 'example@gmail.com',
                            hintStyle: TextStyle(
                                color: grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.42),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: grey, width: 2.0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: green, width: 2.0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 60),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              // change the color of the background and the checkmark 
                              // if the box is checked
                              value: isCheckedTerms,
                              onChanged: (bool? value) {
                                setState(() {
                                  isCheckedTerms = value ?? false;
                                });
                              },
                              activeColor: purple,
                              checkColor: black,
                              side: BorderSide(width: 1, color: purple),
                            ),
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'I have read the ',
                                      style: TextStyle(
                                        color: white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Terms of use.',
                                      style: TextStyle(
                                        color: purple,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Checkbox(
                              // change the color of the background and the checkmark 
                              // if the box is checked
                              value: isCheckedUpdates,
                              onChanged: (bool? value) {
                                setState(() {
                                  isCheckedUpdates = value ?? false;
                                });
                              },
                              activeColor: purple,
                              checkColor: black,
                              side: BorderSide(width: 1, color: purple),
                            ),
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'I want to receive ',
                                      style: TextStyle(
                                        color: white,
                                        fontSize: 14,
                                        fontFamily: 'Figtree',
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'email updates and advertisements.',
                                      style: TextStyle(
                                        color: purple,
                                        fontSize: 14,
                                        fontFamily: 'Figtree',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                ButtonPrimary(
                  label: 'NEXT',
                  onPressed: _saveUserData, // calls the Firestore save function to save the data in the database
                ),
              ],
            ),
          ))),
    );
  }
  // avoid performance issues and memory leaks
  // used to clean up resources when a widget is removed from the widget tree permanently.
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
