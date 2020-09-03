import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Air9/src/search_results_screen.dart' show FlightSearchResults;
import 'package:Air9/src/flight_search.dart' show FlightSearchQuery;

const String skyScannerStr = "Sky Scanner";
const String tripAdvisorStr = "TripAdvisor";
const String rapidStr = "rapid";

const Map<String, String> rapidApiHosts = {
  "Sky Scanner": "skyscanner-skyscanner-flight-search-v1.p.rapidapi.com",
  "TripAdvisor": "tripadvisor1.p.rapidapi.com"
};

const Map<String, String> apiKeys = {
  "rapid": "af68c74026mshacfcc9302076c22p1787cfjsn6a661cfe6bbb"
};

Future<FlightSearchResults> fetchFlights(FlightSearchQuery query) async {}



String getFlightQuotesURL(String originAirportCode, String destinationAirportCode, String departureDate,
{String returnDate = "", String userLocationCountry = "US", String resultsCurrency = "USD",
String resultsLanguage = "en-US"}) {

  return "${rapidApiHosts[skyScannerStr]}/apiservices/browsequotes/v1.0/$userLocationCountry/$resultsCurrency/$resultsLanguage/$originAirportCode/$destinationAirportCode/$departureDate/$returnDate";
}

String getFlightRoutesURL(String originAirportCode, String destinationAirportCode, String departureDate,
{String returnDate = "", String userLocationCountry = "US", String resultsCurrency = "USD",
String resultsLanguage = "en-US"}) {

  return "${rapidApiHosts[skyScannerStr]}/apiservices/browseroutes/v1.0/$userLocationCountry/$resultsCurrency/$resultsLanguage/$originAirportCode/$destinationAirportCode/$departureDate/$returnDate";

}

String getPlacesURL(String placename, {String userLocationCountry = "US", String resultsCurrency = "USD", String resultsLanguage = "en-US"}) {
  return "${rapidApiHosts[skyScannerStr]}/apiservices/autosuggest/v1.0/$userLocationCountry/$resultsCurrency/$resultsLanguage/?query=$placename";
}

