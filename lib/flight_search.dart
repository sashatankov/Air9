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

  FlightSearchView getView() {
    return this.view;
  }
}

class FlightSearchView {
  FlightSearchFormWidget widget;

  FlightSearchView();

  Widget getView() {
    return FlightSearchFormWidget();
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
