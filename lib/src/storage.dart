import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class IataCodesStorage {
  Map<String, dynamic> cache;

  IataCodesStorage() {
    this.cache = Map<String, dynamic>();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    //final path = await _localPath;
    return File('codes.json');
  }

  Future<Map<String, dynamic>> loadCacheFromDisk() async {
    try {
      Map<String, dynamic> codes;
      var file = await this._localFile;
      if (await file.exists() == false) {
        file = await file.create(recursive: true);
      }
      String content = await file.readAsString();
      if (content.isNotEmpty) {
        codes = json.decode(content);
      } else {
        codes = Map<String, dynamic>();
      }

      return codes;
    } catch (e) {
      throw "Unexpected Error Occured";
    }
  }

  Future<String> getCityName(String cityCode) async {
    if (this.cache.isEmpty) {
      var cacheFromDisk = await loadCacheFromDisk();
      this.cache.addAll(cacheFromDisk);
    }
    if (this.cache.containsKey(cityCode)) {
      return this.cache[cityCode];
    }

    throw "Illegal City Code";
  }

  Future<String> getAirportName(String airportCode) async {
    if (this.cache.isEmpty) {
      var cacheFromDisk = await loadCacheFromDisk();
      this.cache.addAll(cacheFromDisk);
    }
    if (this.cache.containsKey(airportCode)) {
      return this.cache[airportCode];
    }

    throw "Illegal City Code";
  }

  Future<String> getCountryName(String countryCode) async {
    if (this.cache.isEmpty) {
      var cacheFromDisk = await loadCacheFromDisk();
      this.cache.addAll(cacheFromDisk);
    }
    if (this.cache.containsKey(countryCode)) {
      return this.cache[countryCode];
    }

    throw "Illegal City Code";
  }

  void writeCityName(String cityCode, String cityName) async {
    if (this.cache.isEmpty) {
      var cacheFromDisk = await loadCacheFromDisk();
      this.cache.addAll(cacheFromDisk);
    }
    this.cache[cityCode] = cityName;
  }

  void writeAirportName(String airportCode, String airportName) async {
    if (this.cache.isEmpty) {
      var cacheFromDisk = await loadCacheFromDisk();
      this.cache.addAll(cacheFromDisk);
    }
    this.cache[airportCode] = airportName;
  }

  void writeCountryName(String countryCode, String countryName) async {
    if (this.cache.isEmpty) {
      var cacheFromDisk = await loadCacheFromDisk();
      this.cache.addAll(cacheFromDisk);
    }
    this.cache[countryCode] = countryName;
  }

  void dispose() async {
    var file = await _localFile;
    var content = json.encode(this.cache);
    await file.writeAsString(content);
  }
}
