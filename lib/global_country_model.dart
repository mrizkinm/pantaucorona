import 'dart:convert';
import 'package:http/http.dart' as http;

class GlobalCountry {
  Attributes attributes;

  GlobalCountry({this.attributes});

  GlobalCountry.fromJson(Map<String, dynamic> json) {
    attributes = json['attributes'] != null
        ? new Attributes.fromJson(json['attributes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.attributes != null) {
      data['attributes'] = this.attributes.toJson();
    }
    return data;
  }

  static Future<List<GlobalCountry>> getData() async {
    String url =  'https://api.kawalcorona.com/';
    var apiResult = await http.get(url);
    List responseJson = json.decode(apiResult.body);
    return responseJson.map((m) => new GlobalCountry.fromJson(m)).toList();
  }
}

class Attributes {
  int oBJECTID;
  String countryRegion;
  int lastUpdate;
  var lat;
  var long;
  int confirmed;
  int deaths;
  int recovered;
  int active;

  Attributes(
      {this.oBJECTID,
      this.countryRegion,
      this.lastUpdate,
      this.lat,
      this.long,
      this.confirmed,
      this.deaths,
      this.recovered,
      this.active});

  Attributes.fromJson(Map<String, dynamic> json) {
    oBJECTID = json['OBJECTID'];
    countryRegion = json['Country_Region'];
    lastUpdate = json['Last_Update'];
    lat = json['Lat'];
    long = json['Long_'];
    confirmed = json['Confirmed'];
    deaths = json['Deaths'];
    recovered = json['Recovered'];
    active = json['Active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OBJECTID'] = this.oBJECTID;
    data['Country_Region'] = this.countryRegion;
    data['Last_Update'] = this.lastUpdate;
    data['Lat'] = this.lat;
    data['Long_'] = this.long;
    data['Confirmed'] = this.confirmed;
    data['Deaths'] = this.deaths;
    data['Recovered'] = this.recovered;
    data['Active'] = this.active;
    return data;
  }
}