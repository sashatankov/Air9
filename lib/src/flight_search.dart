import 'package:flutter/material.dart';

class FlightSearchQuery {
  String from = "";
  String to = "";
  DateTime departureDate = DateTime.now();
  DateTime arrivalDate = DateTime.now();
  bool isOneWay = false;
  bool nonStopFlightsOnly = false;

  FlightSearchQuery();
}

class FlightSearchController {
  FlightSearchQuery model;
  FlightSearchView view;

  FlightSearchController() {
    this.model = FlightSearchQuery();
    this.view = FlightSearchView(this);
  }

  FlightSearchView getView() {
    return this.view;
  }

  set flightFrom(String location) => this.model.from = location;

  set flightTo(String location) => this.model.to = location;

  set departureDate(DateTime date) => this.model.departureDate = date;

  set arrivalDate(DateTime date) => this.model.arrivalDate = date;

  set isOneWay(bool value) => this.model.isOneWay = value;

  set nonStopFlightsOnly(bool value) => this.model.nonStopFlightsOnly = value;

  String get flightFrom => this.model.from;

  String get flightTo => this.model.to;

  DateTime get departureDate => this.model.departureDate;

  DateTime get arrivalDate => this.model.arrivalDate;

  bool get isOneWay => this.model.isOneWay;

  bool get nonStopFlightsOnly => this.model.nonStopFlightsOnly;

  void printUserInput() {
    print("From: ${this.flightFrom}");
    print("To: ${this.flightTo}");
    print("Departure Date: ${this.departureDate.toString()}");
    print("Arrival Date: ${this.arrivalDate.toString()}");
    print("One Way: ${this.isOneWay}");
    print("Non Stop: ${this.nonStopFlightsOnly}");
  }
}

class FlightSearchView {
  FlightSearchFormWidget widget;
  FlightSearchController controller;

  FlightSearchView(FlightSearchController controller) {
    this.widget = FlightSearchFormWidget(controller);
    this.controller = controller;
  }
}

class FlightSearchFormWidget extends StatefulWidget {
  final FlightSearchController controller;

  FlightSearchFormWidget(this.controller);

  @override
  _FlightSearchFormWidgetState createState() => _FlightSearchFormWidgetState();
}

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
          // Test prints input to the console with controller
          this.widget.controller.printUserInput();
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
        this.widget.controller.departureDate = value;
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

  String formattedDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().padLeft(2, '0')}";
  }
}
