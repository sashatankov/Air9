import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

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
    var flights = randomFlights(10);
    flights.sort((a, b) => a.departureAt.difference(b.departureAt).inMinutes);
    return flights.map((e) => FlightWidget(e)).toList();
  }

  Widget getFlightsTabView() {
    var flights = this.getFlightsList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
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
    return FlightSearchFormWidget();
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

class FlightSearchFormWidget extends StatefulWidget {
  @override
  _FlightSearchFormWidgetState createState() => _FlightSearchFormWidgetState();
}

class _FlightSearchFormWidgetState extends State<FlightSearchFormWidget> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _departureAtController = TextEditingController();
  final _arrivalAtController = TextEditingController();
  FlightSearchQuery _query;

  @override
  void initState() {
    this._query = FlightSearchQuery();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: ListView(
        children: <Widget>[
          this.searchHeadline(),
          Divider(),
          this.fromTextField(),
          Divider(),
          this.toTextField(),
          Divider(),
          this.departureAtTextField(),
          Divider(),
          this.arrivalAtTextFeild(),
          Divider(),
          this.oneWayCheckBox(),
          this.nonStopCheckBox(),
          Divider(),
          this.searchButton()
        ],
      ),
    );
  }

  Widget searchHeadline() {
    return ListTile(
        title:
            Text("Where do you want to go?", style: TextStyle(fontSize: 24)));
  }

  Widget fromTextField() {
    return ListTile(
      title: TextField(
        controller: this._fromController,
        decoration: this.fromDecoration(),
        onChanged: (String value) {
          this.setState(() {
            this._query.from = value;
          });
        },
        onSubmitted: (value) {},
      ),
    );
  }

  Widget toTextField() {
    return ListTile(
      title: TextField(
        controller: this._toController,
        decoration: this.toDecoration(),
        onChanged: (value) {
          this.setState(() {
            this._query.to = value;
          });
        },
        onSubmitted: (value) {},
      ),
    );
  }

  Widget departureAtTextField() {
    return ListTile(
      title: TextField(
        controller: this._departureAtController,
        decoration: this.departureAtDecoration(),
        onChanged: (value) {
          this.setState(() {
            this._query.departureDate =
                DateTime.parse(value); // TODO might change later
          });
        },
        onSubmitted: (value) {},
      ),
    );
  }

  Widget arrivalAtTextFeild() {
    return ListTile(
        title: TextField(
      controller: this._arrivalAtController,
      decoration: this.arrivalAtDecoration(),
      onChanged: (value) {
        this._query.arrivalDate =
            DateTime.parse(value); // TODO might change later
      },
      onSubmitted: (value) {},
    ));
  }

  Widget oneWayCheckBox() {
    return CheckboxListTile(
        title: const Text("One-Way"),
        value: this._query.isOneWay,
        onChanged: (bool newValue) {
          this.setState(() {
            this._query.isOneWay = newValue;
          });
        });
  }

  Widget nonStopCheckBox() {
    return CheckboxListTile(
      title: const Text("Non-Stop flights only"),
      value: this._query.nonStopFlightsOnly,
      onChanged: (bool value) {
        this.setState(() {
          this._query.nonStopFlightsOnly = value;
        });
      },
    );
  }

  Widget searchButton() {
    return ListTile(
        title: FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(8),
            onPressed: () {
              // TODO to analyze the query
            },
            child: Text("Find Me Flights")));
  }

  InputDecoration fromDecoration() {
    return InputDecoration(labelText: "From");
  }

  InputDecoration toDecoration() {
    return InputDecoration(labelText: "To");
  }

  InputDecoration departureAtDecoration() {
    return InputDecoration(
        labelText: "Departure At",
        suffixIcon: FlatButton.icon(
            onPressed: () {
              this.pickDepartureDate();
            },
            icon: Icon(Icons.calendar_today),
            label: Text("")));
  }

  InputDecoration arrivalAtDecoration() {
    return InputDecoration(
        labelText: "Arrival At",
        suffixIcon: FlatButton.icon(
            onPressed: () {
              // TODO open date picker
            },
            icon: Icon(Icons.calendar_today),
            label: Text("")));
  }

  TextStyle textStyle() {
    return TextStyle(fontSize: 16);
  }

  void pickDepartureDate() {
    Future<DateTime> futureDate = showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2099, 12, 31));

    futureDate.then((DateTime value) {
      this.setState(() {
        this._query.departureDate = value;
      });
      this._departureAtController.value =
          TextEditingValue(text: value.toString()); // TODO to format
    }).catchError((error) {
      print(error);
    });
  }

  void pickArrivalDate(){
    Future<DateTime> futureDate = showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2099, 12, 31));

    futureDate.then((DateTime value) {
      this.setState(() {
        this._query.arrivalDate = value;
      });
      this._arrivalAtController.value =
          TextEditingValue(text: value.toString()); // TODO to format
    }).catchError((error) {
      print(error);
    });
  }
}

class FlightSearchQuery {
  String from = "";
  String to = "";
  DateTime departureDate = DateTime.now();
  DateTime arrivalDate = DateTime.now();
  bool isOneWay = false;
  bool nonStopFlightsOnly = false;

  FlightSearchQuery();
}
