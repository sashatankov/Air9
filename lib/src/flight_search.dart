import 'package:flutter/material.dart';
import 'package:Air9/src/search_results_screen.dart';

/// a class represents a search query in the search screen in the app
class FlightSearchQuery {
  String from = "";
  String to = "";
  DateTime departureDate = DateTime.now();
  DateTime arrivalDate = DateTime.now();
  bool isOneWay = false;
  bool nonStopFlightsOnly = false;

  FlightSearchQuery();
}

/// a controller class for the interaction with [FlightSearchQuery] model
class FlightSearchController {
  FlightSearchQuery model;
  FlightSearchView flightSearchView;

  /// a constructor for the class, with empty FlightSearchQuery model
  FlightSearchController() {
    this.model = FlightSearchQuery();
    this.flightSearchView = FlightSearchView(this);
  }

  /// return the view the the model
  FlightSearchView get view => this.flightSearchView;

  /// updates the view with the current model
  void updateView() {
    this.flightSearchView = FlightSearchView(this);
  }

  /// sets the 'from' property in the query to given value
  set flightFrom(String location) => this.model.from = location;

  /// sets 'to' property in the quey to given value
  set flightTo(String location) => this.model.to = location;

  /// sets the 'departureDate' property to given value
  set departureDate(DateTime date) => this.model.departureDate = date;

  /// sets the 'arrivalData' property to the given value
  set arrivalDate(DateTime date) => this.model.arrivalDate = date;

  /// sets the 'isOneWay' property to the given value
  set isOneWay(bool value) => this.model.isOneWay = value;

  /// sets the 'nonStopFlightsOnly' property to the given value
  set nonStopFlightsOnly(bool value) => this.model.nonStopFlightsOnly = value;

  /// returns the origin of the flight
  String get flightFrom => this.model.from;

  /// returns the the destination of the flight
  String get flightTo => this.model.to;

  /// returns the date of departure of the flight
  DateTime get departureDate => this.model.departureDate;

  /// returns the date of arrival of the flight
  DateTime get arrivalDate => this.model.arrivalDate;

  /// returns true if the search is for one-way flights
  bool get isOneWay => this.model.isOneWay;

  /// returns true if the search is for non-stop flights
  bool get nonStopFlightsOnly => this.model.nonStopFlightsOnly;

  /// prints the user serach input entered in the form
  /// meant for debuging purposes only
  void printUserInput() {
    print("From: ${this.flightFrom}");
    print("To: ${this.flightTo}");
    print("Departure Date: ${this.departureDate.toString()}");
    print("Arrival Date: ${this.arrivalDate.toString()}");
    print("One Way: ${this.isOneWay}");
    print("Non Stop: ${this.nonStopFlightsOnly}");
  }

  /// analyzes the submitted search query;
  void analyzeSearchQuery(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlightSearchResultsScreenWidget(model),
      ),
    );
  }
}

/// a view class for [FlightSearchQuery]
class FlightSearchView {
  FlightSearchFormWidget widget;
  FlightSearchController controller;

  /// a constructor for the class.
  /// the constructor recieves the controller containing the model
  FlightSearchView(FlightSearchController controller) {
    this.widget = FlightSearchFormWidget(controller);
    this.controller = controller;
  }

  /// returns the visual representatioj of the search form
  Widget render() {
    return this.widget;
  }
}

/// a widget class for the [FlightSearchQuery]
class FlightSearchFormWidget extends StatefulWidget {
  final FlightSearchController controller;

  FlightSearchFormWidget(this.controller);

  @override
  _FlightSearchFormWidgetState createState() => _FlightSearchFormWidgetState();
}

