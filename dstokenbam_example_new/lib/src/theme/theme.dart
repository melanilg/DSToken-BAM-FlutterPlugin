import 'package:flutter/material.dart';

class ThemeSDK {
  static InputDecoration inputDecoration({String? hintText}) {
    return InputDecoration(
      border: OutlineInputBorder(),
      hintText: hintText,
    );
  }

  static ButtonStyle actionButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.teal[500],
      textStyle: const TextStyle(fontSize: 18, color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}
