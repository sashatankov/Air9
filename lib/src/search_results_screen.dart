import 'dart:async';

import 'package:Air9/src/flight.dart';
import 'package:Air9/src/trip.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Air9/src/search_results_data.dart' show fetchFlights;
import 'package:Air9/src/flight_search.dart' show FlightSearchQuery;

/// a class representing a single search result ofr a particular flight
class FlightSearchResult {
  FlightTrip primaryFlight;
  FlightTrip returnFlight;
  String price;
  String currency;
  bool isOneWay;

  /// a constructor for the class. The constructor recieves
  /// the various paraments related to the details of the flight
  /// e.g origin, destination, date, price, etc.
  FlightSearchResult(this.primaryFlight, this.returnFlight, this.price,
      this.currency, this.isOneWay);

  /// factory constructor that builds the object based on the data
  /// passed as a JSON
  factory FlightSearchResult.fromJSON(Map<String, dynamic> json) {
    FlightTrip originFlight = FlightTrip.fromJSON(json["Origin"]);
    FlightTrip returnFlight;
    if (json["One Way"]) {
      returnFlight = null;
    } else {
      returnFlight = FlightTrip.fromJSON(json["Return"]);
    }

    return FlightSearchResult(originFlight, returnFlight, json["Price"],
        json["Currency"], json["One Way"]);
  }

  /// return a string representation of a search result
  @override
  String toString() {
    return "From: " +
        this.primaryFlight.originCity +
        " To: " +
        this.primaryFlight.destinationCity;
  }
}

/// a class represents a collection of [FlightSearchResult] objects
class FlightSearchResults {
  List<FlightSearchResult> searchResults;

  /// a constructor for the class. creates an empty collection of search
  /// results.
  FlightSearchResults() {
    this.searchResults = List<FlightSearchResult>();
  }

  /// a constructor the builds the object from a given collection of [FlightSearchResult]
  FlightSearchResults.fromCollection(Iterable<FlightSearchResult> collection) {
    this.searchResults = List<FlightSearchResult>();
    this.searchResults.addAll(collection);
  }

  /// factory method that build a collection of [FlightSearchResult] objects
  /// from a JSON
  factory FlightSearchResults.fromJSON(List<dynamic> json) {
    List<FlightSearchResult> results = List<FlightSearchResult>();
    for (var entry in json) {
      results.add(FlightSearchResult.fromJSON(entry));
    }

    return FlightSearchResults.fromCollection(results);
  }

  /// sort the search results
  void sort(Comparator<FlightSearchResult> comparator) {
    this.searchResults.sort(comparator);
  }

  /// returns the size of the collection
  int get size => this.searchResults.length;

  /// return a string representation of the search results
  @override
  String toString() {
    String output = "";
    for (FlightSearchResult result in this.searchResults) {
      output += result.toString() + "\n";
    }

    return output;
  }
}

/// a widget class the represents the visual representation of the
/// a single [FlightSearchResult]
class FlightSearchResultWidget extends StatefulWidget {
  final FlightSearchResult model;

  /// a constructor for the class
  FlightSearchResultWidget(this.model);

  @override
  _FlightSearchResultWidgetState createState() =>
      _FlightSearchResultWidgetState();
}

