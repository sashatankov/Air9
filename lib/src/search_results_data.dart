import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Air9/src/search_results_screen.dart' show FlightSearchResults;
import 'package:Air9/src/flight_search.dart' show FlightSearchQuery;

const String skyScannerStr = "Sky Scanner";
const String tripAdvisorStr = "TripAdvisor";
const String rapidStr = "rapid";
const String amadeusStr = "Amadeus";
const String amadeusClient = "Amadeus Client";
const String amadeusSecret = "Amadeus Secret";

// a list of api host to retreive data from
const Map<String, String> apiHosts = {
  "Sky Scanner": "skyscanner-skyscanner-flight-search-v1.p.rapidapi.com",
  "TripAdvisor": "tripadvisor1.p.rapidapi.com",
  "Amadeus": "test.api.amadeus.com"
};

// a list of keys to access the apis
const Map<String, String> apiKeys = {
  "rapid": "af68c74026mshacfcc9302076c22p1787cfjsn6a661cfe6bbb",
  "Amadeus Client": "iSuJip6SkOEetpUEfxYnNtNfDlk2C1Ec",
  "Amadeus Secret": "5H3xVANAAdOAab2k"
};

/// returns the authorization key for the amadeus api
Future<String> getAuthorizationKey() async {
  String url = "https://${apiHosts[amadeusStr]}/v1/security/oauth2/token";
  http.Response response = await http.post(url, headers: {
    "Content-Type": "application/x-www-form-urlencoded"
  }, body: {
    "grant_type": "client_credentials",
    "client_id": apiKeys[amadeusClient],
    "client_secret": apiKeys[amadeusSecret]
  });

  dynamic body = response.body;
  dynamic bodyJson = json.decode(body);
  return bodyJson["access_token"];
}

/// the function fetches flights according to the [FlightSearchQuery]
/// from the skyscanner api. return a [FlightSearchResults] object
/// containing all the flight data
Future<FlightSearchResults> fetchFlights(FlightSearchQuery query) async {
  List<String> originAirportCodes = await getAirportCodes(query.from);
  List<String> destinationAirportCodes = await getAirportCodes(query.to);
  String departureDate = formattedDate(query.departureDate);
  String returnDate = "";
  if (!query.isOneWay) {
    returnDate = formattedDate(query.arrivalDate);
  }

  List<String> urls = List<String>();
  for (String originCode in originAirportCodes) {
    for (String destinationCode in destinationAirportCodes) {
      urls.add(getFlightOffersURL(originCode, destinationCode, departureDate,
          returnDate: returnDate));
    }
  }
  List<dynamic> data = List<dynamic>();
  List<dynamic> flightEntries;
  String authorizationKey = await getAuthorizationKey();
  for (String url in urls) {
    final dynamic response = await http
        .get(url, headers: {"Authorization": "Bearer $authorizationKey"});
    flightEntries = jsonFromResponse(response);
    data.addAll(flightEntries);
  }

  return FlightSearchResults.fromJSON(data);
}

