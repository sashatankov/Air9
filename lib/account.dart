import 'package:Air9/flight.dart';
import 'package:Air9/review.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

abstract class Account {
  int getAccountNumber();
  String getUsername();
  String getPassword();
  void setUsername(String username);
  void setPassword(String password);
}

abstract class AccountController {
  Account getAccount();
  AccountView getView();
}

abstract class AccountView {
  Widget getView();
}

class TravelerAccount implements Account {
  int accountNumber;
  String firstName;
  String lastName;
  DateTime birthDate;
  String nationality;
  String phoneNumber;
  List<Flight> flights;
  List<Review> reviews;

  @override
  int getAccountNumber() {
    return this.accountNumber;
  }

  @override
  String getUsername() {
    return this.firstName + "_" + this.lastName;
  }

  @override
  String getPassword() {
    return this.firstName + "_" + this.lastName;
  }

  @override
  void setUsername(String username) {}

  @override
  void setPassword(String password) {}
}

class TravelerAccountController implements AccountController {
  Account model;
  AccountView view;

  TravelerAccountController(this.model, this.view);

  @override
  Account getAccount() {
    return this.model;
  }

  @override
  AccountView getView() {
    return this.view;
  }
}

class TravelerAccountView implements AccountView {
  @override
  Widget getView() {
    return UserProfileWidget();
  }
}

class UserProfileWidget extends StatefulWidget {
  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          this.profilePicture(),
          this.profileName(),
          this.profilePassportNumber(),
          Divider(),
          this.profileFlightMiles()
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
          "John Doe",
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
}
