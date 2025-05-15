import 'package:flutter/material.dart';
import 'package:uncommon_grounds/utils/constants.dart';

class MatchingScreen extends StatelessWidget {
  const MatchingScreen({super.key});

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
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(
            'Find a match!',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.w900, color: white),
          ),
        ),
      ]),
    );
  }
}
