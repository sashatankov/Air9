import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(Air9App());
}

class Air9App extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: MaterialApp(
        title: 'Air9 App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(title: 'Air9'),
      ),
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        currentFocus.requestFocus(new FocusNode());
        
      },
    );
  }
}
