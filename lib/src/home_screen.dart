import 'package:flutter/material.dart';

import 'package:Air9/src/flight.dart';
import 'package:Air9/src/account.dart';
import 'package:Air9/src/flight_search.dart';

/// a class representing a home screen of the app
/// The home screen consist of 3 screens in tab-view
///  - flights screen - displays upcoming flights of the user
///  - flight search screen - displays the search form for flights
///  - account screen - displays info of the user account
class HomeScreenModel {
  FlightsController flightsController;
  FlightSearchController flightsSearchController;

  AccountController accountController;

  /// a constructor of the class
  HomeScreenModel(this.flightsController, 
  this.accountController, this.flightsSearchController) {
    this.flightsSearchController = FlightSearchController();
  }
}

/// a controller class for [HomeScreenModel]
class HomeScreenController {
  HomeScreenModel model;

  /// a constructor of the class
  HomeScreenController(this.model);

  /// returns the 'flights' screen
  Widget flightsScreen() {
    return this.model.flightsController.view.render();
  }

  /// return the 'flight search' screen
  Widget flightsSearchScreen() {
    return this.model.flightsSearchController.view.render();
  }

  /// return the 'account' screen
  Widget accountScreen() {
    return this.model.accountController.view.render();
  }
}

/// a widget class for the home screen
/// a home screen contains an app bar and 3 tabs 
/// with each tab as a separate screen
class HomeScreen extends StatefulWidget {
  final HomeScreenController controller;

  HomeScreen(this.controller, {Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

/// a state class for the [HomeScreen] widget
class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: DefaultTabController(
          length: 3,
          child: HomeScreenBody(this.widget.controller),
        ),
      ),
    );
  }
}

/// the body of the home screen excluding the app bar
class HomeScreenBody extends StatefulWidget {
  final HomeScreenController controller;

  HomeScreenBody(this.controller);

  @override
  _HomeScreenBodyState createState() => _HomeScreenBodyState();
}

/// the state class the the [HomeScreenBody] widget
class _HomeScreenBodyState extends State<HomeScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this.getHomeScreenTabView(),
      bottomNavigationBar: this.getHomeScreenTabBar(),
    );
  }

  /// returns the 'flights' screen tab-view
  Widget getFlightsTabView() {
    return this.widget.controller.flightsScreen();
  }

  /// returns the 'flight search' screen tab-view
  Widget getSearchTabView() {
    return this.widget.controller.flightsSearchScreen();
  }

  /// returns the 'account' screen tab-view
  Widget getAccountTabView() {
    return this.widget.controller.accountScreen();
  }

  /// returns the 'flights' screen tab-button
  Widget getFlightsTab() {
    return Tab(
      icon: Icon(
        Icons.local_airport,
        color: Colors.blue,
        semanticLabel: "flights",
      ),
    );
  }

  /// returns the 'flight search' screen tab-button
  Widget getSearchTab() {
    return Tab(
      icon: Icon(
        Icons.search,
        color: Colors.blue,
        semanticLabel: "Search Flights",
      ),
    );
  }

  /// returns the 'account' screen tab-button
  Widget getAccountTab() {
    return Tab(
      icon: Icon(
        Icons.account_circle,
        color: Colors.blue,
        semanticLabel: "profile",
      ),
    );
  }

  /// returns the tab-view containing all scrrens of the home screen
  Widget getHomeScreenTabView() {
    return TabBarView(
      children: <Widget>[
        this.getFlightsTabView(),
        this.getSearchTabView(),
        this.getAccountTabView(),
      ],
    );
  }

  /// returns the tab-bar with tab buttons of all screens of the home screen
  Widget getHomeScreenTabBar() {
    return TabBar(
      tabs: <Widget>[
        this.getFlightsTab(),
        this.getSearchTab(),
        this.getAccountTab(),
      ],
    );
  }
}
