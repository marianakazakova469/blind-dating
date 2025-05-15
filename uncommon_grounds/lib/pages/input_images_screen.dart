// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:face_verify/face_verify.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uncommon_grounds/main.dart' as widget;
import 'package:uncommon_grounds/pages/safety_information_screen.dart';
import 'package:uncommon_grounds/utils/constants.dart';
import 'package:uncommon_grounds/widgets/button_primary.dart';

class AddRecentImages extends StatefulWidget {
  final List<CameraDescription> cameras;

  const AddRecentImages({super.key, required this.cameras});

  @override
  _AddRecentImagesState createState() => _AddRecentImagesState();
}

class _AddRecentImagesState extends State<AddRecentImages> {
  List<UserModel> users = [];

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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.symmetric(vertical: 50),
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
                            'Add recent images of yourself',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: white),
                          ),
                        ),
                        Text(
                          '*Add image will be revealed to your match partner after 5 days of chatting',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: purple),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            3, // generates three buttons dynamically
                            (index) => DottedBorder(
                              color: purple,
                              dashPattern: [8, 4],
                              strokeWidth: 2,
                              child: IconButton(
                                icon: const Icon(Icons.photo_library_rounded),
                                iconSize: 72,
                                color: Colors.white,
                                onPressed: () async {
                                  final ImagePicker picker = ImagePicker();
                                  final List<XFile> images =
                                      await picker.pickMultiImage();
        
                                  List<RegisterUserInputModel> selectedImages =
                                      images.map((e) {
                                    log(e.name);
                                    return RegisterUserInputModel(
                                      name: e.name,
                                      imagePath: e.path,
                                    );
                                  }).toList();
        
                                  // make sure that 'cameras' is available before using it
                                  if (widget.cameras.isNotEmpty) {
                                    users = await registerUsers(
                                      registerUserInputs: selectedImages,
                                      cameraDescription: widget.cameras[0],
                                    );
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            Container(
              margin: EdgeInsets.only(bottom: 30),
              child: ButtonPrimary(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          // navigate to the next page and passing the available cameras and user list as parameters
                          SafetyInformationScan(cameras: widget.cameras, users: users),
                    ),
                  );
                },
                label: 'NEXT',
              ),
            ),
          ],
        ),
      ),
    );
  }
}