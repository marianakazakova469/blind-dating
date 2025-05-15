import 'package:flutter/material.dart';
import 'package:uncommon_grounds/pages/input_name.dart';
import 'package:uncommon_grounds/utils/constants.dart';
import 'package:uncommon_grounds/widgets/button_primary.dart';

class AppExplanation extends StatelessWidget {
  const AppExplanation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Welcome to Uncommon Ground',
                    style: TextStyle(
                      color: white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.14,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    spacing: 20,
                    children: [
                      Text(
                        'What does our app do?',
                        style: TextStyle(
                          color: green,
                          fontSize: 22,
                          fontFamily: 'Figtree',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Connect with strangers on a level beyond the physical',
                            style: TextStyle(
                              color: white,
                              fontSize: 18,
                              fontFamily: 'Figtree',
                              fontWeight: FontWeight.normal,
                              height: 1.22,
                            ),
                          ),
                          Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                            style: TextStyle(
                              color: white,
                              fontSize: 14,
                              fontFamily: 'Figtree',
                              fontWeight: FontWeight.normal,
                              height: 1.29,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Engage in meaninful conversations',
                            style: TextStyle(
                              color: white,
                              fontSize: 18,
                              fontFamily: 'Figtree',
                              fontWeight: FontWeight.normal,
                              height: 1.22,
                            ),
                          ),
                          Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                            style: TextStyle(
                              color: white,
                              fontSize: 14,
                              fontFamily: 'Figtree',
                              fontWeight: FontWeight.normal,
                              height: 1.29,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ButtonPrimary(
                      label: "NEXT",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InputNameScreen()));
                      })
                ],
              ),
            ),
          ),
        ));
  }
}
