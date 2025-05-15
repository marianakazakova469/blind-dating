import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:uncommon_grounds/pages/phone_login.dart';
import 'package:uncommon_grounds/utils/constants.dart';
import 'package:provider/provider.dart'; // used to get the input var for phone and otp
import 'providers/input_provider.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBbGy9ALkLicnoRfX9jCjATAfV7uCj3qMU",
        authDomain: "uncommon-grounds-64ee1.firebaseapp.com",
        projectId: "uncommon-grounds-64ee1",
        storageBucket: "uncommon-grounds-64ee1.firebasestorage.app",
        messagingSenderId: "1070853049828",
        appId: "1:1070853049828:web:1cd456093efc1c3268cbf1",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  // Initialize available cameras
  cameras = await availableCameras();
  if (cameras.isEmpty) {
    debugPrint("No cameras available");
  }

  // wrapping MyApp with ChangeNotifierProvider so that InputProvider is available anywhere in the application
  runApp(
    ChangeNotifierProvider(
      create: (context) => InputProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: black,
        useMaterial3: true,
        fontFamily: 'Figtree',
      ),
      debugShowCheckedModeBanner: false,
      home: PhoneLogin(),
    );
  }
}
