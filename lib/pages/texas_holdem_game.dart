import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:texas_holdem_app/globals.dart';
import 'package:texas_holdem_app/services/http_service.dart';

import 'package:logger/logger.dart';
import 'package:signalr_netcore/signalr_client.dart';

import 'package:texas_holdem_app/model/playing_card_model.dart';
import 'package:texas_holdem_app/widgets/playing_card_widget.dart';

class TexasHoldemGamePage extends StatefulWidget {
  @override
  _TexasHoldemRoomState createState() => _TexasHoldemRoomState();
}

class _TexasHoldemRoomState extends State<TexasHoldemGamePage> {
  //Properties
  String _playerConnectionStatus = "Disconnected";
  String _message = "Message to receive";
  String _signalRClientId = "";

  late bool _isReady;

  //Player hand
  PlayingCard _firstPlayerCard = PlayingCard();
  PlayingCard _secondPlayerCard = PlayingCard();

  //Community cards
  PlayingCard _firstCommunityCard = PlayingCard();
  PlayingCard _secondCommunityCard = PlayingCard();
  PlayingCard _thirdCommunityCard = PlayingCard();

  late HubConnection _hubConnection;
  HttpClientService clientService = HttpClientService();
  Logger logger = Logger(
    printer: PrettyPrinter(),
  );

  @override
  void initState() {
    super.initState();
    _connectToHub();
    _isReady = false;
  }

  // What to do when player disconnects from the room.
  @override
  void dispose() async {
    super.dispose();
    await _hubConnection.invoke("PlayerDisconnected",
        args: [currentUser.username, _signalRClientId]);
    _hubConnection.stop();
  }

  void _connectToHub() async {
    _hubConnection = HubConnectionBuilder()
        .withUrl(
          "http://10.0.2.2:5000/texas",
          options: HttpConnectionOptions(
            accessTokenFactory: () async => await currentUser.GetToken(),
          ),
        )
        .build();

    _hubConnection.on("SendMessage", (arguments) {
      setState(() {});
    });

    _hubConnection.on("GetPlayerCards", (arguments) {
      setState(() {
        try {
          var obj = arguments![0];
          _firstPlayerCard = PlayingCard.fromMap(obj as Map<String, dynamic>);

          var obj2 = arguments[1];
          _secondPlayerCard = PlayingCard.fromMap(obj2 as Map<String, dynamic>);
        } on Exception catch (e) {
          print(e.toString());
        }
      });
    });

    try {
      //Starts connection
      await _hubConnection.start();
      setState(() {
        _playerConnectionStatus = "Connected";
        _signalRClientId = _hubConnection.connectionId!;
      });
      //Inform sever player is connceted to room.
      await _hubConnection.invoke("PlayerConnected",
          args: [currentUser.username, _signalRClientId]);
    } catch (error) {
      print(error);
    }

    // Gets the path to card images
    String GetPath(PlayingCard card) {
      if (card.value == "default") {
        return "default";
      } else {
        return card.value + "_of_" + card.suit;
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Texas Holdem'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Row(
              children: [
                Container(
                    width: 400,
                    height: 150,
                    margin: EdgeInsets.all(5),
                    // padding: const EdgeInsets.only(
                    //     left: 10, top: 20, right: 10, bottom: 0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                            color: Colors.grey,
                            width: 1,
                            style: BorderStyle.solid,
                            strokeAlign: StrokeAlign.inside)),
                    child: Column(
                      children: [
                        Text('1:'),
                        Text('2:'),
                        Text('3:'),
                      ],
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 400,
                  margin: EdgeInsets.all(5),
                  child: Column(children: [
                    Text('Table'),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 75,
                            height: 115,
                            // padding: const EdgeInsets.only(
                            //     left: 10, top: 20, right: 10, bottom: 0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                    style: BorderStyle.solid,
                                    strokeAlign: StrokeAlign.inside)),
                            child: Image.asset(
                                'assets/images/MadsTinkoMadsenWallpaper.jpg'),
                          ),
                          Container(
                            width: 75,
                            height: 115,
                            // padding: const EdgeInsets.only(
                            //     left: 10, top: 20, right: 10, bottom: 0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                    style: BorderStyle.solid,
                                    strokeAlign: StrokeAlign.inside)),
                            child: Image.asset(
                                'assets/images/MadsTinkoMadsenWallpaper.jpg'),
                          ),
                          Container(
                            width: 75,
                            height: 115,
                            // padding: const EdgeInsets.only(
                            //     left: 10, top: 20, right: 10, bottom: 0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                    style: BorderStyle.solid,
                                    strokeAlign: StrokeAlign.inside)),
                            child: Image.asset(
                                'assets/images/MadsTinkoMadsenWallpaper.jpg'),
                          ),
                          Container(
                            width: 75,
                            height: 115,
                            // padding: const EdgeInsets.only(
                            //     left: 10, top: 20, right: 10, bottom: 0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                    style: BorderStyle.solid,
                                    strokeAlign: StrokeAlign.inside)),
                            child: Image.asset(
                                'assets/images/MadsTinkoMadsenWallpaper.jpg'),
                          ),
                          Container(
                            width: 75,
                            height: 115,
                            // padding: const EdgeInsets.only(
                            //     left: 10, top: 20, right: 10, bottom: 0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                    style: BorderStyle.solid,
                                    strokeAlign: StrokeAlign.inside)),
                            child: Image.asset(
                                'assets/images/MadsTinkoMadsenWallpaper.jpg'),
                          ),
                        ]),
                  ]),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlayingCardWidget(path: (_firstPlayerCard)),
                PlayingCardWidget(path: (_secondPlayerCard))
                // Container(
                //   width: 75,
                //   height: 115,
                //   margin: EdgeInsets.all(5),
                //   // padding: const EdgeInsets.only(
                //   //     left: 10, top: 20, right: 10, bottom: 0),
                //   decoration: BoxDecoration(
                //       border: Border.all(
                //           color: Colors.grey,
                //           width: 1,
                //           style: BorderStyle.solid,
                //           strokeAlign: StrokeAlign.inside)),
                //   child:
                //       Image.asset('assets/images/MadsTinkoMadsenWallpaper.jpg'),
                // ),
                // Container(
                //   width: 75,
                //   height: 115,
                //   margin: EdgeInsets.all(5),
                //   // padding: const EdgeInsets.only(
                //   //     left: 10, top: 20, right: 10, bottom: 0),
                //   decoration: BoxDecoration(
                //       border: Border.all(
                //           color: Colors.grey,
                //           width: 1,
                //           style: BorderStyle.solid,
                //           strokeAlign: StrokeAlign.inside)),
                //   child:
                //       Image.asset('assets/images/MadsTinkoMadsenWallpaper.jpg'),
                // ),
              ],
            ),
            Container(
              height: 50,
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async {},
                    child: const Text(textScaleFactor: 1.25, 'CHECK'),
                  ),
                  ElevatedButton(
                    onPressed: () async {},
                    child: const Text(textScaleFactor: 1.25, 'CALL'),
                  ),
                  ElevatedButton(
                    onPressed: () async {},
                    child: const Text(textScaleFactor: 1.25, 'RAISE'),
                  ),
                  ElevatedButton(
                    onPressed: () async {},
                    child: const Text(textScaleFactor: 1.25, 'FOLD'),
                  ),
                ],
              ),
            ),
          ]),
        ),
      );
}
