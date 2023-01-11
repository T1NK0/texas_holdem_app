import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PlayingCardWidget extends StatelessWidget {
  const PlayingCardWidget({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) => Container(
        width: 75,
        height: 115,
        child: Image.asset('assets/images/playingcards/$path.png'),
      );
}
