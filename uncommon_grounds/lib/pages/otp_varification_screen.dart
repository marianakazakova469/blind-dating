import 'package:flutter/material.dart';
import 'package:uncommon_grounds/utils/constants.dart';
import 'package:uncommon_grounds/widgets/pin_input.dart';

import 'package:provider/provider.dart';
import '../providers/input_provider.dart';

class OtpVarificationScreen extends StatelessWidget {
  const OtpVarificationScreen({super.key, required this.verificationId});
  final String verificationId; // passing the verifID to the Otp screen

  @override
  Widget build(BuildContext context) {
    // final storedPin= Provider.of<InputProvider>(context, listen: true).inputPin;
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
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter verification code',
                        style: TextStyle(
                            color: white,
                            fontSize: 25,
                            fontFamily: 'Figtree',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.50),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Please enter the code we have sent to ',
                              style: TextStyle(
                                color: purple,
                                fontSize: 16,
                                fontFamily: 'Figtree',
                                fontWeight: FontWeight.w400,
                                height: 1.38,
                                letterSpacing: 0.32,
                              ),
                            ),
                            TextSpan(
                              text: Provider.of<InputProvider>(context)
                                  .phoneNumber,
                              style: TextStyle(
                                color: purple,
                                fontSize: 16,
                                fontFamily: 'Figtree',
                                fontWeight: FontWeight.w700,
                                height: 1.38,
                                letterSpacing: 0.32,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      PinInputForm(
                        verificationId: verificationId,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
