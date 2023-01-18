class UserModel {
  String username;
  String token;

  UserModel({required this.username, required this.token});

  Future<String> GetToken() async {
    return token;
  }
}
