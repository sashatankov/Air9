import 'package:Air9/flight_widget.dart';
import 'package:flutter/material.dart';
import 'package:Air9/flight_data.dart';

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

class FlightController {
  Flight model;
  FlightView view;

  FlightController(this.model, this.view);

  String get detartureDate {
    var day = this.model.departureAt.day;
    var month = this.model.departureAt.month;
    var year = this.model.departureAt.year;
    return "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year";
  }

  String get departureTime {
    var hour = this.model.departureAt.hour;
    var minute = this.model.departureAt.minute;
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }

  String get arrivalDate {
    var day = this.model.arrivalAt.day;
    var month = this.model.arrivalAt.month;
    var year = this.model.arrivalAt.year;
    return "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year";
  }

  String get arrivalTime {
    var hour = this.model.arrivalAt.hour;
    var minute = this.model.arrivalAt.minute;
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }
}

class FlightView {
  FlightWidget widget;

  FlightView(Flight flight) {
    this.widget = FlightWidget(flight);
  }

  Widget getView() {
    return this.widget;
  }
}

class FlightsController {
  List<Flight> model;
  FlightsView view;
}

class FlightsView {
  List<Flight> flights;
  FlightsView(this.flights) {}

  Widget getView() {
    flights.sort((a, b) => a.departureAt.difference(b.departureAt).inMinutes);
    var flightsView = flights.map((e) => FlightView(e)).toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Text(
            "Upcoming Flights",
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: flights.length,
            itemBuilder: (context, index) {
              return Card(
                child: flightsView[index].getView(),
                margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Card(
                child: flightsView[index].getView(),
                margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.blue[100],
              );
            },
          ),
        )
      ],
    );
  }
}
