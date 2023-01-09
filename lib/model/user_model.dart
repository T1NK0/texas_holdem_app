import 'dart:ffi';

class UserModel {
  String username;
  String token;
  Double currency;

  UserModel(
      {required this.username, required this.token, required this.currency});

  Future<String> GetToken() async {
    return token;
  }
}
