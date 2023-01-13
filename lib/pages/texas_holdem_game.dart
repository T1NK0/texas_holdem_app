import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:texas_holdem_app/globals.dart';
import 'package:texas_holdem_app/model/action_model.dart';
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
  List<String> _winners = [];

  late ActionModel _validActions =
      ActionModel(call: false, check: false, raise: false, fold: false);
  late bool _isReady;

  String _playerMoney = "";
  String _potMoney = "000";

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
    _hubConnection.stop();
  }

  void _connectToHub() async {
    _hubConnection = HubConnectionBuilder()
        .withUrl(
          "http://10.0.2.2:5000/texas",
          options: HttpConnectionOptions(
            accessTokenFactory: () async => await currentUser.GetToken(),
            // transport: HttpTransportType.WebSockets,
          ),
        )
        .withAutomaticReconnect()
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

    _hubConnection.on("GetTurn", (arguments) {
      setState(() {
        try {
          var obj = arguments![0];
          _fourthCommunityCard =
              PlayingCard.fromMap(obj as Map<String, dynamic>);
        } on Exception catch (e) {
          print(e.toString());
        }
      });
    });

    _hubConnection.on("GetRiver", (arguments) {
      setState(() {
        try {
          var obj = arguments![0];
          _fifthCommunityCard =
              PlayingCard.fromMap(obj as Map<String, dynamic>);
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

    _hubConnection.on("UpdateMoney", (arguments) {
      setState(() {
        try {
          var obj = arguments![0].toString();
          _playerMoney = obj;
        } on Exception catch (e) {
          print(e.toString());
        }
      });
    });

    _hubConnection.on("UpdatePot", (arguments) {
      setState(() {
        try {
          var obj = arguments![0].toString();
          _potMoney = obj;
        } on Exception catch (e) {
          print(e.toString());
        }
      });
    });

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

    _hubConnection.on("ActionReady", (arguments) {
      setState(() {
        try {
          var obj = arguments![0];
          _validActions = ActionModel.fromMap(obj as Map);
          print("------- ActionReady has run -------");
        } on Exception catch (e) {
          print(e.toString());
        }
      });
    });

    _hubConnection.on("ShowWinners", (arguments) {
      setState(() {
        try {
          var obj = arguments![0];
          _validActions = ActionModel.fromMap(obj as Map);
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text(
                      'WINNERS',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    content: Column(
                      children: [
                        for (var winner in _winners) Text("${winner}")
                      ],
                    ),
                    actions: <Widget>[
                      MaterialButton(
                        color: Colors.red,
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {});
                        },
                      ),
                    ]);
              });
        } on Exception catch (e) {
          print(e.toString());
        }
      });
    });
  }

  Logger get newMethod => PrintLog;

  Logger get PrintLog => logger;

  // Gets the path to card images
  String GetPath(PlayingCard card) {
    if (card.rank == "default") {
      return "default";
    } else {
      return card.rank + "_of_" + card.suit;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Texas Holdem'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                await _hubConnection.invoke("PlayerDisconnected",
                    args: [currentUser.username, _signalRClientId]);
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: Center(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 380,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                                color: Colors.grey,
                                width: 1,
                                style: BorderStyle.solid,
                                strokeAlign: StrokeAlign.inside)),
                        child: Column(
                          children: [
                            Text("GAMELOG",
                                textScaleFactor: 1.25,
                                style: TextStyle(color: Colors.red)),
                            Text(_messageLog[2]),
                            Text(_messageLog[1]),
                            Text(_messageLog[0]),
                          ],
                        ),
                      ),
                    ],
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 380,
                margin: EdgeInsets.all(5),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Community Cards',
                        textScaleFactor: 1.25,
                        style: TextStyle(color: Colors.red),
                      ),
                      Text(
                        'Total Pot: ${_potMoney}',
                        textScaleFactor: 1.25,
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
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
                  SizedBox(height: 10),
                  Text(
                    "Player hand",
                    textScaleFactor: 1.25,
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 380,
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
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Player: ${currentUser.username}",
                      textScaleFactor: 1.5,
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Turkey Coins: ${_playerMoney}",
                      textScaleFactor: 1.5,
                    ),
                    // Text(
                    //   "Status: $_playerConnectionStatus",
                    //   textScaleFactor: 1.5,
                    // ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (_isReady == false)
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
                      if (_validActions.check == true)
                        ElevatedButton(
                          onPressed: () async {
                            print(
                                "------- ${currentUser.username} has CHECKED -------");
                            try {
                              await _hubConnection.invoke("PlayerMove", args: [
                                currentUser.username,
                                'check',
                                0,
                                _signalRClientId
                              ]);
                              setState(() {
                                ResetUserButtons();
                              });
                            } on Exception catch (e) {
                              print(e.toString());
                            }
                          },
                          child: const Text(textScaleFactor: 1.25, 'CHECK'),
                        ),
                      if (_validActions.call == true)
                        ElevatedButton(
                          onPressed: () async {
                            print(
                                "------- ${currentUser.username} has CALLED -------");
                            try {
                              await _hubConnection.invoke("PlayerMove", args: [
                                currentUser.username,
                                'call',
                                0,
                                _signalRClientId
                              ]);
                              setState(() {
                                ResetUserButtons();
                              });
                            } on Exception catch (e) {
                              print(e.toString());
                            }
                          },
                          child: const Text(textScaleFactor: 1.25, 'CALL'),
                        ),
                      if (_validActions.raise == true)
                        ElevatedButton(
                          onPressed: () async {
                            print(
                                "------- ${currentUser.username} has RAISED. -------");
                            try {
                              await _hubConnection.invoke("PlayerMove", args: [
                                currentUser.username,
                                "raise",
                                10,
                                _signalRClientId
                              ]);
                              setState(() {
                                ResetUserButtons();
                              });
                            } on Exception catch (e) {
                              print(e.toString());
                            }
                          },
                          child: const Text(textScaleFactor: 1.25, 'RAISE'),
                        ),
                      if (_validActions.fold == true)
                        ElevatedButton(
                          onPressed: () async {
                            print(
                                "------- ${currentUser.username} has FOLDED. -------");
                            try {
                              await _hubConnection.invoke("PlayerMove", args: [
                                currentUser.username,
                                "fold",
                                0,
                                _signalRClientId
                              ]);
                              setState(() {
                                ResetUserButtons();
                              });
                            } on Exception catch (e) {
                              print(e.toString());
                            }
                          },
                          child: const Text(textScaleFactor: 1.25, 'FOLD'),
                        ),
                    ]),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  void ResetUserButtons() {
    _validActions =
        ActionModel(call: false, check: false, raise: false, fold: false);
  }
}
