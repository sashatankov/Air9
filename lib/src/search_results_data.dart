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
  List<Map<String, dynamic>> data = List<Map<String, dynamic>>();
  for (String url in urls) {
    final dynamic response = await http.get(url);
    List<Map<String, dynamic>> flightEntries = jsonFromResponse(response);
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
  return "${rapidApiHosts[skyScannerStr]}/apiservices/browsequotes/v1.0/$userLocationCountry/$resultsCurrency/$resultsLanguage/$originAirportCode/$destinationAirportCode/$departureDate?inboundpartialdate=$returnDate";
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
  return "${rapidApiHosts[skyScannerStr]}/apiservices/browseroutes/v1.0/$userLocationCountry/$resultsCurrency/$resultsLanguage/$originCode/$destinationCode/$departureDate?inboundpartialdate=$returnDate";
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
  List<Map<String, dynamic>> flightDataEntries = List<Map<String, dynamic>>();
  for (var quote in responseBody["Quotes"]) {
    Map<String, dynamic> flightDataEntry =
        getFlightDataEntryFromQuote(quote, responseBody);
    flightDataEntries.add(flightDataEntry);
  }

  return flightDataEntries;
}

/// returns a dictionary containing data ablot a flight.
/// a dictionary is built from json api response and a flight quote
/// in the response.
Map<String, dynamic> getFlightDataEntryFromQuote(
    var quote, dynamic responseBody) {
  Map<String, dynamic> flightDataEntry = Map<String, dynamic>();
  flightDataEntry["Price"] = quote["MinPrice"].toString();
  flightDataEntry["One Way"] = false;
  flightDataEntry["Origin"] =
      getPrimaryFlightDataFromQuote(quote, responseBody);

  if (quote.containsKey("InboundLeg")) {
    flightDataEntry["Return"] =
        getReturnFlightDataFromQuote(quote, responseBody);
    flightDataEntry["One Way"] = true;
  } else {
    flightDataEntry["Return"] = null;
  }

  return flightDataEntry;
}

Map<String, String> getPrimaryFlightDataFromQuote(
    var quote, dynamic responseBody) {
  Map<String, String> primaryFlightDataEntry = Map<String, String>();
  primaryFlightDataEntry["Flight Number"] = "";
  primaryFlightDataEntry["Departure City"] =
      getPrimaryDepartureCityFromQuote(quote, responseBody);
  primaryFlightDataEntry["Arrival City"] =
      getPrimaryArrivalCityFromQuote(quote, responseBody);
  primaryFlightDataEntry["Departure Airport"] =
      getPrimaryDepartureAirportFromQuote(quote, responseBody);
  primaryFlightDataEntry["Arrival Airport"] =
      getPrimaryArrivalAirportFromQuote(quote, responseBody);
  primaryFlightDataEntry["Departure Time"] =
      quote["OutboundLeg"]["DepartureDate"];
  primaryFlightDataEntry["Arrival Time"] = "";
  primaryFlightDataEntry["Carrier"] =
      getPrimaryFlightCarrierNameFromQuote(quote, responseBody);

  return primaryFlightDataEntry;
}

Map<String, String> getReturnFlightDataFromQuote(
    var quote, dynamic responseBody) {
  Map<String, String> returnFlightDataEntry = Map<String, String>();
  returnFlightDataEntry["Flight Number"] = "";
  returnFlightDataEntry["Departure City"] =
      getReturnDepartureCityFromQuote(quote, responseBody);
  returnFlightDataEntry["Arrival City"] =
      getReturnArrivalCityFromQuote(quote, responseBody);
  returnFlightDataEntry["Departure Airport"] =
      getReturnDepartureAirportFromQuote(quote, responseBody);
  returnFlightDataEntry["Arrival Airport"] =
      getReturnArrivalAirportFromQuote(quote, responseBody);
  returnFlightDataEntry["Departure Time"] =
      quote["InboundLeg"]["DepartureDate"];
  returnFlightDataEntry["Arrival Time"] = "";
  returnFlightDataEntry["Carrier"] =
      getPrimaryFlightCarrierNameFromQuote(quote, responseBody);

  return returnFlightDataEntry;
}

/// returns the departure city of the primary flight of a partucular flight quote
String getPrimaryDepartureCityFromQuote(var quote, dynamic responseBody) {
  var cityId = quote["OutboundLeg"]["OriginId"];
  return getCityNameFromCityId(cityId, responseBody);
}

/// returns the arrival city of the primary flight of a particular flight quote
String getPrimaryArrivalCityFromQuote(var quote, dynamic responseBody) {
  var cityId = quote["OutboundLeg"]["DestinationId"];
  return getCityNameFromCityId(cityId, responseBody);
}

/// returns the departure city of the return flight of a partucular flight quote
String getReturnDepartureCityFromQuote(var quote, dynamic responseBody) {
  var cityId = quote["InboundLeg"]["OriginId"];
  return getCityNameFromCityId(cityId, responseBody);
}

/// returns the arrival city of the return flight of a particular flight quote
String getReturnArrivalCityFromQuote(var quote, dynamic responseBody) {
  var cityId = quote["InboundLeg"]["DestinationId"];
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
String getPrimaryDepartureAirportFromQuote(var quote, dynamic responseBody) {
  var cityId = quote["OutboundLeg"]["OriginId"];
  return getAirportCodeFromCityId(cityId, responseBody);
}

/// returns the arrival airport from a flight quote
String getPrimaryArrivalAirportFromQuote(var quote, dynamic responseBody) {
  var cityId = quote["OutboundLeg"]["DestinationId"];
  return getAirportCodeFromCityId(cityId, responseBody);
}

/// returns the departure airport from a flight quote
String getReturnDepartureAirportFromQuote(var quote, dynamic responseBody) {
  var cityId = quote["InboundLeg"]["OriginId"];
  return getAirportCodeFromCityId(cityId, responseBody);
}

/// returns the arrival airport from a flight quote
String getReturnArrivalAirportFromQuote(var quote, dynamic responseBody) {
  var cityId = quote["InboundLeg"]["DestinationId"];
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

/// returns a name of a carrier of the primary flight from  flight quote.
/// if a flights has multiple carriers, returns a string with
/// all carriers, space separated
String getPrimaryFlightCarrierNameFromQuote(var quote, dynamic responseBody) {
  Set<int> carrierIds = Set<int>.from(quote["OutboundLeg"]["CarrierIds"]);
  String carrierIdsStr = "";

  for (var carrier in responseBody["Carriers"]) {
    if (carrierIds.contains(carrier["CarrierId"])) {
      carrierIdsStr = carrierIdsStr + " " + carrier["CarrierId"].toString();
    }
  }

  return carrierIdsStr;
}


/// returns a name of a carrier of the return flight from flight quote.
/// if a flights has multiple carriers, returns a string with
/// all carriers, space separated
String getPReturnFlightCarrierNameFromQuote(var quote, dynamic responseBody) {
  Set<int> carrierIds = Set<int>.from(quote["InboundLeg"]["CarrierIds"]);
  String carrierIdsStr = "";

  for (var carrier in responseBody["Carriers"]) {
    if (carrierIds.contains(carrier["CarrierId"])) {
      carrierIdsStr = carrierIdsStr + " " + carrier["CarrierId"].toString();
    }
  }

  return carrierIdsStr;
}
