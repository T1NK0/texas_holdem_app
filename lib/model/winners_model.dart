class WinnerModel {
  final String username;

  WinnerModel({required this.username});

  WinnerModel.fromMap(Map<dynamic, dynamic> map) : username = map["username"];
}
