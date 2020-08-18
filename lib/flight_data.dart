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
  "New-York": ["JFK", "ERW"],
  "Los-Angeles": ["LAX"],
  "Paris": ["CDG"],
  "Rome": ["FCO"]
};

final List<String> dates = ["10/10/20", "1/12/21"];
final List<String> times = ["12:00", "22:00"];

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

List<Flight> randomFlights(int size) {
  List<Flight> flights = [];
  var random = Random();
  var i = 0;
  int fromCityIndex, toCityIndex, fromAirportIndex, toAirportIndex;

  while (i < size) {
    // random pair of cities, departure != arrival
    fromCityIndex = random.nextInt(cities.length);
    toCityIndex = random.nextInt(cities.length);
    while (fromCityIndex == toCityIndex) {
      toCityIndex = random.nextInt(cities.length);
    }

    // random airport in each city
    fromAirportIndex = random.nextInt(airports[cities[fromCityIndex]].length);
    toAirportIndex = random.nextInt(airports[cities[toCityIndex]].length);

    // random departure dateTime;
    DateTime fromRandDateTime = randomDateTime();
    DateTime toRandDateTime =
        fromRandDateTime.add(new Duration(hours: random.nextInt(10) + 1));

    // buildign Flight object and adding to the list
    var flight = Flight(
        cities[fromCityIndex],
        cities[toCityIndex],
        airports[cities[fromCityIndex]][fromAirportIndex],
        airports[cities[toCityIndex]][toAirportIndex],
        fromRandDateTime,
        toRandDateTime);

    flights.add(flight);
    i++;
  }

  return flights;
}
