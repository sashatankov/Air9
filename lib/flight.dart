
class Flight {
  String departureCity;
  String arrivalCity;
  String departureAirport;
  String arrivalAirport;
  String departureTime;
  String arrivalTime;
  String departureDate;
  String arrivalDate;
  List<Flight> connections;

  Flight(
      this.departureCity,
      this.arrivalCity,
      this.departureAirport,
      this.arrivalAirport,
      this.departureTime,
      this.arrivalTime,
      this.departureDate,
      this.arrivalDate,
      {this.connections = const <Flight>[]});
}