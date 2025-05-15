// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart'; // used for authorisation
import 'package:flutter/material.dart';
import 'package:uncommon_grounds/pages/otp_varification_screen.dart'; //gets next screen
import 'package:uncommon_grounds/utils/constants.dart';
import 'package:uncommon_grounds/widgets/button_primary.dart'; //gets button
import 'package:uncommon_grounds/widgets/phone_input_field.dart'; // gets input widget

import 'package:provider/provider.dart';
import '../providers/input_provider.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({super.key});

  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  bool isLoading = false;
  bool isProcessing = false;
  @override
  Widget build(BuildContext context) {
    final storedPhoneInput =
        Provider.of<InputProvider>(context, listen: true).phoneNumber;
    return GestureDetector(
      // Wrap the Scaffold so that any tap will unfocus
      // the phone input and close the keyboard
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
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
          // I've put the single child scroll view to prevent overflow of the body
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign up',
                      style: TextStyle(
                        fontFamily: 'Figtree',
                        color: green,
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.75,
                      ),
                    ),
                    Text(
                      'Create your account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Figtree',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.48,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "What's your phone number?",
                      style: TextStyle(
                        color: white,
                        fontSize: 25,
                        fontFamily: 'Figtree',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.75,
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                'By entering your phone number, you will be sent a ',
                            style: TextStyle(
                              color: white,
                              fontSize: 15,
                              fontFamily: 'Figtree',
                              fontWeight: FontWeight.w300,
                              height: 1.40,
                              letterSpacing: 0.45,
                            ),
                          ),
                          TextSpan(
                            text: '6-digit',
                            style: TextStyle(
                              color: white,
                              fontSize: 15,
                              fontFamily: 'Figtree',
                              fontWeight: FontWeight.w700,
                              height: 1.40,
                              letterSpacing: 0.45,
                            ),
                          ),
                          TextSpan(
                            text: ' ',
                            style: TextStyle(
                              color: white,
                              fontSize: 15,
                              fontFamily: 'Figtree',
                              fontWeight: FontWeight.w300,
                              height: 1.40,
                              letterSpacing: 0.45,
                            ),
                          ),
                          TextSpan(
                            text: 'verification code',
                            style: TextStyle(
                              color: white,
                              fontSize: 15,
                              fontFamily: 'Figtree',
                              fontWeight: FontWeight.w700,
                              height: 1.40,
                              letterSpacing: 0.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const PhoneInputField(),
                        const SizedBox(height: 8),
                        Text(
                          '*Please, write your number starting with your country code',
                          style: TextStyle(
                            color: green,
                            fontSize: 10,
                            fontFamily: 'Figtree',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 60),

                const SizedBox(height: 90),

                // setting a loading progress indicator to prevent excess button smash
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: green,
                        ),
                      )
                    : ButtonPrimary(
                        label: 'NEXT',
                        onPressed: () async {
                          if (storedPhoneInput == null ||
                              storedPhoneInput == '') {
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });
                          await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: storedPhoneInput,
                            verificationCompleted:
                                (PhoneAuthCredential credential) {
                              // Optionally handle auto-retrieval here
                            },
                            verificationFailed: (FirebaseAuthException e) {
                              // Handle error and re-enable button
                              setState(() {
                                isLoading = false;
                              });
                              // Optionally, show an error message
                            },
                            codeSent: (String verificationId,
                                int? forceresendingToken) {
                              // Reset loading state when code is sent
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OtpVarificationScreen(
                                    verificationId: verificationId,
                                  ),
                                ),
                              );
                            },
                            codeAutoRetrievalTimeout: (String verificationId) {
                              // You can handle timeout if needed
                            },
                          );
                        },
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
