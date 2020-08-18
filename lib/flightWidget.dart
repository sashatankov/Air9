import 'package:flutter/material.dart';
import 'flight.dart';



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
              Icon(
                Icons.arrow_forward,
                color: Colors.black54,
              ),
              this.arrivalInfo()
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
      return "$numOfConnections connections";
    } else if (numOfConnections == 1) {
      return "$numOfConnections connection";
    }
    return "";
  }

  Widget departureInfo() {
    return this.locationInfoColumn(
        this.widget.flight.departureCity,
        this.widget.flight.departureAirport,
        this.widget.flight.detartureDate,
        this.widget.flight.departureTime);
  }

  Widget arrivalInfo() {
    return this.locationInfoColumn(
        this.widget.flight.arrivalCity,
        this.widget.flight.arrivalAirport,
        this.widget.flight.arrivalDate,
        this.widget.flight.arrivalTime);
  }

  Widget locationInfoColumn(
      String city, String airport, String date, String time) {
    return Column(
      children: [
        Text("$city", style: this.cityStyle()),
        Text("$airport", style: this.airportStyle()),
        Text("$date  $time", style: this.dateStyle()),
      ],
    );
  }

  TextStyle cityStyle() {
    return TextStyle(color: Colors.black87, fontSize: 24);
  }

  TextStyle airportStyle() {
    return TextStyle(color: Colors.black38, fontSize: 16);
  }

  TextStyle dateStyle() {
    return TextStyle(color: Colors.black87, fontSize: 16);
  }
}
