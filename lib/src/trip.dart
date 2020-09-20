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

  factory FlightTrip.fromJSON(List<dynamic> flightsAsJson) {
    List<Flight> flights = List<Flight>();
    for (var flightAsJson in flightsAsJson) {
      Flight flight = Flight(
          flightAsJson["Flight Number"],
          flightAsJson["Departure City"],
          flightAsJson["Arrival City"],
          flightAsJson["Departure Airport"],
          flightAsJson["Arrival Airport"],
          DateTime.parse(flightAsJson["Departure Time"]),
          DateTime.parse(flightAsJson["Arrival Time"]),
          flightAsJson["Carrier"]);
      flights.add(flight);
    }

    return FlightTrip(flights);
  }

  /// returns the city where the trip begins, i.e the first flight departs
  String get originCity => this.flights.first.departureCity;

  /// returns the city where the trip ends, i.e the last city lands
  String get destinationCity => this.flights.last.arrivalCity;

  String get originAirport => this.flights.first.departureAirport;

  String get destinationAirport => this.flights.last.arrivalAirport;

  String get departureTime => this.flights.first.departureTime;

  String get arrivalTime => this.flights.last.arrivalTime;

  String get departureDate => this.flights.first.detartureDate;

  String get arrivalDate => this.flights.last.arrivalDate;

  /// returns a list of flights that are connection flights in the trip
  /// i.e all the flights besides the first and last
  int get connections => this.flights.length - 1;
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
