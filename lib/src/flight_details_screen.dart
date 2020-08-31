import 'package:flutter/material.dart';
import 'package:Air9/src/trip.dart' show FlightTrip;

class FlightDetailsScreen {
  FlightTrip trip;

  FlightDetailsScreen(FlightTrip trip) {
    this.trip = trip;
  }
}

class FlightDetailsScreenController {
  FlightDetailsScreen model;
  FlightDetailsScreenView view;
}

class FlightDetailsScreenView {
  FlightDetailsScreenWidget widget;
  FlightDetailsScreenController controller;
  FlightDetailsScreenView(this.controller) {
    this.widget = FlightDetailsScreenWidget(this.controller);
  }

  Widget render() {
    return this.widget;
  }
}

class FlightDetailsScreenWidget extends StatefulWidget {
  final FlightDetailsScreenController controller;

  FlightDetailsScreenWidget(this.controller);
  @override
  _FlightDetailsScreenWidgetState createState() =>
      _FlightDetailsScreenWidgetState();
}

class _FlightDetailsScreenWidgetState extends State<FlightDetailsScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
