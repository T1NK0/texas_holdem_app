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
  List<String> _messageLog = [
    "",
    "",
    "",
  ];

  late bool _isReady;

  //Player hand
  PlayingCard _firstPlayerCard = PlayingCard();
  PlayingCard _secondPlayerCard = PlayingCard();

  //Community cards
  PlayingCard _firstCommunityCard = PlayingCard();
  PlayingCard _secondCommunityCard = PlayingCard();
  PlayingCard _thirdCommunityCard = PlayingCard();
  PlayingCard _fourthCommunityCard = PlayingCard();
  PlayingCard _fifthCommunityCard = PlayingCard();

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

    _hubConnection.on("GetFlop", (arguments) {
      setState(() {
        try {
          var obj = arguments![0];
          _firstCommunityCard =
              PlayingCard.fromMap(obj as Map<String, dynamic>);

          var obj2 = arguments[1];
          _secondCommunityCard =
              PlayingCard.fromMap(obj2 as Map<String, dynamic>);

          var obj3 = arguments[2];
          _thirdCommunityCard =
              PlayingCard.fromMap(obj3 as Map<String, dynamic>);
        } on Exception catch (e) {
          print(e.toString());
        }
      });
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

    _hubConnection.on("SendMessage", (arguments) {
      setState(() {
        try {
          var obj = arguments![0].toString();
          _message = obj;

          _messageLog[2] = _messageLog[1];
          _messageLog[1] = _messageLog[0];
          _messageLog[0] = _message;
        } on Exception catch (e) {
          print(e.toString());
        }
      });
    });
  }

  // Gets the path to card images
  String GetPath(PlayingCard card) {
    if (card.value == "default") {
      return "default";
    } else {
      return card.value + "_of_" + card.suit;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Text(
                        "Status: $_playerConnectionStatus",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(_messageLog[2]),
                      Text(_messageLog[1]),
                      Text(_messageLog[0]),
                      ElevatedButton(
                        onPressed: _isReady
                            ? null
                            : () async {
                                print(_hubConnection.connectionId);
                                _isReady = true;
                                await _hubConnection.invoke("PlayerIsReady",
                                    args: [
                                      currentUser.username,
                                      _signalRClientId
                                    ]);
                              },
                        child: const Text('Ready to play'),
                      ),
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
                  SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PlayingCardWidget(path: GetPath(_firstCommunityCard)),
                        PlayingCardWidget(path: GetPath(_secondCommunityCard)),
                        PlayingCardWidget(path: GetPath(_thirdCommunityCard)),
                        PlayingCardWidget(path: GetPath(_fourthCommunityCard)),
                        PlayingCardWidget(path: GetPath(_fifthCommunityCard)),
                      ]),
                ]),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text("Player hand"),
                  SizedBox(height: 10),
                  Container(
                    width: 400,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PlayingCardWidget(path: GetPath(_firstPlayerCard)),
                        SizedBox(width: 10),
                        PlayingCardWidget(path: GetPath(_secondPlayerCard))
                      ],
                    ),
                  ),
                ],
              )
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
}
