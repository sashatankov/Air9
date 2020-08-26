import 'package:Air9/src/flight.dart';
import 'package:Air9/src/review.dart';
import 'package:flutter/material.dart';

abstract class Account {
  int get accountNumber;
  String get username;
  // TODO to add a profile picture;
}

abstract class AccountView {
  Widget render();
}

abstract class AccountController {
  void updateView();
  Account get model;
  AccountView get view;
}

class TravelerAccount implements Account {
  int accountId;
  String firstName;
  String lastName;
  DateTime birthDate;
  String nationality;
  String phoneNumber;
  String email;
  List<Flight> flights;
  List<Review> reviews;

  TravelerAccount(this.firstName, this.lastName, this.birthDate,
      this.nationality, this.phoneNumber,
      {this.flights = const <Flight>[], this.reviews = const <Review>[]});

  @override
  int get accountNumber => this.accountId;

  @override
  String get username => "${this.firstName} ${this.lastName}";
}

class TravelerAccountController implements AccountController {
  TravelerAccount travelerAccountModel;
  TravelerAccountView accountView;

  TravelerAccountController(this.travelerAccountModel) {
    this.accountView = TravelerAccountView(this.travelerAccountModel);
  }

  @override
  void updateView() {
    this.accountView = TravelerAccountView(this.travelerAccountModel);
  }

  @override
  Account get model => this.travelerAccountModel;

  @override
  AccountView get view => this.accountView;

  void addFlight(Flight flight) {
    this.travelerAccountModel.flights.add(flight);
  }

  void addFlights(Iterable<Flight> flights) {
    this.travelerAccountModel.flights.addAll(flights);
  }

  void addReview(Review review) {
    this.travelerAccountModel.reviews.add(review);
  }

  void addReviews(Iterable<Review> reviews) {
    this.travelerAccountModel.reviews.addAll(reviews);
  }
}

class TravelerAccountView implements AccountView {
  TravelerAccountWidget widget;
  TravelerAccount model;

  TravelerAccountView(TravelerAccount model) {
    this.widget = TravelerAccountWidget(model);
    this.model = model;
  }

  @override
  Widget render() {
    return this.widget;
  }
}

class TravelerAccountWidget extends StatefulWidget {
  final TravelerAccount model;
  TravelerAccountWidget(this.model);

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
          this.widget.model.username,
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
    return ListTile(title: Text("My Flights"));
  }

  Widget myReviews() {
    return ListTile(title: Text("My Reviews"));
  }
}
