import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class IataCodesStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    //final path = await _localPath;
    return File('codes.json');
  }

  Future<String> getCityName(String cityCode) async {
    try {
      final file = await this._localFile;
      String content = await file.readAsString();
      Map<String, dynamic> codes = json.decode(content);
      if (codes.containsKey(cityCode)) {
        return codes[cityCode];
      }

      throw "Illegal City Code";
    } catch (e) {
      throw "Unexpected Error Occured";
    }
  }

  Future<String> getAirportName(String airportCode) async {
    try {
      final file = await this._localFile;
      String content = await file.readAsString();
      Map<String, dynamic> codes = json.decode(content);
      if (codes.containsKey(airportCode)) {
        return codes[airportCode];
      }

      throw "Illegal Airport Code";
    } catch (e) {
      throw "Unexpected Error Occured";
    }
  }

  Future<String> getCountryName(String countryCode) async {
    try {
      final file = await this._localFile;
      String content = await file.readAsString();
      Map<String, dynamic> codes = json.decode(content);
      if (codes.containsKey(countryCode)) {
        return codes[countryCode];
      }

      throw "Illegal Airport Code";
    } catch (e) {
      throw "Unexpected Error Occured";
    }
  }

  Future<File> writeCityName(String cityCode, String cityName) async {
    try {
      Map<String, dynamic> codes;
      var file = await _localFile;
      if (await file.exists() == false) {
        file = await file.create(recursive: true);
      }
      String content = await file.readAsString();
      if (content.isNotEmpty) {
        codes = json.decode(content);
      } else {
        codes = Map<String, dynamic>();
      }
      codes[cityCode] = cityName;
      content = json.encode(codes);

      return file.writeAsString(content);
    } catch (e) {
      throw "Unexpected Error occured";
    }
  }

  Future<File> writeAirportName(String airportCode, String airportName) async {
    try {
      Map<String, dynamic> codes;
      var file = await _localFile;
      if (await file.exists() == false) {
        file = await file.create(recursive: true);
      }
      String content = await file.readAsString();
      if (content.isNotEmpty) {
        codes = json.decode(content);
      } else {
        codes = Map<String, dynamic>();
      }
      codes[airportCode] = airportName;
      content = json.encode(codes);

      return file.writeAsString(content);
    } catch (e) {
      throw "Unexpected Error occured";
    }
  }

  Future<File> writeCountryName(String countryCode, String countryName) async {
    try {
      Map<String, dynamic> codes;
      var file = await _localFile;
      if (await file.exists() == false) {
        file = await file.create(recursive: true);
      }
      String content = await file.readAsString();
      if (content.isNotEmpty) {
        codes = json.decode(content);
      } else {
        codes = Map<String, dynamic>();
      }
      codes[countryCode] = countryName;
      content = json.encode(codes);

      return file.writeAsString(content);
    } catch (e) {
      throw "Unexpected Error occured";
    }
  }
}
