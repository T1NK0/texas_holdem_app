import 'package:flutter/material.dart';
import 'package:texas_holdem_app/globals.dart';
import 'package:texas_holdem_app/model/action_model.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:texas_holdem_app/model/playing_card_model.dart';
import 'package:texas_holdem_app/widgets/playing_card_widget.dart';

class TexasHoldemGamePage extends StatefulWidget {
  const TexasHoldemGamePage({super.key});

  @override
  _TexasHoldemRoomState createState() => _TexasHoldemRoomState();
}

class _TexasHoldemRoomState extends State<TexasHoldemGamePage> {
  /// Properties
  String _playerConnectionStatus = "Disconnected";
  String _message = "Message to receive";
  String _signalRClientId = "";
  List<String> _messageLog = [
    "",
    "",
    "",
  ];

  late ActionModel _validActions =
      ActionModel(call: false, check: false, raise: false, fold: false);
  late bool _isReady;

  String _playerMoney = "";
  String _potMoney = "000";

  /// Player hand
  PlayingCard _firstPlayerCard = PlayingCard();
  PlayingCard _secondPlayerCard = PlayingCard();

  /// Community cards
  PlayingCard _firstCommunityCard = PlayingCard();
  PlayingCard _secondCommunityCard = PlayingCard();
  PlayingCard _thirdCommunityCard = PlayingCard();
  PlayingCard _fourthCommunityCard = PlayingCard();
  PlayingCard _fifthCommunityCard = PlayingCard();

  ///  Hub
  late HubConnection _hubConnection;

  /// Methods

  @override
  void initState() {
    super.initState();
    _connectToHub();
    _isReady = false;
  }

  /// What to do when player disconnects from the room.
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
          ),
        )
        .withAutomaticReconnect()
        .build();

    /// Set the community cards to the random cards.
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

    /// Get's a fourth community card
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

    /// Get's a sixth community card
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

    /// Get's the cards for the player hand.
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

    /// Starts connection
    /// Inform sever player is connceted to room.
    try {
      await _hubConnection.start();
      setState(() {
        _playerConnectionStatus = "Connected";
        _signalRClientId = _hubConnection.connectionId!;
      });
      await _hubConnection.invoke("PlayerConnected",
          args: [currentUser.username, _signalRClientId]);
    } catch (error) {
      print(error);
    }

    /// Updates the players currency.
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

    /// Updates the total pot.
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

    /// Prints the message to the gamelog at the top of the game room.
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

    /// Returns a list of available actions to display on the users app.
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

    /// Shows the dialog that pops up when a winner is chosen.
    _hubConnection.on("ShowWinners", (arguments) {
      try {
        var obj = arguments![0] as List;
        var usernameWinner = obj[0].toString();

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  title: const Text(
                    'WINNERS',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  content: Text("$usernameWinner"),
                  actions: <Widget>[
                    Center(
                      child: MaterialButton(
                        color: Colors.red,
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            ResetAll();
                          });
                        },
                      ),
                    ),
                  ]);
            });
      } on Exception catch (e) {
        print(e.toString());
      }
    });
  }

  /// Gets the path to card images
  String GetPath(PlayingCard card) {
    if (card.rank == "default") {
      return "default";
    } else {
      return card.rank + "_of_" + card.suit;
    }
  }

  /// Hides all user actions.
  void ResetUserButtons() {
    _validActions =
        ActionModel(call: false, check: false, raise: false, fold: false);
  }

  /// Reset's all the current games info back to default so a new round can start.
  void ResetAll() {
    // Log messages
    _messageLog[0] = "";
    _messageLog[1] = "";
    _messageLog[2] = "";

    // Community Cards
    _firstCommunityCard = PlayingCard();
    _secondCommunityCard = PlayingCard();
    _thirdCommunityCard = PlayingCard();
    _fourthCommunityCard = PlayingCard();
    _fifthCommunityCard = PlayingCard();

    // Player hand cards
    _firstPlayerCard = PlayingCard();
    _secondPlayerCard = PlayingCard();

    // Pot
    _potMoney = "000";

    // Buttons
    _validActions =
        ActionModel(call: false, check: false, raise: false, fold: false);
    _isReady = false;
  }

  /// Widgets (ui)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Texas Holdem'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                await _hubConnection.invoke("PlayerDisconnected",
                    args: [currentUser.username, _signalRClientId]);
                // ignore: use_build_context_synchronously
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
                  margin: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 380,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                                color: Colors.grey,
                                width: 1,
                                style: BorderStyle.solid,
                                strokeAlign: StrokeAlign.inside)),
                        child: Column(
                          children: [
                            const Text("GAMELOG",
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
                margin: const EdgeInsets.all(5),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Community Cards',
                        textScaleFactor: 1.25,
                        style: TextStyle(color: Colors.red),
                      ),
                      Text(
                        'Total Pot: $_potMoney',
                        textScaleFactor: 1.25,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
                  const Text(
                    "Player hand",
                    textScaleFactor: 1.25,
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 380,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PlayingCardWidget(path: GetPath(_firstPlayerCard)),
                        const SizedBox(width: 10),
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
            child: Column(children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Player: ${currentUser.username}",
                    textScaleFactor: 1.5,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    "Turkey Coins: $_playerMoney",
                    textScaleFactor: 1.5,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                if (_isReady == false)
                  ElevatedButton(
                    onPressed: _isReady
                        ? null
                        : () async {
                            _isReady = true;
                            await _hubConnection.invoke("PlayerIsReady",
                                args: [currentUser.username, _signalRClientId]);
                          },
                    child: const Text('Ready to play'),
                  ),
                if (_validActions.check == true)
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        ResetUserButtons();
                      });
                      print(
                          "------- ${currentUser.username} has CHECKED -------");
                      try {
                        await _hubConnection.invoke("PlayerMove", args: [
                          currentUser.username,
                          'check',
                          0,
                          _signalRClientId
                        ]);
                      } on Exception catch (e) {
                        print(e.toString());
                      }
                    },
                    child: const Text(textScaleFactor: 1.25, 'CHECK'),
                  ),
                if (_validActions.call == true)
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        ResetUserButtons();
                      });
                      print(
                          "------- ${currentUser.username} has CALLED -------");
                      try {
                        await _hubConnection.invoke("PlayerMove", args: [
                          currentUser.username,
                          'call',
                          0,
                          _signalRClientId
                        ]);
                      } on Exception catch (e) {
                        // ignore: avoid_print
                        print(e.toString());
                      }
                    },
                    child: const Text(textScaleFactor: 1.25, 'CALL'),
                  ),
                if (_validActions.raise == true)
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        ResetUserButtons();
                      });
                      try {
                        await _hubConnection.invoke("PlayerMove", args: [
                          currentUser.username,
                          "raise",
                          10,
                          _signalRClientId
                        ]);
                      } on Exception catch (e) {
                        // ignore: avoid_print
                        print(e.toString());
                      }
                    },
                    child: const Text(textScaleFactor: 1.25, 'RAISE'),
                  ),
                if (_validActions.fold == true)
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        ResetUserButtons();
                      });
                      try {
                        await _hubConnection.invoke("PlayerMove", args: [
                          currentUser.username,
                          "fold",
                          0,
                          _signalRClientId
                        ]);
                      } on Exception catch (e) {
                        // ignore: avoid_print
                        print(e.toString());
                      }
                    },
                    child: const Text(textScaleFactor: 1.25, 'FOLD'),
                  ),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}
