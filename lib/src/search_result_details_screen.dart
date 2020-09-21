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
    return Container();
  }
}
