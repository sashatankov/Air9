import 'package:Air9/flight.dart';
import 'package:Air9/review.dart';
import 'package:flutter/material.dart';

abstract class Account {
  int get accountNumber;
  String get username;
  String get password;
  set username(String username);
  set password(String password);
}

abstract class AccountController {
  Account get account;
  AccountView get view;
}

abstract class AccountView {
  Widget get view;
}

class TravelerAccount implements Account {
  int accountId;
  String firstName;
  String lastName;
  DateTime birthDate;
  String nationality;
  String phoneNumber;
  List<Flight> flights;
  List<Review> reviews;

  @override
  int get accountNumber => this.accountId;

  @override
  String get username => this.firstName + "_" + this.lastName;

  @override
  String get password => this.firstName + "_" + this.lastName;

  @override
  set username(String username) {}

  @override
  set password(String password) {}
}

class TravelerAccountController implements AccountController {
  TravelerAccount model;
  TravelerAccountView accountView;

  TravelerAccountController(TravelerAccount model) {
    this.model = model;
    this.accountView = TravelerAccountView(this);
  }

  @override
  Account get account => this.model;

  @override
  AccountView get view => this.accountView;

  void addFlight(Flight flight) {
    this.model.flights.add(flight);
  }

  void addFlights(Iterable<Flight> flights) {
    this.model.flights.addAll(flights);
  }

  void addReview(Review review) {
    this.model.reviews.add(review);
  }

  void addReviews(Iterable<Review> reviews) {
    this.model.reviews.addAll(reviews);
  }
}

class TravelerAccountView implements AccountView {
  TravelerAccountWidget widget;
  TravelerAccountController controller;

  TravelerAccountView(TravelerAccountController controller) {
    this.widget = TravelerAccountWidget(controller);
    this.controller = controller;
  }

  @override
  Widget get view => this.widget;
}

class TravelerAccountWidget extends StatefulWidget {
  TravelerAccountController controller;
  TravelerAccountWidget(TravelerAccountController controller) {
    this.controller = controller;
  }

  @override
  _TravelerAccountWidgetState createState() => _TravelerAccountWidgetState();
}

class _TravelerAccountWidgetState extends State<TravelerAccountWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          this.profilePicture(),
          this.profileName(),
          this.profilePassportNumber(),
          Divider(),
          this.profileFlightMiles(),
          Divider(),
          this.myFlights(),
          Divider(),
          this.myReviews()
        ],
      ),
    );
  }

  Widget profilePicture() {
    return ListTile(
      title: Icon(
        Icons.account_circle,
        size: 250,
      ),
    );
  }

  Widget profileName() {
    return ListTile(
      title: Center(
        child: Text(
          this.widget.controller.model.username,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
    );
  }

  Widget profilePassportNumber() {
    return ListTile(
      leading: Text(
        "Passport Number",
        style: TextStyle(
          color: Colors.black38,
          fontSize: 16,
        ),
      ),
      title: Text(
        "EF45874",
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  Widget profileFlightMiles() {
    return ListTile(
      leading: Text(
        "Miles",
        style: TextStyle(
          color: Colors.black38,
          fontSize: 16,
        ),
      ),
      title: Text(
        "35788",
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  Widget myFlights() {
    return ListTile();
  }

  Widget myReviews() {
    return ListTile();
  }
}
