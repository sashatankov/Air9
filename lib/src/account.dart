import 'package:Air9/src/flight.dart';
import 'package:Air9/src/review.dart';
import 'package:flutter/material.dart';

/// a class representing an abstract account of the user of the app
abstract class Account {
  /// returns the account number
  int get accountNumber;

  ///return the username of the account
  String get username;

  // TODO to add a profile picture;
}

/// a class representing an abstract view of [Account]
abstract class AccountView {
  /// return the visual representation of the account to the screen
  Widget render();
}

/// a class representing an abstract controller of [Account]
abstract class AccountController {
  /// updates the view of the account
  void updateView();

  /// returns the model of the controller
  Account get model;

  /// returns the view of the controller
  AccountView get view;
}

/// a class representing an account of a traveler that looks for flights
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

  /// a constructor of the class
  TravelerAccount(this.firstName, this.lastName, this.birthDate,
      this.nationality, this.phoneNumber,
      {this.flights = const <Flight>[], this.reviews = const <Review>[]});

  @override
  int get accountNumber => this.accountId;

  @override
  String get username => "${this.firstName} ${this.lastName}";
}

/// a controller class for the [TravelerAccount] model
class TravelerAccountController implements AccountController {
  TravelerAccount travelerAccountModel;
  TravelerAccountView accountView;

  /// a constructor of the class
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

  /// adds a flight to the flight list of the account
  void addFlight(Flight flight) {
    this.travelerAccountModel.flights.add(flight);
  }

  /// adds flights to the flight list of the account
  void addFlights(Iterable<Flight> flights) {
    this.travelerAccountModel.flights.addAll(flights);
  }

  /// adds a review to the review list of the account
  void addReview(Review review) {
    this.travelerAccountModel.reviews.add(review);
  }

  /// adds reviews to the review-list of the account
  void addReviews(Iterable<Review> reviews) {
    this.travelerAccountModel.reviews.addAll(reviews);
  }
}

/// a view class for the [TravelerAccount] model
class TravelerAccountView implements AccountView {
  TravelerAccountWidget widget;
  TravelerAccount model;

  /// a constructor for the class
  TravelerAccountView(TravelerAccount model) {
    this.widget = TravelerAccountWidget(model);
    this.model = model;
  }

  @override
  Widget render() {
    return this.widget;
  }
}

/// a widget class containing the visual representation of [TravelerAccount]
class TravelerAccountWidget extends StatefulWidget {
  final TravelerAccount model;
  TravelerAccountWidget(this.model);

  @override
  _TravelerAccountWidgetState createState() => _TravelerAccountWidgetState();
}

/// a state class for [TravelerAccountWidget]
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

  /// returns the profile picture of the account
  Widget profilePicture() {
    return ListTile(
      title: Icon(
        Icons.account_circle,
        size: 250,
      ),
    );
  }

  /// returns the username of the account
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

  /// returns the 'my flights' button that takes
  /// the user to the 'my flights' screen
  Widget myFlights() {
    return ListTile(title: Text("My Flights"));
  }

  /// returns the 'my reviews' button that takes
  /// the user to the 'my reviews' screen
  Widget myReviews() {
    return ListTile(title: Text("My Reviews"));
  }
}
