import 'dart:async';

import 'package:Air9/src/flight.dart';
import 'package:flutter/material.dart';
import 'package:Air9/src/search_results_data.dart' show fetchFlights;
import 'package:Air9/src/flight_search.dart' show FlightSearchQuery;

/// a class representing a single search result ofr a particular flight
class FlightSearchResult {
  Flight primaryFlight;
  Flight returnFlight;
  String price;
  bool isOneWay;

  /// a constructor for the class. The constructor recieves
  /// the various paraments related to the details of the flight
  /// e.g origin, destination, date, price, etc.
  FlightSearchResult(
      this.primaryFlight, this.returnFlight, this.price, this.isOneWay);

  /// factory constructor that builds the object based on the data
  /// passed as a JSON
  factory FlightSearchResult.fromJSON(Map<String, dynamic> json) {
    Flight originFlight = Flight(
        json["Origin"]["Flight Number"],
        json["Origin"]['Departure City'],
        json["Origin"]["Arrival City"],
        json["Origin"]["Departure Airport"],
        json["Origin"]["Arrival Airport"],
        DateTime.parse(json["Origin"]["Departure Time"]),
        DateTime.parse(json["Origin"]["Arrival Time"]),
        json["Origin"]["Carrier"]);
    Flight returnFlight;
    if (json["One Way"]) {
      returnFlight = null;
    } else {
      returnFlight = Flight(
          json["Return"]["Flight Number"],
          json["Return"]['Departure City'],
          json["Return"]["Arrival City"],
          json["Return"]["Departure Airport"],
          json["Return"]["Arrival Airport"],
          DateTime.parse(json["Departure Time"]),
          DateTime.parse(json["Arrival Time"]),
          json["Carrier"]);
    }

    return FlightSearchResult(
        originFlight, returnFlight, json["Price"], json["One Way"]);
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
  factory FlightSearchResults.fromJSON(List<Map<String, dynamic>> json) {
    List<FlightSearchResult> results = List<FlightSearchResult>();
    for (var entry in json) {
      results.add(FlightSearchResult.fromJSON(entry));
    }

    return FlightSearchResults.fromCollection(results);
  }

  /// return the size of the collection
  int get size => this.searchResults.length;
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
    return Card(
      child: this.getFlightCard()
    );
  }

  Widget getFlightCard() {
    if(this.isOneWay) {
      return this.getOneWayFlightCard();
    } else {
      return this.getRoundTripFlightCard();
    }
  }

  Widget getOneWayFlightCard() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: this.getPrimaryFlightRow(),
        ),
        VerticalDivider(),
        Expanded(
          flex: 1,
          child: Center(
            child: Text(this.price)
          ),
        ),
        
      ],
    );
  }

  Widget getRoundTripFlightCard() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Column(
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
            child: Text(this.price)
          ),
        ),
      ],
    );
  }

  Widget getPrimaryFlightRow() {
    return Row(
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(this.primaryFlight.departureAirport),
            Text(this.primaryFlight.detartureDate),
            Text(this.primaryFlight.departureTime),
          ],
        ),
        Icon(Icons.arrow_forward),
        Column(
          children: <Widget>[
            Text(this.primaryFlight.arrivalAirport),
            Text(this.primaryFlight.arrivalDate),
            Text(this.primaryFlight.arrivalTime)
          ],
        ),
      ],
    );
  }

  Widget getReturnFlightRow() {
    return Row(
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(this.returnFlight.departureAirport),
            Text(this.returnFlight.detartureDate),
            Text(this.returnFlight.departureTime),
          ],
        ),
        Icon(Icons.arrow_forward),
        Column(
          children: <Widget>[
            Text(this.returnFlight.arrivalAirport),
            Text(this.returnFlight.arrivalDate),
            Text(this.returnFlight.arrivalTime)
          ],
        ),
      ],
    );
  }

  /// returns the data about the search result as a [FlightSearchResult] a.k.a
  /// the model og the widget
  FlightSearchResult get model => this.widget.model;

  /// return the data about the flight as a [Flight]
  Flight get primaryFlight => this.model.primaryFlight;
  Flight get returnFlight => this.model.returnFlight;
  bool get isOneWay => this.model.isOneWay;
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
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.model.size,
      itemBuilder: (context, index) {
        return FlightSearchResultWidget(this.searchResults[index]);
      },
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
          return FlightSearchResultsWidget(snapshot.data);
        } else if (snapshot.hasError) {
          return Text("Sorry, Couldn't find any flights");
        }
        return CircularProgressIndicator();
      },
    );
  }
}
