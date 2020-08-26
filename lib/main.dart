import 'package:Air9/src/account.dart';
import 'package:Air9/src/account_data.dart';
import 'package:Air9/src/flight.dart';
import 'package:Air9/src/flight_data.dart';
import 'package:Air9/src/flight_search.dart';
import 'package:flutter/material.dart';
import 'package:Air9/src/home_screen.dart';

void main() {
  var flights = randomFlights(10);
  Flights flightsModel = Flights(flights);
  FlightsController flightsCotroller = FlightsController(flightsModel);

  TravelerAccount account = randomTravelerAccount();
  TravelerAccountController accountcontroller =
      TravelerAccountController(account);

  FlightSearchController flightSearchController = FlightSearchController();

  HomeScreenModel homeScreenModel = HomeScreenModel(
    flightsCotroller, 
    accountcontroller, 
    flightSearchController);
  HomeScreenController homeScreenController =
      HomeScreenController(homeScreenModel);
      
  AppController appController = AppController(homeScreenController);

  runApp(Air9App(appController));
}

class AppController {
  HomeScreenController homeScreenController;
  AppController(this.homeScreenController);
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
