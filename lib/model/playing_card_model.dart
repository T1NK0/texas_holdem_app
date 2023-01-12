import 'dart:core';

class PlayingCard {
  late String suit;
  late String rank;

  PlayingCard({this.suit = "default", this.rank = "default"});

  PlayingCard.fromMap(Map<String, dynamic> map)
      : suit = map["suit"],
        rank = map["rank"];
}
