import 'package:http/http.dart' as http;
import 'dart:convert';


class NetworkHelper{
  NetworkHelper(this.url);
  String url;
  dynamic getData() async
  {
    http.Response data= await http.get(url);
    String body=data.body;
    return jsonDecode(body);
  }
}