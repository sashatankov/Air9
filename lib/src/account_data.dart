import 'dart:math';

import 'package:Air9/src/account.dart';

List<String> firstNames = ["John", "Bill", "Claire", "Rachel", "Ahmed", "Rey"];
List<String> lastNames = ["Brown", "Anderson", "Ryad", "Crow", "Malinkoff"];
List<String> nationalities = ["USA", "UK", "Japan", "Brazil", "Russia"];
List<String> phoneNumbers = ["94849848", "92837033", "2397686", "75478975"];

DateTime randomBirthDate() {
  var random = Random();
  int year = 2010 - random.nextInt(40);
  int month = random.nextInt(10) + 3;
  int day = random.nextInt(28) + 1;

  return DateTime(year, month, day);
}

TravelerAccount randomTravelerAccount() {
  var random = Random();

  String randomFirstName = firstNames[random.nextInt(firstNames.length)];
  String randomLastName = lastNames[random.nextInt(lastNames.length)];
  DateTime randomBirthday = randomBirthDate();
  String randomNationality =
      nationalities[random.nextInt(nationalities.length)];
  String randomPhoneNumber = phoneNumbers[random.nextInt(phoneNumbers.length)];

  return TravelerAccount(randomFirstName, randomLastName, 
  randomBirthday, randomNationality, randomPhoneNumber);

  
}
