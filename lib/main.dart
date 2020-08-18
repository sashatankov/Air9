import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(Air9App());
}

class Air9App extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(title: 'Air9'),
    );
  }
}


