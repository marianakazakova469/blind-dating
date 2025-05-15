// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:uncommon_grounds/pages/input_interested_in_screen.dart';
import 'package:uncommon_grounds/utils/constants.dart';
import 'package:uncommon_grounds/widgets/button_primary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// used the structure of a previously existing custom radion button
// from this website -> https://medium.com/flutter-community/create-custom-radio-input-in-flutter-8d94a273d374
class InputGender {
  final String name;
  final bool isSelected;

  InputGender(this.name, this.isSelected);

  InputGender copyWith({bool? isSelected}) {
    return InputGender(name, isSelected ?? this.isSelected);
  }
}

class CustomRadio extends StatelessWidget {
  final InputGender gender;

  const CustomRadio(this.gender, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        decoration: BoxDecoration(
          color: gender.isSelected ? purple : black,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: purple),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        margin: const EdgeInsets.symmetric(vertical: 15),
        child: Text(
          textAlign: TextAlign.center,
          gender.name,
          style: TextStyle(
            color: gender.isSelected ? black : white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class GenderSelector extends StatefulWidget {
  const GenderSelector({super.key});

  @override
  _GenderSelectorState createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  List<InputGender> genders = [];

  @override
  void initState() {
    super.initState();
    genders = [
      InputGender("Female", false),
      InputGender("Male", false),
      InputGender("Non-binary", false),
      InputGender("Other", false),
      InputGender("Prefer not to say", false),
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
                  'What is your gender?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.50,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  // generate the gender list dynamically
                  itemCount: genders.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          genders = genders.map((gender) {
                            return gender.copyWith(
                                isSelected: gender.name == genders[index].name);
                          }).toList();
                        });
                      },
                      child: CustomRadio(genders[index]),
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
                    final selectedGender =
                        genders.firstWhere((gender) => gender.isSelected).name;

                    try {
                      // save to database
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc('user_unique_id')
                          .set(
                              {
                            'gender': selectedGender,
                          },
                              SetOptions(
                                  merge:
                                      true)); // merge to avoid overwriting existing data

                      // navigate to the next screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InterestedInSelector(),
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
