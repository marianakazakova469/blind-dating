import 'package:flutter/material.dart';

class InputProvider extends ChangeNotifier {
  String? _phonenumber;
  String? _pin;

  String? get phoneNumber => _phonenumber;

  String? get inputPin => _pin;

  void updatePin(String newPin) {
    _pin = newPin;
    notifyListeners();
  }

  void updatePhoneNumber(String newPhoneNumber) {
    _phonenumber = newPhoneNumber;
    notifyListeners();
  }
}
