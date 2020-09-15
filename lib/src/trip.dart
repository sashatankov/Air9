import 'package:flutter/material.dart';
import 'package:Air9/src/flight.dart' show Flight;

/// a class representing a flight trip
/// a flight trip consists of a list of flights
/// such as flight_i depat onlt after flight_i-1 lands.
class FlightTrip {
  List<Flight> flights;

  /// a constructor for the class, recieves a collection of flights
  /// and creates a trip out of these flights
  FlightTrip(Iterable<Flight> flights) {
    this.flights = List<Flight>();
    this.flights.addAll(flights);
  }

  /// returns the city where the trip begins, i.e the first flight departs
  String get originCity => this.flights.first.departureCity;

  /// returns the city where the trip ends, i.e the last city lands
  String get destinationCity => this.flights.last.arrivalCity;

  /// returns a list of flights that are connction flights in the trip
  /// i.e all the flights besides the first and last
  List<Flight> get connections =>
      this.flights.sublist(1, this.flights.length - 1);

}

/// a controller class for the [FlightTrip] class
class FlightTripController {
  FlightTrip model;
  FlightTripView view;

  /// a constructor for the class
  FlightTripController(this.model) {
    this.view = FlightTripView(this);
  }
}

/// a view class for the [FlightTrip]
class FlightTripView {
  FlightTripWidget widget;
  FlightTripController controller;

  /// a constructor for the class
  FlightTripView(this.controller) {
    this.widget = FlightTripWidget(this.controller);
  }

  /// returns a [Widget] with all the components
  Widget render() {
    return this.widget;
  }
}

/// a widget for the flight trip
class FlightTripWidget extends StatefulWidget {
  final FlightTripController controller;

  FlightTripWidget(this.controller);
  @override
  _FlightTripWidgetState createState() => _FlightTripWidgetState();
}

/// a state class for the [FlightTripWidget]
class _FlightTripWidgetState extends State<FlightTripWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
