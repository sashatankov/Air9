import 'package:flutter/material.dart';
import 'package:Air9/src/home_screen.dart';

void main() {
  AppController appController = AppController();
  runApp(Air9App(appController));
}

class AppController {
  HomeScreenController homeScreenController;

  AppController() {
    this.homeScreenController = HomeScreenController();
  }
}

class Air9App extends StatelessWidget {
  final AppController appController;

  Air9App(this.appController);
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
        home:
            HomeScreen(this.appController.homeScreenController, title: 'Air9'),
      ),
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        currentFocus.requestFocus(new FocusNode());
      },
    );
  }
}
