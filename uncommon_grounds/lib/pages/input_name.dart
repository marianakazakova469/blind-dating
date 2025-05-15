import 'package:flutter/material.dart';
import 'package:uncommon_grounds/pages/input_distance_preference_screen.dart';
import 'package:uncommon_grounds/utils/constants.dart';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uncommon_grounds/widgets/button_primary.dart';

class InputNameScreen extends StatefulWidget {
  const InputNameScreen({super.key});

  @override
  State<InputNameScreen> createState() => _InputNameScreenState();
}

class _InputNameScreenState extends State<InputNameScreen> {
  final TextEditingController _nameController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _saveUserData() async {
    String name = _nameController.text.trim(); // remove any leading and trailing whitespace from the name

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your first name.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      String userId = "user_unique_id"; // just placeholder (here should be the firebase authenticator user id)
      // refers to a document location in the database
      DocumentReference userDoc = _firestore.collection('users').doc(userId);

      await userDoc.set(
          {'name': name},
          SetOptions(
              merge:
                  true)); // instead of deleting and recreating the name, this updates the existing name

      if (!mounted) return;

      showDialog(
        context: context,
        // not allow the user to close the popup by clicking outside of it
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
            backgroundColor: green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text.rich(
                textAlign: TextAlign.center,
                TextSpan(children: [
                  TextSpan(
                      text: 'Welcome,',
                      style: TextStyle(
                          color: black,
                          fontSize: 26,
                          fontWeight: FontWeight.w400)),
                  TextSpan(
                      text: ' $name',
                      style: TextStyle(
                          color: black,
                          fontSize: 26,
                          fontWeight: FontWeight.bold)),
                ])),
            content: Text(
              'Get ready to go on a love journey!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: black, fontSize: 16, fontWeight: FontWeight.w400),
            ),
            actions: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonPrimary(
                      backgroundColor: black,
                      fontColor: green,
                      label: 'continue'.toUpperCase(),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InputDistancePreferenceScreen()),// continue to the next page
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // close popup (to allow editing again)
                      },
                      child: Text(
                        "Edit Name",
                        style: TextStyle(
                          color: black,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
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
        behavior: HitTestBehavior.opaque,
        // allows the TextEditingController to close once a user clickss outside of the keyboard
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: black,
          appBar: AppBar(
            backgroundColor: black,
            iconTheme: const IconThemeData(color: purple),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Image.asset('assets/images/logo.png'),
              ),
            ],
          ),
          body: SafeArea(
            // this avoids container overflow by making sure all page content stays inside
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
                            'Enter your first name',
                            style: TextStyle(
                                color: white,
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.50),
                          ),
                          SizedBox(height: 7),
                          Text('This is how you will appear to other users',
                              style: TextStyle(
                                color: purple,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 1.38,
                                letterSpacing: 0.32,
                              )),
                        ],
                      ),
                      SizedBox(height: 40),
                      Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: _nameController,
                                keyboardType: TextInputType.name,
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .singleLineFormatter
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
                                  labelText: 'Name',
                                  labelStyle: TextStyle(
                                      color: grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.42),
                                  hintText: 'Sam',
                                  hintStyle: TextStyle(
                                      color: grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.42),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: grey, width: 2.0),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: green, width: 2.0),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'DISCLAIMER! ',
                                      style: TextStyle(
                                        color: green,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'You ',
                                      style: TextStyle(
                                        color: white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'cannot',
                                      style: TextStyle(
                                        color: green,
                                        decoration: TextDecoration.underline,
                                        decorationThickness: 2,
                                        letterSpacing: 0.72,
                                        decorationColor: green,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          ' change  your name later due to privacy reasons ',
                                      style: TextStyle(
                                        color: white,
                                        decoration: TextDecoration.underline,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  ButtonPrimary(
                    label: 'NEXT',
                    onPressed:
                        _saveUserData, // calls the Firestore save function to save the data in the database
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  // avoid performance issues and memory leaks
  // used to clean up resources when a widget is removed from the widget tree permanently.
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
