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
        Container(
            height:
                75), // dummy container, in order to see befing the order button
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
    return Container(
      margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Card(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
              height: 200,
              child: this.getDepartureDetails(flight),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
              height: 200,
              child: this.getArrivalDetails(flight),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5.0,
      ),
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

  TextStyle getWaitingTimeStyle() {
    return TextStyle(
      fontWeight: FontWeight.w500
    );
  }

  List<Widget> getFlightSegmentList(FlightTrip trip) {
    List<Flight> flights = trip.flights;
    List<Widget> widgets = List<Widget>();
    var flightDetailsWidgets =
        flights.map((Flight e) => this.getFlightSegmentDetails(e)).toList();
    var waitingTimesWidgets = this.getWaitingTimesTextWidgets(trip);

    for (int i = 0; i < waitingTimesWidgets.length; ++i) {
      widgets.add(flightDetailsWidgets[i]);
      widgets.add(waitingTimesWidgets[i]);
    }
    widgets.add(flightDetailsWidgets.last);

    return widgets;
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

  List<Widget> getWaitingTimesTextWidgets(FlightTrip trip) {
    return this
        .getWaitingTimesText(trip)
        .map((e) => this.getWaitingTimeWidget(e))
        .toList();
  }

  Widget getWaitingTimeWidget(String waitingTime) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Waiting Time "),
          Text(
            waitingTime,
            style: this.getWaitingTimeStyle(),
          )
        ],
      ),
    );
  }

  List<String> getWaitingTimesText(FlightTrip trip) {
    List<Duration> waitingTimes = this.getWaitingTimesBetweenFlights(trip);
    return waitingTimes.map((e) => this.getWaitingTimeMessage(e)).toList();
  }

  List<Duration> getWaitingTimesBetweenFlights(FlightTrip trip) {
    List<Duration> times = List<Duration>();
    Duration duration;
    var flights = trip.flights;
    for (int i = 0; i < flights.length - 1; ++i) {
      duration = flights[i + 1].departureAt.difference(flights[i].arrivalAt);
      times.add(duration);
    }

    return times;
  }

  String getWaitingTimeMessage(Duration duration) {
    String message = "";
    int hour = duration.inHours;
    int minute = duration.inMinutes - (hour * 60);

    if (hour > 0) {
      message = "$hour ";
      if (hour == 1) {
        message += "hour ";
      } else {
        message += "hours ";
      }
    }

    if (minute > 0) {
      message += "$minute ";
      if (minute == 1) {
        message += "minute";
      } else {
        message += "minutes";
      }
    }

    return message;
  }
}
