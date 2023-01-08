import 'package:texas_holdem_app/globals.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpClientService {
  final String _baseUrl = 'http://10.0.2.2:5000/';

  Future<String> getLoginToken() async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('GET', Uri.parse('${_baseUrl}api/Login/guesttoken'));
    request.headers.addAll(headers);
    var response2 = await request.send();
    if (response2.statusCode == 200) {
      return await response2.stream.bytesToString();
    } else {
      print(response2.reasonPhrase);
      return "Getting bad request";
    }
  }

  Future<bool> login(String userName, String loginToken) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': loginToken
    };
    var request =
        http.Request('POST', Uri.parse('${_baseUrl}api/login/usertoken'));
    request.headers.addAll(headers);
    request.body = json.encode({"username": userName});
    var response2 = await request.send();
    if (response2.statusCode == 200) {
      var result = await response2.stream.bytesToString();
      var token = result;
      currentUser.username = userName;
      currentUser.token = token;
      print(currentUser.token);
      return true;
    } else {
      print(response2.reasonPhrase);
      return false;
    }
  }

  Future<String> playerToken() async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': currentUser.token
    };
    var request =
        http.Request('POST', Uri.parse('${_baseUrl}api/Login/playtoken'));
    request.headers.addAll(headers);
    var response2 = await request.send();
    if (response2.statusCode == 200) {
      var result = await response2.stream.bytesToString();
      var token = 'Bearer ' + result;
      return token;
    } else {
      print(response2.reasonPhrase);
      return "";
    }
  }
}
