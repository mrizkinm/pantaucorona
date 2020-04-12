import 'dart:convert';
import 'package:http/http.dart' as http;

class Global {
  String name;
  String value;

  Global({this.name, this.value});

  Global.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }

  static Future<Global> getPositif() async {
    String url = 'https://api.kawalcorona.com/positif/';
    var apiResult = await http.get(url);
    var jsonObject = json.decode(apiResult.body);
    return Global.fromJson(jsonObject);
  }

  static Future<Global> getSembuh() async {
    String url = 'https://api.kawalcorona.com/sembuh/';
    var apiResult = await http.get(url);
    var jsonObject = json.decode(apiResult.body);
    return Global.fromJson(jsonObject);
  }

  static Future<Global> getMeninggal() async {
    String url = 'https://api.kawalcorona.com/meninggal/';
    var apiResult = await http.get(url);
    var jsonObject = json.decode(apiResult.body);
    return Global.fromJson(jsonObject);
  }

}