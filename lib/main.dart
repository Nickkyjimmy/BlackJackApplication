import 'package:flutter/material.dart';
import 'package:black_jack/PlayerSetupScreen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blackjack Host',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PlayerCountScreen(),
    );
  }
}
