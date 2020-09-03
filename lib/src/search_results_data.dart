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

Future<FlightSearchResults> fetchFlights(FlightSearchQuery query) async {
  List<String> originAirportCodes = await getAirportCodes(query.from);
  List<String> destinationAirportCodes = await getAirportCodes(query.to);
  List<String> urls;
  for (String originCode in originAirportCodes) {
    for (String destinationCode in destinationAirportCodes) {
      urls.add(getFlightRoutesURL(
          originCode, destinationCode, formattedDate(query.departureDate)));
    }
  }
  List<Map<String, dynamic>> data = List<Map<String, dynamic>>();
  for (String url in urls) {
    final dynamic response = await http.get(url);
    final dynamic responseBody = json.decode(response.body);
    data.add(responseBody);
  }
  // TODO: to come up with a json template for constructor
  return FlightSearchResults.fromJSON(data);
}

String getFlightQuotesURL(String originAirportCode,
    String destinationAirportCode, String departureDate,
    {String returnDate = "",
    String userLocationCountry = "US",
    String resultsCurrency = "USD",
    String resultsLanguage = "en-US"}) {
  return "${rapidApiHosts[skyScannerStr]}/apiservices/browsequotes/v1.0/$userLocationCountry/$resultsCurrency/$resultsLanguage/$originAirportCode/$destinationAirportCode/$departureDate/$returnDate";
}

String getFlightRoutesURL(String originAirportCode,
    String destinationAirportCode, String departureDate,
    {String returnDate = "",
    String userLocationCountry = "US",
    String resultsCurrency = "USD",
    String resultsLanguage = "en-US"}) {
  return "${rapidApiHosts[skyScannerStr]}/apiservices/browseroutes/v1.0/$userLocationCountry/$resultsCurrency/$resultsLanguage/$originAirportCode/$destinationAirportCode/$departureDate/$returnDate";
}

String getAirportsURL(String placeName,
    {String userLocationCountry = "US",
    String resultsCurrency = "USD",
    String resultsLanguage = "en-US"}) {
  return "${rapidApiHosts[tripAdvisorStr]}/airports/search/?locale=$resultsLanguage&query=$placeName";
}

Future<List<String>> getAirportCodes(String placeName) async {
  List<String> codes = List<String>();
  List<Map<String, dynamic>> airports;
  var url = getAirportsURL(placeName);
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final List<Map<String, dynamic>> responseBody = json.decode(response.body);
    if (responseBody[0].containsKey("display_sub_title")) {
      airports = responseBody.sublist(1);
    } else {
      airports = responseBody;
    }

    for (var airport in airports) {
      codes.add(airport["code"]);
    }

    return codes;
  } else {
    throw Exception("Failed to get airport data");
  }
}

/// return a string representation of a date
String formattedDate(DateTime date) {
  return "${date.year.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}
