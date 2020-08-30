import 'package:Air9/src/flight_widget.dart';
import 'package:flutter/material.dart';
import 'package:Air9/src/flight_data.dart';

/// a class represents a commercial flight
/// and stores data about the flight
class Flight {
  String departureCity;
  String arrivalCity;
  String departureAirport;
  String arrivalAirport;
  DateTime departureAt;
  DateTime arrivalAt;
  List<Flight> connections;

  /// a constructor of the class
  Flight(this.departureCity, this.arrivalCity, this.departureAirport,
      this.arrivalAirport, this.departureAt, this.arrivalAt,
      {this.connections = const <Flight>[]});

  /// returns a string representation of the date of departure of the flight
  String get detartureDate {
    var day = this.departureAt.day.toString().padLeft(2, '0');
    var month = this.departureAt.month.toString().padLeft(2, '0');
    var year = this.departureAt.year;

    return "$day/$month/$year";
  }

  /// returns the string representation of the time of departure of the flight
  String get departureTime {
    var hour = this.departureAt.hour.toString().padLeft(2, '0');
    var minute = this.departureAt.minute.toString().padLeft(2, '0');

    return "$hour:$minute";
  }

  /// returns a string representation of the date of arrival of the flight
  String get arrivalDate {
    var day = this.arrivalAt.day.toString().padLeft(2, '0');
    var month = this.arrivalAt.month.toString().padLeft(2, '0');
    var year = this.arrivalAt.year;

    return "$day/$month/$year";
  }

  /// returns the tring representation of the time of arrival of the flight
  String get arrivalTime {
    var hour = this.arrivalAt.hour.toString().padLeft(2, '0');
    var minute = this.arrivalAt.minute.toString().padLeft(2, '0');

    return "$hour:$minute";
  }
}

/// a controller class the responsible for interactioing with a flight
/// a [Flight] class serves as a model for this class
class FlightController {
  Flight model;
  FlightView view;

  FlightController(this.model) {
    this.view = FlightView(this.model);
  }

  /// returns the string representation of the date of departure of flight
  String get detartureDate => this.model.detartureDate;

  /// returns the string representation of the time of departure of flight
  String get departureTime => this.model.departureTime;

  /// returns the string representation of the date of arrival of flight
  String get arrivalDate => this.model.arrivalDate;

  /// returns the string representation of the time of arrival of flight
  String get arrivalTime => this.model.arrivalTime;

  // updates the view og the flight with the current model
  void updateView() {
    this.view = FlightView(this.model);
  }
}

/// a view class for displaying the flight info
class FlightView {
  FlightWidget widget;
  Flight model;

  /// a constructor for the class.
  /// The constructor recieves the [Flight] model to display.
  FlightView(Flight model) {
    this.model = model;
    this.widget = FlightWidget(this.model);
  }

  /// renders the widget with the flight info
  Widget render() => this.widget;
}

/// a class represents a model of a collection of flights of type [Flight]
class Flights {
  List<Flight> flights;

  /// a constructor of the class
  /// The constructor recieves an initial collection of flights
  Flights.of(Iterable<Flight> initialFlights) {
    this.flights = List<Flight>();
    this.flights.addAll(initialFlights);
  }

  /// a constructor of the class, builds a model with no model
  Flights() {
    this.flights = List<Flight>();
  }

  /// returns all flights that are in the model
  Iterable<Flight> get allFlights => this.flights;

  /// adds flight of [Flight] to the collection
  void add(Flight flight) => this.flights.add(flight);

  /// adds a set of flights of [Flight] to the collection
  void addAll(Iterable<Flight> toAdd) => this.flights.addAll(toAdd);
}

/// a controller class that responsible for interaction
/// with the [Flights] model
class FlightsController {
  Flights model;
  FlightsView view;

  /// a constructor of the class
  FlightsController(this.model) {
    this.view = FlightsView(this.model);
  }

  /// adds a flight to the model
  void add(Flight flight) {
    this.model.add(flight);
    this.updateView();
  }

  /// adds a set of flights to the model
  void addAll(Iterable<Flight> flightsToAdd) {
    this.model.addAll(flightsToAdd);
    this.updateView();
  }

  /// returns all the flights
  Iterable<Flight> get allFlights => this.model.allFlights;

  /// updates the view with the current model
  void updateView() {
    this.view = FlightsView(this.model);
  }
}

/// a view class for the [Flights] model
class FlightsView {
  Flights model;
  FlightsView(this.model);

  /// returns a list of views for each [Flight] in the model
  List<Widget> renderFlightsView() {
    var flightsList = this.model.allFlights.toList();
    flightsList
        .sort((a, b) => a.departureAt.difference(b.departureAt).inMinutes);
    return flightsList.map((e) => FlightView(e).render()).toList();
  }

  /// renders a view of flights
  Widget render() {
    var view = this.renderFlightsView();
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
          child: ListView.separated(
            itemCount: view.length,
            itemBuilder: (context, index) {
              return Card(
                child: view[index],
                margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Card(
                child: view[index],
                margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.blue[100],
              );
            },
          ),
        )
      ],
    );
  }
}