/// a state class for the [FlightSearchFormWidget]
class _FlightSearchFormWidgetState extends State<FlightSearchFormWidget> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _departureAtController = TextEditingController();
  final _arrivalAtController = TextEditingController();
  bool isArrivalAtFieldActive;

  @override
  void initState() {
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

  /// returns the a widget for the headline of the form
  Widget searchHeadline() {
    return ListTile(
        title:
            Text("Where do you want to go?", style: TextStyle(fontSize: 24)));
  }

  /// returns a text field for the origin of the flight
  Widget fromTextField() {
    return ListTile(
      title: TextField(
        controller: this._fromController,
        decoration: this.fromDecoration(),
        onChanged: (String value) {
          this.setState(() {
            this.widget.controller.flightFrom = value;
          });
        },
        onSubmitted: (value) {
          this.setState(() {
            this.widget.controller.flightFrom = value;
          });
        },
      ),
    );
  }

  /// returns a text field for the destinatio of the flight
  Widget toTextField() {
    return ListTile(
      title: TextField(
        controller: this._toController,
        decoration: this.toDecoration(),
        onChanged: (value) {
          this.setState(() {
            this.widget.controller.flightTo = value;
          });
        },
        onSubmitted: (value) {
          this.setState(() {
            this.widget.controller.flightTo = value;
          });
        },
      ),
    );
  }

  /// returns a text field for the deparature date of the flight
  Widget departureAtTextField() {
    return ListTile(
      title: TextField(
        controller: this._departureAtController,
        decoration: this.departureAtDecoration(),
        onSubmitted: (value) {
          this.setState(() {
            this.widget.controller.departureDate = DateTime.parse(value);
          });
        },
      ),
    );
  }

  /// returns a text field for the arrival date fo the flight
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
          this.widget.controller.arrivalDate = DateTime.parse(value);
        },
      ),
    );
  }

  /// returns a check-box for search of one-way flights
  Widget oneWayCheckBox() {
    return CheckboxListTile(
      title: const Text("One-Way"),
      value: this.widget.controller.isOneWay,
      onChanged: (bool newValue) {
        this.setState(() {
          this.widget.controller.isOneWay = newValue;
          this.isArrivalAtFieldActive = !this.isArrivalAtFieldActive;
        });
      },
    );
  }

  /// returns a check-box for search of non-stop flights
  Widget nonStopCheckBox() {
    return CheckboxListTile(
      title: const Text("Non-Stop flights only"),
      value: this.widget.controller.nonStopFlightsOnly,
      onChanged: (bool value) {
        this.setState(() {
          this.widget.controller.nonStopFlightsOnly = value;
        });
      },
    );
  }

  /// return the 'search flights' button
  Widget searchButton() {
    return ListTile(
      title: RaisedButton(
        color: Colors.blue,
        textColor: Colors.white,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        padding: EdgeInsets.all(8),
        onPressed: () {
          this.widget.controller.printUserInput(); // this is a test to console
          this.widget.controller.analyzeSearchQuery(context);
        },
        child: Text("Find Me Flights"),
      ),
    );
  }

  /// returns a decoration for the 'from' text-field
  InputDecoration fromDecoration() {
    return InputDecoration(labelText: "From", hintText: "e.g. New York");
  }

  /// returns a decoration for the 'to' text-field
  InputDecoration toDecoration() {
    return InputDecoration(labelText: "To", hintText: "e.g. Rome");
  }

  /// returns a decoration for 'depatarture date' text-field
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

  /// returns a decoration for 'arrival date' text-field
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

  /// returns a style fir the text in the form
  TextStyle textStyle() {
    return TextStyle(fontSize: 16);
  }

  // picks the date of the departure
  void pickDepartureDate() {
    Future<DateTime> futureDate = showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2099, 12, 31));

    futureDate.then((DateTime value) {
      this.setState(() {
        this.widget.controller.departureDate = value;
      });
      this._departureAtController.value =
          TextEditingValue(text: this.formattedDate(value));
    }).catchError((error) {
      print(error);
      this._departureAtController.text = "";
    });
  }

  /// picks the date of arrival
  void pickArrivalDate() {
    Future<DateTime> futureDate = showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2099, 12, 31),
    );

    futureDate.then((DateTime value) {
      this.setState(() {
        this.widget.controller.arrivalDate = value;
      });
      this._arrivalAtController.value =
          TextEditingValue(text: this.formattedDate(value));
    }).catchError((error) {
      print(error);
      this._arrivalAtController.text = "";
    });
  }

  /// return a string representation of a date
  String formattedDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().padLeft(2, '0')}";
  }
}
