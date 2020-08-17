import 'package:flutter/material.dart';
import 'flightWidget.dart';

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

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

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
        child: DefaultTabController(length: 3, child: HomeScreenBody()),
      ),
    );
  }
}

class HomeScreenBody extends StatefulWidget {
  final List<String> cities = ["Tel-Aviv", "New-York", "Los-Angeles", "Paris"];
  final Map<String, String> airports = {
    "Tel-Aviv": "TLV",
    "New-York": "JFK",
    "Los-Angeles": "LAX",
    "Paris": "CDG"
  };
  final List<String> dates = ["10/10/20", "1/12/21"];
  final List<String> times = ["12:00", "22:00"];

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
    List<Widget> flights = [];
    var cities = this.widget.cities;
    var airports = this.widget.airports;
    var dates = this.widget.dates;
    var times = this.widget.times;
    for (int i = 0; i < cities.length; ++i) {
      for (int j = i + 1; j < cities.length; ++j) {
        flights.add(FlightWidget(Flight(
            cities[i],
            cities[j],
            airports[cities[i]],
            airports[cities[j]],
            times[0],
            times[1],
            dates[0],
            dates[1])));
      }
    }

    return flights;
  }

  Widget getFlightsTabView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          child: Text(
            "Upcoming Flights",
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
        ),
        ListView(
          children: this.getFlightsList(),
        ),
      ],
    );
  }

  Widget getSearchTabView() {
    return Container(child: Center(child: Text("Search"))); // TODO
  }

  Widget getProfileTabView() {
    return Container(child: Center(child: Text("Profile"))); // TODO
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
      children: [
        this.getFlightsTabView(),
        this.getSearchTabView(),
        this.getProfileTabView(),
      ],
    );
  }

  Widget getHomeScreenTabBar() {
    return TabBar(
      tabs: [
        this.getFlightsTab(),
        this.getSearchTab(),
        this.getProfileTab(),
      ],
    );
  }
}
