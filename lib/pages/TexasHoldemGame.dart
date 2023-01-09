import 'package:flutter/material.dart';

class TexasHoldemGamePage extends StatelessWidget {
  const TexasHoldemGamePage({super.key});

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 75,
                  height: 111,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey,
                        width: 1,
                        style: BorderStyle.solid,
                        strokeAlign: StrokeAlign.inside),
                  ),
                  child: Image.asset('assets/images/map-gd2d516e34_1280.jpg'),
                ),
                Container(
                  width: 75,
                  height: 111,
                  margin: EdgeInsets.all(5),
                  // padding: const EdgeInsets.only(
                  //     left: 10, top: 20, right: 10, bottom: 0),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey,
                          width: 1,
                          style: BorderStyle.solid,
                          strokeAlign: StrokeAlign.inside)),
                  child: Image.asset('assets/images/map-gd2d516e34_1280.jpg'),
                ),
                Container(
                  width: 75,
                  height: 111,
                  margin: EdgeInsets.all(5),
                  // padding: const EdgeInsets.only(
                  //     left: 10, top: 20, right: 10, bottom: 0),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey,
                          width: 1,
                          style: BorderStyle.solid,
                          strokeAlign: StrokeAlign.inside)),
                  child: Image.asset('assets/images/map-gd2d516e34_1280.jpg'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 75,
                  height: 111,
                  margin: EdgeInsets.all(5),
                  // padding: const EdgeInsets.only(
                  //     left: 10, top: 20, right: 10, bottom: 0),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey,
                          width: 1,
                          style: BorderStyle.solid,
                          strokeAlign: StrokeAlign.inside)),
                ),
                Container(
                  width: 75,
                  height: 111,
                  margin: EdgeInsets.all(5),
                  // padding: const EdgeInsets.only(
                  //     left: 10, top: 20, right: 10, bottom: 0),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey,
                          width: 1,
                          style: BorderStyle.solid,
                          strokeAlign: StrokeAlign.inside)),
                ),
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