/// a state class for the [FlightSearchResult] widget
class _FlightSearchResultWidgetState extends State<FlightSearchResultWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      height: this.getSearchResultBoxHeight(),
      child: this.getFlightCard(),
    );
  }

  /// return a flight card for a flight
  Widget getFlightCard() {
    if (this.isOneWay) {
      return this.getOneWayFlightCard();
    } else {
      return this.getRoundTripFlightCard();
    }
  }

  /// returns a flight card for the one-way flight, containing the
  /// primary flight.
  Widget getOneWayFlightCard() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: this.getPrimaryFlightRow(),
        ),
        VerticalDivider(),
        Expanded(
          flex: 1,
          child: Center(
            child: Text(
              this.price,
              style: this.getPriceStyle(),
            ),
          ),
        ),
      ],
    );
  }

  /// return a flight card for a round-trip card, containing both
  /// the primary flight and the return flight
  Widget getRoundTripFlightCard() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              this.getPrimaryFlightRow(),
              Divider(),
              this.getReturnFlightRow(),
            ],
          ),
        ),
        VerticalDivider(),
        Expanded(
          flex: 1,
          child: Center(
            child: this.getPrice(),
          ),
        ),
      ],
    );
  }

  Widget getPrice() {
    String text = double.parse(this.price).floor().toInt().toString();
    Locale loc = Locale("en", 'US');
    NumberFormat format = NumberFormat.simpleCurrency(locale: loc.toString());
    return Text("${format.currencySymbol}$text", style: this.getPriceStyle());
  }

  /// returns a [Row] of the primary flight in flight card
  Widget getPrimaryFlightRow() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  this.primaryFlight.originAirport,
                  style: this.getAirportCodeStyle(),
                ),
              ],
            ),
            Icon(Icons.arrow_forward),
            Column(
              children: <Widget>[
                Text(
                  this.primaryFlight.destinationAirport,
                  style: this.getAirportCodeStyle(),
                ),
              ],
            ),
          ],
        ),
        Text(
          "${this.primaryFlight.departureDate}",
          style: this.getDepartureTimeStyle(),
        ),
        this.getPrimaryFlightConnectionsRow(),
      ],
    );
  }

  /// returns a [Row] of the return flight in flight card
  Widget getReturnFlightRow() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  this.returnFlight.originAirport,
                  style: this.getAirportCodeStyle(),
                ),
              ],
            ),
            Icon(Icons.arrow_forward),
            Column(
              children: <Widget>[
                Text(
                  this.returnFlight.destinationAirport,
                  style: this.getAirportCodeStyle(),
                ),
              ],
            ),
          ],
        ),
        Text(
          "${this.returnFlight.departureDate}",
          style: this.getDepartureTimeStyle(),
        ),
        this.getReturnFlightConnectionsRow(),
      ],
    );
  }

  /// returns the style for 'airport-code' for flight card
  TextStyle getAirportCodeStyle() {
    return TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w600,
    );
  }

  /// returns the style for 'departure time' label
  TextStyle getDepartureTimeStyle() {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w200,
    );
  }

  /// returns the style of the price label in flight card
  TextStyle getPriceStyle() {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
    );
  }

  Widget getPrimaryFlightConnectionsRow() {
    String connectionsStr = "";
    String numConnectionStr = "";
    if (this.model.primaryFlight.connections > 1) {
      connectionsStr = "connections";
      numConnectionStr = this.model.primaryFlight.connections.toString();
    } else if (this.model.primaryFlight.connections == 1) {
      connectionsStr = "connection";
      numConnectionStr = this.model.primaryFlight.connections.toString();
    }

    return Row(children: <Widget>[
      Text("$numConnectionStr", style: TextStyle(fontWeight: FontWeight.w600)),
      Text(" $connectionsStr"),
    ]);
  }

  Widget getReturnFlightConnectionsRow() {
    String connectionsStr = "";
    String numConnectionStr = "";
    if (this.model.returnFlight.connections > 1) {
      connectionsStr = "connections";
      numConnectionStr = this.model.returnFlight.connections.toString();
    } else if (this.model.returnFlight.connections == 1) {
      connectionsStr = "connection";
      numConnectionStr = this.model.returnFlight.connections.toString();
    }

    return Row(children: <Widget>[
      Text("$numConnectionStr", style: TextStyle(fontWeight: FontWeight.w600)),
      Text(" $connectionsStr"),
    ]);
  }

  /// returns the height of the flight card box
  /// depending whether the flight is one-way or round trip
  double getSearchResultBoxHeight() {
    return this.isOneWay ? 200 : 250;
  }

  /// returns the data about the search result as a [FlightSearchResult] a.k.a
  /// the model og the widget
  FlightSearchResult get model => this.widget.model;

  /// return the data about the flight as a [Flight]
  FlightTrip get primaryFlight => this.model.primaryFlight;

  /// returns the return-flight of the search result
  FlightTrip get returnFlight => this.model.returnFlight;

  /// returns true if the search result is one-way flight
  bool get isOneWay => this.model.isOneWay;

  /// returns the price of the flight
  String get price => this.model.price;
}

/// a widget class representing the the visual representation
/// of a list of search results
class FlightSearchResultsWidget extends StatefulWidget {
  final String title;
  final FlightSearchResults model;

  /// a constructor for the class
  FlightSearchResultsWidget(this.model, {Key key, this.title})
      : super(key: key);

  @override
  _FlightSearchResultsWidgetState createState() =>
      _FlightSearchResultsWidgetState();
}

/// a state class for the [FlightSearchResultsWidget]
class _FlightSearchResultsWidgetState extends State<FlightSearchResultsWidget> {
  List<FlightSearchResult> _results;
  int _index;

  @override
  void initState() {
    _index = -1;
    _results = this.widget.model.searchResults;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(this.model.toString());
    return ListView.builder(
      itemCount: this.model.size,
      itemBuilder: (context, index) {
        print("Index: $index");
        return Card(
          elevation: 15.0,
          margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: FlightSearchResultWidget(this.searchResults[index]),
        );
      },
      // separatorBuilder: (context, index) {
      //   print("Index $index");
      //   return Card(
      //     margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
      //     color: Colors.lightBlue[100],
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(10.0),
      //     ),
      //     child: FlightSearchResultWidget(this.searchResults[index]),
      //   );
      // },
    );
  }

  /// returns the data about the search result
  FlightSearchResults get model => this.widget.model;

  /// returns a list of search results
  List<FlightSearchResult> get searchResults => this.model.searchResults;
}

/// a widget class representing the entire search results screen
class FlightSearchResultsScreenWidget extends StatefulWidget {
  final FlightSearchQuery query;

  /// a constructor for the class
  /// the constructor recieves a [FlightSearchQuery] as a parameter
  FlightSearchResultsScreenWidget(this.query);
  @override
  _FlightSearchResultsScreenWidgetState createState() =>
      _FlightSearchResultsScreenWidgetState();
}

/// a state class for the [FlightSearchREsultsScreenWidget]
class _FlightSearchResultsScreenWidgetState
    extends State<FlightSearchResultsScreenWidget> {
  Future<FlightSearchResults> _futureSearchResultFlights;
  @override
  void initState() {
    super.initState();
    this._futureSearchResultFlights = fetchFlights(this.widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Air9"),
      ),
      body: Center(
        child: this.getScreenBody(),
      ),
    );
  }

  /// returns the body of the screen
  Widget getScreenBody() {
    return FutureBuilder<FlightSearchResults>(
      future: this._futureSearchResultFlights,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print("Recieved data: ");
          print(snapshot.data.toString());
          return FlightSearchResultsWidget(snapshot.data);
        } else if (snapshot.hasError) {
          return Text("Sorry, Couldn't find any flights");
        }
        return CircularProgressIndicator();
      },
    );
  }
}
