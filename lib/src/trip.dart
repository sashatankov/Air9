import 'package:flutter/material.dart';
import 'package:Air9/src/flight.dart' show Flight;

class FlightTrip {
  List<Flight> flights;

  FlightTrip(Iterable<Flight> flights) {
    this.flights = List<Flight>();
    this.flights.addAll(flights);
  }

  String get originCity => this.flights.first.departureCity;

  String get destinationCity => this.flights.last.arrivalCity;

  List<Flight> get connections =>
      this.flights.sublist(1, this.flights.length - 1);

}

class FlightTripController {
  FlightTrip model;
  FlightTripView view;

  FlightTripController(this.model) {
    this.view = FlightTripView(this);
  }
}

class FlightTripView {
  FlightTripWidget widget;
  FlightTripController controller;

  FlightTripView(this.controller) {
    this.widget = FlightTripWidget(this.controller);
  }

  Widget render() {
    return this.widget;
  }
}

class FlightTripWidget extends StatefulWidget {
  final FlightTripController controller;

  FlightTripWidget(this.controller);
  @override
  _FlightTripWidgetState createState() => _FlightTripWidgetState();
}

class _FlightTripWidgetState extends State<FlightTripWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