/// return a string representation of a date
String formattedDate(DateTime date) {
  return "${date.year.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}

/// returns a url to make the request from, according to the
/// city/coutry origin, city/country destination and departure date
/// the airport codes are according to IATA standard. e.g PARI, NYCA, etc.
String getFlightOffersURL(
    String originCode, String destinationCode, String departureDate,
    {String returnDate = "",
    String currencyCode = "USD",
    int adultPassengers = 1,
    bool nonStop = false}) {
  if (returnDate == "") {
    return "https://${apiHosts[amadeusStr]}/v2/shopping/flight-offers?originLocationCode=$originCode&destinationLocationCode=$destinationCode&departureDate=$departureDate&adults=$adultPassengers&currencyCode=$currencyCode&max=25&nonStop=$nonStop";
  }
  return "https://${apiHosts[amadeusStr]}/v2/shopping/flight-offers?originLocationCode=$originCode&destinationLocationCode=$destinationCode&departureDate=$departureDate&adults=$adultPassengers&returnDate=$returnDate&currencyCode=$currencyCode&max=25&nonStop=$nonStop";
}

/// returns the url to make a request from, in order to get
/// the airport code from a name of city
String getAirportsURL(String placeName,
    {String userLocationCountry = "US",
    String resultsCurrency = "USD",
    String resultsLanguage = "en-US"}) {
  return "https://${apiHosts[tripAdvisorStr]}/airports/search/?locale=$resultsLanguage&query=$placeName";
}

/// makes an api request to retreive the airport codes according
/// to the name of the city
Future<List<String>> getAirportCodes(String placeName) async {
  List<String> codes = List<String>();
  List<dynamic> airports;
  var url = getAirportsURL(placeName);
  final response = await http.get(url, headers: {
    "x-rapidapi-host": apiHosts[tripAdvisorStr],
    "x-rapidapi-key": apiKeys[rapidStr],
  });
  if (response.statusCode == 200) {
    final List<dynamic> responseBody = json.decode(response.body);

    // in some requests the first entry is data about the city itselt
    // if so, remove it from the response body.
    Map<String, dynamic> firstElement = responseBody[0];
    if (firstElement.containsKey("display_sub_title")) {
      if (firstElement["display_sub_title"].startsWith("All")) {
        airports = responseBody.sublist(1);
      } else {
        airports = responseBody;
      }
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

/// returns data from response as json
List<Map<String, dynamic>> jsonFromResponse(dynamic response) {
  final dynamic responseBody = json.decode(response.body);
  List<Map<String, dynamic>> flightDataEntries = List<Map<String, dynamic>>();

  Map<String, dynamic> flightDataEntry;
  if (responseBody != null && responseBody["data"] != null) {
    for (var quote in responseBody["data"]) {
      flightDataEntry = getFlightDataEntryFromQuote(quote, responseBody);
      flightDataEntries.add(flightDataEntry);
    }
  }

  return flightDataEntries;
}

/// returns a dictionary containing data ablot a flight.
/// a dictionary is built from json api response and a flight quote
/// in the response.
Map<String, dynamic> getFlightDataEntryFromQuote(
    var quote, dynamic responseBody) {
  Map<String, dynamic> flightDataEntry = Map<String, dynamic>();
  flightDataEntry["Price"] = quote["price"]["total"];
  flightDataEntry["Currency"] = quote["price"]["currency"];
  flightDataEntry["One Way"] = true;
  flightDataEntry["Origin"] =
      getFlightsDataFromItinerary(quote["itineraries"][0], responseBody);

  if (quote["itineraries"].length == 2) {
    flightDataEntry["Return"] =
        getFlightsDataFromItinerary(quote["itineraries"][1], responseBody);
    flightDataEntry["One Way"] = false;
  } else {
    flightDataEntry["Return"] = null;
  }

  return flightDataEntry;
}

/// return a list of all flights from one itinerary
/// the flights are connection flights of one big flight itinerary
List<Map<String, String>> getFlightsDataFromItinerary(
    dynamic itinerary, dynamic responseBody) {
  List<Map<String, String>> flightsData = List<Map<String, String>>();
  for (var flight in itinerary["segments"]) {
    flightsData.add(getPrimaryFlightDataFromItinerary(flight, responseBody));
  }

  return flightsData;
}

/// retrieves and returns data about one flight in the itinerary 
Map<String, String> getPrimaryFlightDataFromItinerary(
    dynamic itinerary, dynamic responseBody) {
  Map<String, String> flightDataEntry = Map<String, String>();
  flightDataEntry["Flight Number"] =
      itinerary["carrierCode"] + itinerary["number"];
  flightDataEntry["Departure City"] =
      getDepartureCityFromQuote(itinerary, responseBody);
  flightDataEntry["Arrival City"] =
      getArrivalCityFromQuote(itinerary, responseBody);
  flightDataEntry["Departure Airport"] = itinerary["departure"]["iataCode"];
  flightDataEntry["Arrival Airport"] = itinerary["arrival"]["iataCode"];
  flightDataEntry["Departure Time"] = itinerary["departure"]["at"];
  flightDataEntry["Arrival Time"] = itinerary["arrival"]["at"];
  flightDataEntry["Carrier"] =
      getFlightCarrierNameFromItinerary(itinerary, responseBody);

  return flightDataEntry;
}

/// returns the departure city of the primary flight of a partucular flight quote
String getDepartureCityFromQuote(dynamic itinerary, dynamic responseBody) {
  var cityId = itinerary["departure"]["iataCode"];
  return responseBody["dictionaries"]["locations"][cityId]["cityCode"];
}

/// returns the arrival city of the primary flight of a particular flight quote
String getArrivalCityFromQuote(dynamic itinerary, dynamic responseBody) {
  var cityId = itinerary["arrival"]["iataCode"];
  return responseBody["dictionaries"]["locations"][cityId]["cityCode"];
}

/// returns the departure airport from a flight quote
String getDepartureAirportFromQuote(dynamic itinerary) {
  return itinerary["departure"]["iataCode"];
}

/// returns the arrival airport from a flight quote
String getArrivalAirportFromQuote(dynamic itinarary) {
  return itinarary["arrival"]["iataCode"];
}

/// returns a name of a carrier of the primary flight from  flight quote.
/// if a flights has multiple carriers, returns a string with
/// all carriers, space separated
String getFlightCarrierNameFromItinerary(
    dynamic itinerary, dynamic responseBody) {
  return responseBody["dictionaries"]["carriers"][itinerary["carrierCode"]];
}
