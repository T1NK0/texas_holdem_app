import 'dart:core';

class PlayingCard {
  late final String suit;
  late final String value;

  PlayingCard({this.suit = "default", this.value = "default"});

  PlayingCard.fromMap(Map<String, dynamic> map)
      : suit = map["suit"],
        value = map["value"];
}
