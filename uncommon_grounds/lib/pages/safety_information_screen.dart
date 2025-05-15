// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:face_verify/face_verify.dart';
import 'package:flutter/material.dart';
import 'package:uncommon_grounds/pages/matching_screen.dart';
import 'package:uncommon_grounds/widgets/button_primary.dart';
import 'package:camera/camera.dart';
import 'package:uncommon_grounds/utils/constants.dart';

class SafetyInformationScan extends StatefulWidget {
  final List<CameraDescription> cameras;
  final List<UserModel> users;

  const SafetyInformationScan({
    super.key,
    required this.cameras,
    required this.users,
  });

  @override
  _SafetyInformationScanState createState() => _SafetyInformationScanState();
}

class _SafetyInformationScanState extends State<SafetyInformationScan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: purple),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            'Safety regulation',
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: white),
                          ),
                        ),
                        Text(
                          'Why it’s important to verify your identity.',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: green),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    Text(
                        'To complete your account setup, we need to confirm your age and identity for the safety of all users. With your permission, we’ll use facial recognition software to verify your identity securely. This quick step helps keep the community authentic and safe.',
                        style: TextStyle(fontSize: 16, color: white))
                  ]),
            ),
            Container(
              margin: EdgeInsets.all(60),
              child: ButtonPrimary(
                onPressed: () async {
                  Set<UserModel>? recognizedUsers = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetectionView(
                        users: widget.users,
                        cameraDescription: widget.cameras[0],
                      ),
                    ),
                  );

                  if (recognizedUsers != null && recognizedUsers.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MatchingScreen(),
                      ),
                    );
                  }
                },
                label: 'OPEN CAMERA',
              ),
            ),
          ],
        ));
  }
}
