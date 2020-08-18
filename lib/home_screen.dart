import 'package:flutter/material.dart';
import 'flight_widget.dart';
import 'flight_data.dart';


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
    return randomFlights(10).map((e) => FlightWidget(e)).toList();
  }

  Widget getFlightsTabView() {
    var flights = this.getFlightsList();
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
        Expanded(
            child: ListView.builder(
                itemCount: flights.length,
                itemBuilder: (context, position) {
                  return Card(child: flights[position]);
                }))
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