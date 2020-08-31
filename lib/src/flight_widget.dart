import 'package:flutter/material.dart';
import 'flight.dart';


/// a widget class to diplay the flight details of the upcoming flight
class FlightWidget extends StatefulWidget {
  final Flight flight;
  FlightWidget(this.flight);

  @override
  _FlightWidgetState createState() => _FlightWidgetState();
}

/// a state class for the [FlightWidget]
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
        ],
      ),
      padding: EdgeInsets.all(16),
    );
  }


  /// returns the info about the departure of the flight
  /// e.g city, airport, date, time of departure
  Widget departureInfo() {
    return this.locationInfoColumn(
        this.widget.flight.departureCity,
        this.widget.flight.departureAirport,
        this.widget.flight.detartureDate,
        this.widget.flight.departureTime);
  }

  /// returns the info about the arrival of the flight
  /// e.g city, airport, date, time
  Widget arrivalInfo() {
    return this.locationInfoColumn(
        this.widget.flight.arrivalCity,
        this.widget.flight.arrivalAirport,
        this.widget.flight.arrivalDate,
        this.widget.flight.arrivalTime);
  }
  
  /// returns the given info as a [Column] widget
  Widget locationInfoColumn(
      String city, String airport, String date, String time) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("$city", style: this.cityStyle()),
        Text("$airport", style: this.airportStyle()),
        Text("$date", style: this.dateStyle()),
        Text("$time", style: this.dateStyle())
      ],
    );
  }

  /// returns a style for the departure/arrival cityies of the flight
  TextStyle cityStyle() {
    return TextStyle(
      color: Colors.black87, 
      fontSize: 24,
    );
  }

  /// returns a style for the departure/arrival airports of the flight
  TextStyle airportStyle() {
    return TextStyle(
      color: Colors.black38, 
      fontSize: 16,
    );
  }

  /// returns a style for the departure/arrival dates of the flights
  TextStyle dateStyle() {
    return TextStyle(
      color: Colors.black87, 
      fontSize: 16,
    );
  }
}
