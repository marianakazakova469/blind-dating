// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uncommon_grounds/pages/input_email_screen.dart';
import 'package:uncommon_grounds/utils/constants.dart';
import 'package:uncommon_grounds/widgets/button_primary.dart';

class PinInputForm extends StatefulWidget {
  const PinInputForm({super.key, required this.verificationId});
  final String verificationId; // passing the verificationId to the OTP screen

  @override
  _PinInputFormState createState() => _PinInputFormState();
}

class _PinInputFormState extends State<PinInputForm> {
  final _formKey = GlobalKey<FormState>();

  // A list that generates one controller for each input field.
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  bool isLoading = false;

  @override
  void dispose() {
    // Dispose all controllers when the widget is disposed.
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (index) {
              return SizedBox(
                height: 70,
                width: 40,
                child: TextFormField(
                  controller: _controllers[index],
                  onChanged: (value) {
                    if (value.length == 1) {
                      FocusScope.of(context).nextFocus();
                    } else if (value.isEmpty && index > 0) {
                      FocusScope.of(context).previousFocus();
                    }
                  },
                  style: TextStyle(
                    color: white,
                    fontFamily: 'Figtree',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  cursorColor: white,
                  cursorHeight: 25,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: grey,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: green,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1), // Limit to one digit.
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              );
            }),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: green,
                  ),
                )
              : ButtonPrimary(
                  label: 'VERIFY',
                  onPressed: () async {
                    // Combine the text from each independent controller.
                    String smsCode = _controllers.map((c) => c.text).join();
                    if (smsCode.isEmpty) {
                      return;
                    }
                    // Set isLoading to true so that the loader is shown.
                    setState(() {
                      isLoading = true;
                    });
                    print("SMS CODE: $smsCode");
                    try {
                      final cred = PhoneAuthProvider.credential(
                        verificationId: widget.verificationId,
                        smsCode: smsCode,
                      );
                      await FirebaseAuth.instance.signInWithCredential(cred);
                      // Navigate to the EmailLogin screen after successful verification.
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EmailLoginScreen()),
                      );
                    } catch (e) {
                      // Handle errors accordingly.
                      print("WRONG CREDENTIALS: $e");
                    }
                    // Reset the loading state.
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
        ],
      ),
    );
  }
}
