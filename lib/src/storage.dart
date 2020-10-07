import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class IataCodesStorage {
  Map<String, dynamic> cache;

  IataCodesStorage() {
    cache = Map<String, dynamic>();
  }

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

  void writeCityName(String cityCode, String cityName) async {
    try {
      Map<String, dynamic> codes;
      var file = await _localFile;
      if (await file.exists() == false) {
        file = await file.create(recursive: true);
      }
      String content = await file.readAsString();
      if (content.isNotEmpty) {
        codes = json.decode(content);
        this.cache.addAll(codes);
      }
      this.cache[cityCode] = cityName;

    } catch (e) {
      throw "Unexpected Error occured";
    }
  }

  void writeAirportName(String airportCode, String airportName) async {
    try {
      Map<String, dynamic> codes;
      var file = await _localFile;
      if (await file.exists() == false) {
        file = await file.create(recursive: true);
      }
      String content = await file.readAsString();
      if (content.isNotEmpty) {
        codes = json.decode(content);
        this.cache.addAll(codes);
      }
      this.cache[airportCode] = airportName;

    } catch (e) {
      throw "Unexpected Error occured";
    }
  }

  void writeCountryName(String countryCode, String countryName) async {
    try {
      Map<String, dynamic> codes;
      var file = await _localFile;
      if (await file.exists() == false) {
        file = await file.create(recursive: true);
      }
      String content = await file.readAsString();
      if (content.isNotEmpty) {
        codes = json.decode(content);
        this.cache.addAll(codes);
      }
      this.cache[countryCode] = countryName;

    } catch (e) {
      throw "Unexpected Error occured";
    }
  }

  void dispose() async {
    var file = await _localFile;
    var content = json.encode(this.cache);
    await file.writeAsString(content);
  }
}
