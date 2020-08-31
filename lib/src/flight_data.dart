import 'flight.dart';
import 'dart:math';

final List<String> cities = [
  "Tel-Aviv",
  "New-York",
  "Los-Angeles",
  "Paris",
  "Rome"
];
final Map<String, List<String>> airports = {
  "Tel-Aviv": ["TLV"],
  "New-York": ["JFK", "EWR"],
  "Los-Angeles": ["LAX"],
  "Paris": ["CDG"],
  "Rome": ["FCO"]
};

final List<String> airlines = [
  "Delta Airlines",
  "Lufthansa",
  "Turkish Airlines",
  "KLM",
  "American Airlines"
];

final Map<String, List<String>> flightNumbers = {
  "Delta Airlines": ["DL7482", "DL6577"],
  "Lufthansa": ["LF1933", "LF221"],
  "Turkish Airlines": ["TA4552", "TA120"],
  "KLM": ["KL338", "KL2243"],
  "American Airlines": ["AA3009", "AA1173"]
};

/// returns a random date between 1/1/2020 to 31/12/2030
DateTime randomDateTime() {
  var random = Random();
  int year = random.nextInt(10) + 2020;
  int month = random.nextInt(10) + 3;
  int day = random.nextInt(28) + 1;
  int hour = random.nextInt(24);
  int minute = random.nextInt(60);
  minute = minute - (minute % 10);

  return DateTime(year, month, day, hour, minute);
}

/// return a list of randomly generated flights of a given size
List<Flight> randomFlights(int size) {
  List<Flight> flights = [];
  var random = Random();
  var i = 0;
  int flightNumberIndex,
      fromCityIndex,
      toCityIndex,
      fromAirportIndex,
      toAirportIndex,
      airlineIndex;

  while (i < size) {
    // random tuple of flightNumber, cities, departure != arrival, airline
    airlineIndex = random.nextInt(airlines.length);
    fromCityIndex = random.nextInt(cities.length);
    toCityIndex = random.nextInt(cities.length);
    while (fromCityIndex == toCityIndex) {
      toCityIndex = random.nextInt(cities.length);
    }
    flightNumberIndex = random.nextInt(flightNumbers[airlines[airlineIndex]].length);

    // random airport in each city
    fromAirportIndex = random.nextInt(airports[cities[fromCityIndex]].length);
    toAirportIndex = random.nextInt(airports[cities[toCityIndex]].length);

    // random departure dateTime;
    DateTime fromRandDateTime = randomDateTime();
    DateTime toRandDateTime =
        fromRandDateTime.add(new Duration(hours: random.nextInt(10) + 1));

    // building Flight object and adding to the list
    var flight = Flight(
        flightNumbers[airlines[airlineIndex]][flightNumberIndex],
        cities[fromCityIndex],
        cities[toCityIndex],
        airports[cities[fromCityIndex]][fromAirportIndex],
        airports[cities[toCityIndex]][toAirportIndex],
        fromRandDateTime,
        toRandDateTime,
        airlines[airlineIndex]);

    flights.add(flight);
    i++;
  }

  return flights;
}
