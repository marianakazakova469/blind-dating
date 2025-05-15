// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:uncommon_grounds/main.dart';
import 'package:uncommon_grounds/pages/input_distance_preference_screen.dart';
import 'package:uncommon_grounds/pages/input_images_screen.dart';
import 'package:uncommon_grounds/utils/constants.dart';
import 'package:uncommon_grounds/widgets/button_primary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// used the structure of a previously existing custom radion button
// from this website -> https://medium.com/flutter-community/create-custom-radio-input-in-flutter-8d94a273d374
class InputLongevityScreen {
  final String name;
  final bool isSelected;

  InputLongevityScreen(this.name, this.isSelected);

  InputLongevityScreen copyWith({bool? isSelected}) {
    return InputLongevityScreen(name, isSelected ?? this.isSelected);
  }
}

class CustomRadio extends StatelessWidget {
  final InputLongevityScreen longevity;

  const CustomRadio(this.longevity, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        decoration: BoxDecoration(
          color: longevity.isSelected ? purple : black,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: purple),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        margin: const EdgeInsets.symmetric(vertical: 15),
        child: Text(
          textAlign: TextAlign.center,
          longevity.name,
          style: TextStyle(
            color: longevity.isSelected ? black : white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class LongevitySelector extends StatefulWidget {
  const LongevitySelector({super.key});

  @override
  _LongevitySelectorState createState() => _LongevitySelectorState();
}

class _LongevitySelectorState extends State<LongevitySelector> {
  List<InputLongevityScreen> longevity = [];

  @override
  void initState() {
    super.initState();
    longevity = [
      InputLongevityScreen("Long-term", false),
      InputLongevityScreen("Short-term", false),
      InputLongevityScreen("Still figuring it out", false),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: black,
        iconTheme: const IconThemeData(color: purple),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Text(
                  'What are you looking for?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: 'Figtree',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.50,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'And be honest...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: purple,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  // generate the gender list dynamically
                  itemCount: longevity.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          longevity = longevity.map((gender) {
                            return gender.copyWith(
                                isSelected:
                                    gender.name == longevity[index].name);
                          }).toList();
                        });
                      },
                      child: CustomRadio(longevity[index]),
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: ButtonPrimary(
                  label: 'NEXT',
                  onPressed: () async {
                    // find the selected gender
                    final selectedInterest = longevity
                        .firstWhere((longevity) => longevity.isSelected)
                        .name;

                    try {
                      // save to database
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc('user_unique_id')
                          .set(
                              {
                            'longevity': selectedInterest,
                          },
                              SetOptions(
                                  merge:
                                      true)); // merge to avoid overwriting existing data

                      // navigate to the next screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddRecentImages(cameras: cameras,),
                        ),
                      );
                    } catch (e) {
                      // handle any errors
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error saving gender: $e')),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
