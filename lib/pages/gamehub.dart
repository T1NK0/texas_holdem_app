import 'package:flutter/material.dart';
import 'package:image_card/image_card.dart';
import 'package:texas_holdem_app/pages/texas_holdem_game.dart';

class GamehubPage extends StatelessWidget {
  const GamehubPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Poker Hub'),
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => TexasHoldemGamePage(),
                    ),
                  );
                },
                child: const TransparentImageCard(
                  width: 200,
                  imageProvider:
                      AssetImage('assets/images/SL_120319_25700_24.jpg'),
                  title: Text('Texas Holdem',
                      style: TextStyle(color: Colors.white)),
                  description: Text('Players: 0/9',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => TexasHoldemGamePage(),
                    ),
                  );
                },
                child: const Card(
                  child: TransparentImageCard(
                    width: 200,
                    imageProvider: AssetImage('assets/images/.jpg'),
                    title: Text('Seven Card Stub',
                        style: TextStyle(color: Colors.white)),
                    description: Text('Players: 0/9',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        )),
      );
}
