import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Air9/src/search_results_screen.dart' show FlightSearchResults;
import 'package:Air9/src/flight_search.dart' show FlightSearchQuery;

const String skyScannerStr = "Sky Scanner";
const String tripAdvisorStr = "TripAdvisor";
const String rapidStr = "rapid";

// a list of api host to retreive data from
const Map<String, String> rapidApiHosts = {
  "Sky Scanner": "skyscanner-skyscanner-flight-search-v1.p.rapidapi.com",
  "TripAdvisor": "tripadvisor1.p.rapidapi.com"
};

// a list of keys to access the apis
const Map<String, String> apiKeys = {
  "rapid": "af68c74026mshacfcc9302076c22p1787cfjsn6a661cfe6bbb"
};

/// the function fetches flights according to the [FlightSearchQuery]
/// from the skyscanner api. return a [FlightSearchResults] object
/// containing all the flight data
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
  List<Map<String, String>> data = List<Map<String, dynamic>>();
  for (String url in urls) {
    final dynamic response = await http.get(url);
    List<Map<String, String>> flightEntries = jsonFromResponse(response);
    data.addAll(flightEntries);
  }

  return FlightSearchResults.fromJSON(data);
}

/// returns a url to make the request from, according to the
/// airport origin, airport destination and departure date
/// the airport codes are according to IATA standard. e.g JFK, CDG, etc.
String getFlightQuotesURL(String originAirportCode,
    String destinationAirportCode, String departureDate,
    {String returnDate = "",
    String userLocationCountry = "US",
    String resultsCurrency = "USD",
    String resultsLanguage = "en-US"}) {
  return "${rapidApiHosts[skyScannerStr]}/apiservices/browsequotes/v1.0/$userLocationCountry/$resultsCurrency/$resultsLanguage/$originAirportCode/$destinationAirportCode/$departureDate/$returnDate";
}

/// returns a url to make the request from, according to the
/// city/coutry origin, city/country destination and departure date
/// the airport codes are according to IATA standard. e.g PARI, NYCA, etc.
String getFlightRoutesURL(
    String originCode, String destinationCode, String departureDate,
    {String returnDate = "",
    String userLocationCountry = "US",
    String resultsCurrency = "USD",
    String resultsLanguage = "en-US"}) {
  return "${rapidApiHosts[skyScannerStr]}/apiservices/browseroutes/v1.0/$userLocationCountry/$resultsCurrency/$resultsLanguage/$originCode/$destinationCode/$departureDate/$returnDate";
}

/// returns the url to make a request from, in order to get
/// the airport code from a name of city
String getAirportsURL(String placeName,
    {String userLocationCountry = "US",
    String resultsCurrency = "USD",
    String resultsLanguage = "en-US"}) {
  return "${rapidApiHosts[tripAdvisorStr]}/airports/search/?locale=$resultsLanguage&query=$placeName";
}

/// makes an api request to retreive the airport codes according
/// to the name of the city
Future<List<String>> getAirportCodes(String placeName) async {
  List<String> codes = List<String>();
  List<Map<String, dynamic>> airports;
  var url = getAirportsURL(placeName);
  final response = await http.get(url);
  if (response.statusCode == 200) {

    final List<Map<String, dynamic>> responseBody = json.decode(response.body);

    // in some requests the first entry is data about the city itselt
    // if so, remove it from the response body.
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

/// returns data from response as json
List<Map<String, String>> jsonFromResponse(dynamic response) {
  final dynamic responseBody = json.decode(response.body);
  List<Map<String, String>> flightDataEntries = List<Map<String, dynamic>>();
  for (var quote in responseBody["Quotes"]) {
    Map<String, String> flightDataEntry =
        getFlightDataEntryFromQuote(quote, responseBody);
    flightDataEntries.add(flightDataEntry);
  }

  return flightDataEntries;
}

/// returns a dictionary containing data ablot a flight.
/// a dictionary is built from json api response and a flight quote
/// in the response.
Map<String, String> getFlightDataEntryFromQuote(var quote, dynamic responseBody) {
  Map<String, String> flightDataEntry = Map<String, String>();
  flightDataEntry["Flight Number"] = "";
  flightDataEntry["Departure City"] =
      getDepartureCityFromQuote(quote, responseBody);
  flightDataEntry["Arrival City"] =
      getArrivalCityFromQuote(quote, responseBody);
  flightDataEntry["Departure Airport"] =
      getDepartureAirportFromQuote(quote, responseBody);
  flightDataEntry["Arrival Airport"] =
      getArrivalAirportFromQuote(quote, responseBody);
  flightDataEntry["Departure Time"] = quote["OutboudLeg"]["DepartureDate"];
  flightDataEntry["Arrival Time"] = "";
  flightDataEntry["Carrier"] = getCarrierNameFromQuote(quote, responseBody);
  flightDataEntry["Price"] = quote["MinPrice"];

  return flightDataEntry;
}

/// returns the departure city of a partucular flight quote
String getDepartureCityFromQuote(var quote, dynamic responseBody) {
  var cityId = quote["OutboundLeg"]["OriginId"];
  return getCityNameFromCityId(cityId, responseBody);
}

/// returns the arrival city of a particular flight quote
String getArrivalCityFromQuote(var quote, dynamic responseBody) {
  var cityId = quote["OutboundLeg"]["DestinationId"];
  return getCityNameFromCityId(cityId, responseBody);
}

/// return the name of a city from cityId, if cityId not found
/// returns an empty string
String getCityNameFromCityId(var cityId, dynamic responseBody) {
  for (var place in responseBody["Places"]) {
    if (place["PlaceId"] == cityId) {
      return place["CityName"];
    }
  }

  return "";
}

/// returns the departure airport from a flight quote
String getDepartureAirportFromQuote(var quote, dynamic responseBody) {
  var cityId = quote["OutboundLeg"]["OriginId"];
  return getAirportCodeFromCityId(cityId, responseBody);
}

/// returns the arrival airport from a flight quote
String getArrivalAirportFromQuote(var quote, dynamic responseBody) {
  var cityId = quote["OutboundLeg"]["DestinationId"];
  return getAirportCodeFromCityId(cityId, responseBody);
}

/// return the airport code of a city with id of cityId.
/// if not found, returns an empty string
String getAirportCodeFromCityId(var cityId, dynamic responseBody) {
  for (var place in responseBody["Places"]) {
    if (place["PlaceId"] == cityId) {
      return place["IataCode"];
    }
  }

  return "";
}

/// returns a name of a carrier from a flight quote.
/// if a flights has multiple carriers, returns a string with
/// all carriers, space separated
String getCarrierNameFromQuote(var quote, dynamic responseBody) {
  Set<int> carrierIds = Set<int>.from(quote["OutboundLeg"]["CarrierIds"]);
  String carrierIdsStr = "";

  for (var carrier in responseBody["Carriers"]) {
    if (carrierIds.contains(carrier["CarrierId"])) {
      carrierIdsStr = carrierIdsStr + " " + carrier["CarrierId"].toString();
    }
  }

  return carrierIdsStr;
}
