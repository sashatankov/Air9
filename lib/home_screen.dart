import 'package:flutter/material.dart';
import 'flight_widget.dart';
import 'flight_data.dart';

import 'package:Air9/flight.dart';
import 'package:Air9/account.dart';
import 'package:Air9/flight_search.dart';

class HomeScreenModel {
  FlightsController flightsController;
  FlightSearchController flightsSearchController;

  TravelerAccount account;
  TravelerAccountController travelerAccountController;

  HomeScreenModel() {
    this.flightsController = FlightsController();
    this.flightsSearchController = FlightSearchController();
    
    // FIXME
    this.account = TravelerAccount("John", "Snow");
    this.account.firstName = "John";
    this.account.lastName = "Snow";
    this.travelerAccountController = TravelerAccountController(account);
  }
}

class HomeScreenController {
  HomeScreenModel model;

  HomeScreenController() {
    this.model = HomeScreenModel();
  }

  Widget flightsScreen() {
    return this.model.flightsController.view.getView();
  }

  Widget flightsSearchScreen() {
    return this.model.flightsSearchController.view.widget;
  }

  Widget accountScreen() {
    return this.model.travelerAccountController.accountView.widget;
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreenController controller;

  HomeScreen(HomeScreenController controller, {Key key, this.title})
      : super(key: key) {
    this.controller = controller;
  }

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
  HomeScreenController controller;

  HomeScreenBody(HomeScreenController controller) {
    this.controller = controller;
  }
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
    // var flights = this.getFlightsList();
    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   children: <Widget>[
    //     Container(
    //       child: Text(
    //         "Upcoming Flights",
    //         style: TextStyle(
    //           fontSize: 24,
    //         ),
    //       ),
    //       padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
    //     ),
    //     Expanded(
    //       child: ListView.separated(
    //         itemCount: flights.length,
    //         itemBuilder: (context, index) {
    //           return Card(
    //             child: flights[index],
    //             margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(15.0),
    //             ),
    //           );
    //         },
    //         separatorBuilder: (context, index) {
    //           return Card(
    //             child: flights[index],
    //             margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(15.0),
    //             ),
    //             color: Colors.blue[100],
    //           );
    //         },
    //       ),
    //     )
    //   ],
    // );
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
  bool isArrivalAtFieldActive;

  @override
  void initState() {
    this._query = FlightSearchQuery();
    this.isArrivalAtFieldActive = true;
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
        onSubmitted: (value) {
          this.setState(() {
            this._query.from = value;
          });
        },
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
        onSubmitted: (value) {
          this.setState(() {
            this._query.to = value;
          });
        },
      ),
    );
  }

  Widget departureAtTextField() {
    return ListTile(
      title: TextField(
        controller: this._departureAtController,
        decoration: this.departureAtDecoration(),
        onSubmitted: (value) {
          this.setState(() {
            this._query.departureDate = DateTime.parse(value);
          });
        },
      ),
    );
  }

  Widget arrivalAtTextFeild() {
    return ListTile(
      title: TextField(
        controller: this._arrivalAtController,
        decoration: this.arrivalAtDecoration(),
        enabled: this.isArrivalAtFieldActive,
        style: TextStyle(
          color: this.isArrivalAtFieldActive ? Colors.black : Colors.black26,
        ),
        onSubmitted: (value) {
          this._query.arrivalDate = DateTime.parse(value);
        },
      ),
    );
  }

  Widget oneWayCheckBox() {
    return CheckboxListTile(
      title: const Text("One-Way"),
      value: this._query.isOneWay,
      onChanged: (bool newValue) {
        this.setState(() {
          this._query.isOneWay = newValue;
          this.isArrivalAtFieldActive = !this.isArrivalAtFieldActive;
        });
      },
    );
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
      title: RaisedButton(
        color: Colors.blue,
        textColor: Colors.white,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        padding: EdgeInsets.all(8),
        onPressed: () {
          // TODO to analyze the query
        },
        child: Text("Find Me Flights"),
      ),
    );
  }

  InputDecoration fromDecoration() {
    return InputDecoration(labelText: "From", hintText: "e.g. New York");
  }

  InputDecoration toDecoration() {
    return InputDecoration(labelText: "To", hintText: "e.g. Rome");
  }

  InputDecoration departureAtDecoration() {
    return InputDecoration(
      labelText: "Departure At",
      hintText: "DD/MM/YYYY",
      suffixIcon: FlatButton.icon(
        onPressed: () {
          this.pickDepartureDate();
        },
        icon: Icon(Icons.calendar_today),
        label: Text(""),
      ),
    );
  }

  InputDecoration arrivalAtDecoration() {
    return InputDecoration(
      labelText: "Arrival At",
      hintText: "DD/MM/YYYY",
      suffixIcon: FlatButton.icon(
        onPressed: () {
          this.pickArrivalDate();
        },
        icon: Icon(Icons.calendar_today),
        label: Text(""),
      ),
    );
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
          TextEditingValue(text: this.formattedDate(value));
    }).catchError((error) {
      print(error);
      this._departureAtController.text = "";
    });
  }

  void pickArrivalDate() {
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
          TextEditingValue(text: this.formattedDate(value));
    }).catchError((error) {
      print(error);
      this._arrivalAtController.text = "";
    });
  }

  String formattedDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().padLeft(2, '0')}";
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

class UserProfileWidget extends StatefulWidget {
  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          this.profilePicture(),
          this.profileName(),
          this.profilePassportNumber(),
          Divider(),
          this.profileFlightMiles()
        ],
      ),
    );
  }

  Widget profilePicture() {
    return ListTile(
      title: Icon(
        Icons.account_circle,
        size: 250,
      ),
    );
  }

  Widget profileName() {
    return ListTile(
      title: Center(
        child: Text(
          "John Doe",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
    );
  }

  Widget profilePassportNumber() {
    return ListTile(
      leading: Text(
        "Passport Number",
        style: TextStyle(
          color: Colors.black38,
          fontSize: 16,
        ),
      ),
      title: Text(
        "EF45874",
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  Widget profileFlightMiles() {
    return ListTile(
      leading: Text(
        "Miles",
        style: TextStyle(
          color: Colors.black38,
          fontSize: 16,
        ),
      ),
      title: Text(
        "35788",
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}
