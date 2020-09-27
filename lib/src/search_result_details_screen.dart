import 'package:Air9/src/flight.dart';
import 'package:flutter/material.dart';
import 'package:Air9/src/search_results_screen.dart' show FlightSearchResult;

class FlightSearchResultDetailsScreen extends StatefulWidget {
  FlightSearchResult searchResult;

  FlightSearchResultDetailsScreen(this.searchResult);
  @override
  _FlightSearchResultDetailsScreenState createState() =>
      _FlightSearchResultDetailsScreenState();
}

class _FlightSearchResultDetailsScreenState
    extends State<FlightSearchResultDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Air9"),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              child: this.getItineraryDetails(),
            ),
          ),
          Container(
            child: RaisedButton(onPressed: null),
            alignment: Alignment(0.0, 1.0),
          ),
        ],
      ),
    );
  }

  Widget getItineraryDetails() {
    return Column(
      children: <Widget>[
        this.getPrimaryFlightItineraryDetails(),
        this.getReturnFlightItineraryDetails(),
      ],
    );
  }

  Widget getPrimaryFlightItineraryDetails() {
    return Column(
      children: [],
    );
  }

  Widget getReturnFlightItineraryDetails() {
    return Column(
      children: [],
    );
  }

  Widget getFlightSegmentsDetails() {
    
    return Column();
  }

  Widget getFlightSegmentDetails(Flight flight) {
    return Column(
      children: <Widget>[
        this.getDepartureDetails(flight),
        this.getArrivalDetails(flight),
      ],
    );
  }

  Widget getDepartureDetails(Flight flight) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Column(
            children: <Widget>[
              Text(
                flight.departureCity,
                style: this.getCityStyle(),
              ),
              Text(
                flight.departureAirport,
                style: this.getAirportStyle(),
              ),
              Text(
                flight.detartureDate,
                style: this.getDateStyle(),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: Text(
              flight.departureTime,
              style: this.getTimeStyle(),
            ),
          ),
        ),
      ],
    );
  }

  Widget getArrivalDetails(Flight flight) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Column(
            children: <Widget>[
              this.getFlightNumber(flight),
              Text(
                flight.arrivalCity,
                style: this.getCityStyle(),
              ),
              Text(
                flight.arrivalAirport,
                style: this.getAirportStyle(),
              ),
              Text(
                flight.arrivalDate,
                style: this.getDateStyle(),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: Text(
              flight.arrivalTime,
              style: this.getTimeStyle(),
            ),
          ),
        ),
      ],
    );
  }

  Widget getFlightNumber(Flight flight) {
    return Text(
      flight.flightNumber,
      style: this.getFlightNumberStyle(),
    );
  }

  TextStyle getCityStyle() {}

  TextStyle getAirportStyle() {}

  TextStyle getFlightNumberStyle() {}

  TextStyle getDateStyle() {}

  TextStyle getTimeStyle() {}
}
