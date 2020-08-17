import 'package:flutter/material.dart';

class Flight {
  String departureCity;
  String arrivalCity;
  String departureAirport;
  String arrivalAirport;
  String departureTime;
  String arrivalTime;
  String departureDate;
  String arrivalDate;
  List<Flight> connections;

  Flight(
      this.departureCity,
      this.arrivalCity,
      this.departureAirport,
      this.arrivalAirport,
      this.departureTime,
      this.arrivalTime,
      this.departureDate,
      this.arrivalDate,
      {this.connections = const <Flight>[]});
}

class FlightWidget extends StatefulWidget {
  final Flight flight;
  FlightWidget(this.flight);

  @override
  _FlightWidgetState createState() => _FlightWidgetState();
}

class _FlightWidgetState extends State<FlightWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              this.departureInfo(),
              Icon(Icons.arrow_forward),
              this.arrivalInfo()
            ],
            mainAxisAlignment: MainAxisAlignment.start,
          ),
          Container(child: Text("${this.connectionsMessage()}")),
        ],
      ),
      padding: EdgeInsets.all(16),
    );
  }

  String connectionsMessage() {
    var numOfConnections = this.widget.flight.connections.length;
    if (numOfConnections > 1) {
      return "${numOfConnections} connections";
    } else if (numOfConnections == 1) {
      return "${numOfConnections} connection";
    }
    return "";
  }

  Widget departureInfo() {
    return Column(
      children: [
        Text(
            "${this.widget.flight.departureCity}"), // TODO probably increase the font
        Text("${this.widget.flight.departureAirport}"),
        Text(
            "${this.widget.flight.departureDate}  ${this.widget.flight.departureTime}"),
      ],
    );
  }

  Widget arrivalInfo() {
    return Column(
      children: [
        Text("${this.widget.flight.arrivalCity}"), // TODO probably increase the font
        Text("${this.widget.flight.arrivalAirport}"),
        Text(
            "${this.widget.flight.arrivalDate}  ${this.widget.flight.arrivalTime}"),
      ],
    );
  }
}
