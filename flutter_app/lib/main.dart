import 'package:flutter/material.dart';
import 'pages/home_page.dart'; // tärkeä!

void main() {
  runApp(RuokaApp());
}

class RuokaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ruokainspiraattori',
      home: RuokaHomePage(), // tärkeä!
    );
  }
}