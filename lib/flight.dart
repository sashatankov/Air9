class Flight {
  String departureCity;
  String arrivalCity;
  String departureAirport;
  String arrivalAirport;
  DateTime departureAt;
  DateTime arrivalAt;
  List<Flight> connections;

  Flight(this.departureCity, this.arrivalCity, this.departureAirport,
      this.arrivalAirport, this.departureAt, this.arrivalAt,
      {this.connections = const <Flight>[]});

  String get detartureDate =>
      "${this.departureAt.day.toString().padLeft(2, '0')}/${this.departureAt.month.toString().padLeft(2, '0')}/${this.departureAt.year}";

  String get departureTime =>
      "${this.departureAt.hour.toString().padLeft(2, '0')}:${this.departureAt.minute.toString().padLeft(2, '0')}";

  String get arrivalDate =>
      "${this.arrivalAt.day.toString().padLeft(2, '0')}/${this.arrivalAt.month.toString().padLeft(2, '0')}/${this.arrivalAt.year}";

  String get arrivalTime => 
      "${this.arrivalAt.hour.toString().padLeft(2, '0')}:${this.arrivalAt.minute.toString().padLeft(2, '0')}";
  

}
