import 'dart:async';

import 'package:Air9/src/flight.dart';
import 'package:flutter/material.dart';
import 'package:Air9/src/search_results_data.dart' show fetchFlights;
import 'package:Air9/src/flight_search.dart' show FlightSearchQuery;

class FlightSearchResult {
  Flight flight;
  String price;

  FlightSearchResult(
      String flightNumber,
      String departureCity,
      String arrivalCity,
      String departureAirport,
      String arrivalAirport,
      DateTime departureAt,
      DateTime arrivalAt,
      String airline,
      String price) {
    this.flight = Flight(flightNumber, departureCity, arrivalCity,
        departureAirport, arrivalAirport, departureAt, arrivalAt, airline);
    this.price = price;
  }

  factory FlightSearchResult.fromJSON(Map<String, dynamic> json) {
    return FlightSearchResult(); // TODO: to parse the json
  }
}

class FlightSearchResults {
  List<FlightSearchResult> searchResults;

  FlightSearchResults() {
    this.searchResults = List<FlightSearchResult>();
  }

  factory FlightSearchResults.fromJSON(List<Map<String, dynamic>> json) {}

  int get size => this.searchResults.length;
}

class FlightSearchResultWidget extends StatefulWidget {
  final FlightSearchResult model;

  FlightSearchResultWidget(this.model);

  @override
  _FlightSearchResultWidgetState createState() =>
      _FlightSearchResultWidgetState();
}

class _FlightSearchResultWidgetState extends State<FlightSearchResultWidget> {
  @override
  Widget build(BuildContext context) {
    return Card();
  }

  FlightSearchResult get model => this.widget.model;
  Flight get flight => this.model.flight;
}

class FlightSearchResultsWidget extends StatefulWidget {
  final String title;
  final FlightSearchResults model;

  FlightSearchResultsWidget(this.model, {Key key, this.title})
      : super(key: key);
  @override
  _FlightSearchResultsWidgetState createState() =>
      _FlightSearchResultsWidgetState();
}

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

  FlightSearchResults get model => this.widget.model;
  List<FlightSearchResult> get searchResults => this.model.searchResults;
}

class FlightSearchResultsScreenWidget extends StatefulWidget {
  final FlightSearchQuery query;

  FlightSearchResultsScreenWidget(this.query);
  @override
  _FlightSearchResultsScreenWidgetState createState() =>
      _FlightSearchResultsScreenWidgetState();
}

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
