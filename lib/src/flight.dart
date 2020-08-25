import 'package:Air9/src/flight_widget.dart';
import 'package:flutter/material.dart';
import 'package:Air9/src/flight_data.dart';

class Flight {
  String departureCity;
  String arrivalCity;
  String departureAirport;
  String arrivalAirport;
  DateTime departureAt;
  DateTime arrivalAt;
  List<Flight> connections;

  Flight(this.departureCity, this.arrivalCity, this.departureAirport,
      this.arrivalAirport, this.departureAt, this.arrivalAt,
      {this.connections = const <Flight>[]});

  String get detartureDate {
    var day = this.departureAt.day.toString().padLeft(2, '0');
    var month = this.departureAt.month.toString().padLeft(2, '0');
    var year = this.departureAt.year;

    return "$day/$month/$year";
  }

  String get departureTime {
    var hour = this.departureAt.hour.toString().padLeft(2, '0');
    var minute = this.departureAt.minute.toString().padLeft(2, '0');

    return "$hour:$minute";
  }

  String get arrivalDate {
    var day = this.arrivalAt.day.toString().padLeft(2, '0');
    var month = this.arrivalAt.month.toString().padLeft(2, '0');
    var year = this.arrivalAt.year;

    return "$day/$month/$year";
  }

  String get arrivalTime {
    var hour = this.arrivalAt.hour.toString().padLeft(2, '0');
    var minute = this.arrivalAt.minute.toString().padLeft(2, '0');

    return "$hour:$minute";
  }
}

class FlightController {
  Flight model;
  FlightView view;

  FlightController(this.model) {
    this.view = FlightView(this.model);
  }

  String get detartureDate => this.model.detartureDate;

  String get departureTime => this.model.departureTime;

  String get arrivalDate => this.model.arrivalDate;

  String get arrivalTime => this.model.arrivalTime;

  void updateView() {
    this.view = FlightView(this.model);
  }
}

class FlightView {
  FlightWidget widget;
  Flight model;

  FlightView(Flight model) {
    this.model = model;
    this.widget = FlightWidget(this.model);
  }

  Widget render() => this.widget;
}

class Flights {
  List<Flight> flights;

  Flights(Iterable<Flight> initialFlights) {
    this.flights = List<Flight>();
    this.flights.addAll(initialFlights);
  }

  Iterable<Flight> get allFlights => this.flights;

  void add(Flight flight) => this.flights.add(flight);

  void addAll(Iterable<Flight> toAdd) => this.flights.addAll(toAdd);
}

class FlightsController {
  Flights model;
  FlightsView view;

  FlightsController(this.model) {
    this.view = FlightsView(this.model);
  }

  void add(Flight flight) {
    this.model.add(flight);
    this.updateView();
  }

  void addAll(Iterable<Flight> flightsToAdd) {
    this.model.addAll(flightsToAdd);
    this.updateView();
  }

  Iterable<Flight> get allFlights => this.model.allFlights;

  void updateView() {
    this.view = FlightsView(this.model);
  }
}

class FlightsView {
  Flights model;
  FlightsView(this.model);

  List<Widget> renderFlightsView() {
    var flightsList = this.model.allFlights.toList();
    flightsList
        .sort((a, b) => a.departureAt.difference(b.departureAt).inMinutes);
    return flightsList.map((e) => FlightView(e).render()).toList();
  }

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
