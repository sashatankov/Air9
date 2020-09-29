import 'package:Air9/src/flight.dart';
import 'package:Air9/src/trip.dart';
import 'package:flutter/material.dart';
import 'package:Air9/src/search_results_screen.dart' show FlightSearchResult;
import 'package:intl/intl.dart';

class FlightSearchResultDetailsScreen extends StatefulWidget {
  final FlightSearchResult searchResult;

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
        children: [
          SingleChildScrollView(
            child: this.getItineraryDetails(),
          ),
          Container(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: ConstrainedBox(
              child: RaisedButton(
                child: Text(
                  "Order Now ${this.getPrice()}",
                  style: this.getPriceStyle(),
                ),
                onPressed: () {},
                color: Colors.green,
                textColor: Colors.white,
              ),
              constraints: const BoxConstraints(
                minWidth: double.infinity,
                maxHeight: 75,
                minHeight: 75,
              ),
            ),
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
        Container(height: 75), // dummy container, in order to see befing the order button
      ],
    );
  }

  Widget getPrimaryFlightItineraryDetails() {
    return this.getFlightSegmentsDetails(this.searchResult.primaryFlight);
  }

  Widget getReturnFlightItineraryDetails() {
    return this.getFlightSegmentsDetails(this.searchResult.returnFlight);
  }

  Widget getFlightSegmentsDetails(FlightTrip trip) {
    return Column(
      children: this.getFlightSegmentList(trip),
    );
  }

  Widget getFlightSegmentDetails(Flight flight) {
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
            height: 200,
            child: this.getDepartureDetails(flight)),
        Container(
          padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
          height: 200,
          child: this.getArrivalDetails(flight),
        ),
      ],
    );
  }

  Widget getDepartureDetails(Flight flight) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              this.getFlightNumber(flight),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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

  TextStyle getCityStyle() {
    return TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle getAirportStyle() {
    return TextStyle(
      fontSize: 18,
    );
  }

  TextStyle getFlightNumberStyle() {
    return TextStyle(
      fontSize: 14,
    );
  }

  TextStyle getDateStyle() {
    return TextStyle(
      fontSize: 18,
    );
  }

  TextStyle getTimeStyle() {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle getPriceStyle() {
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w500,
    );
  }

  List<Widget> getFlightSegmentList(FlightTrip trip) {
    List<Flight> flights = trip.flights;
    return flights.map((Flight e) => this.getFlightSegmentDetails(e)).toList();
  }

  FlightSearchResult get searchResult => this.widget.searchResult;

  /// return a string with the price and currency of the flight
  String getPrice() {
    String text =
        double.parse(this.searchResult.price).floor().toInt().toString();
    Locale loc = Locale("en", 'US');
    NumberFormat format =
        NumberFormat.simpleCurrency(name: this.searchResult.currency);
    return "${format.currencySymbol}$text";
  }
}
