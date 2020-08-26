import 'package:flutter/material.dart';
import 'flight_widget.dart';
import 'flight_data.dart';

import 'package:Air9/src/flight.dart';
import 'package:Air9/src/account.dart';
import 'package:Air9/src/flight_search.dart';

class HomeScreenModel {
  FlightsController flightsController;
  FlightSearchController flightsSearchController;

  AccountController accountController;

  HomeScreenModel(this.flightsController, 
  this.accountController, this.flightsSearchController) {
    this.flightsSearchController = FlightSearchController();
  }
}

class HomeScreenController {
  HomeScreenModel model;

  HomeScreenController(this.model);

  Widget flightsScreen() {
    return this.model.flightsController.view.render();
  }

  Widget flightsSearchScreen() {
    return this.model.flightsSearchController.view.render();
  }

  Widget accountScreen() {
    return this.model.accountController.view.render();
  }
}

class HomeScreen extends StatefulWidget {
  final HomeScreenController controller;

  HomeScreen(this.controller, {Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

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

class HomeScreenBody extends StatefulWidget {
  final HomeScreenController controller;

  HomeScreenBody(this.controller);

  @override
  _HomeScreenBodyState createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this.getHomeScreenTabView(),
      bottomNavigationBar: this.getHomeScreenTabBar(),
    );
  }

  List<Widget> getFlightsList() {
    var flights = randomFlights(10);
    flights.sort((a, b) => a.departureAt.difference(b.departureAt).inMinutes);
    return flights.map((e) => FlightWidget(e)).toList();
  }

  Widget getFlightsTabView() {
    return this.widget.controller.flightsScreen();
  }

  Widget getSearchTabView() {
    return this.widget.controller.flightsSearchScreen();
  }

  Widget getProfileTabView() {
    return this.widget.controller.accountScreen();
  }

  Widget getFlightsTab() {
    return Tab(
      icon: Icon(
        Icons.local_airport,
        color: Colors.blue,
        semanticLabel: "flights",
      ),
    );
  }

  Widget getSearchTab() {
    return Tab(
      icon: Icon(
        Icons.search,
        color: Colors.blue,
        semanticLabel: "Search Flights",
      ),
    );
  }

  Widget getProfileTab() {
    return Tab(
      icon: Icon(
        Icons.account_circle,
        color: Colors.blue,
        semanticLabel: "profile",
      ),
    );
  }

  Widget getHomeScreenTabView() {
    return TabBarView(
      children: <Widget>[
        this.getFlightsTabView(),
        this.getSearchTabView(),
        this.getProfileTabView(),
      ],
    );
  }

  Widget getHomeScreenTabBar() {
    return TabBar(
      tabs: <Widget>[
        this.getFlightsTab(),
        this.getSearchTab(),
        this.getProfileTab(),
      ],
    );
  }
}
