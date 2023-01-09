import 'package:flutter/material.dart';

class SevenCardStubGamePage extends StatelessWidget {
  const SevenCardStubGamePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Seven Card Stud'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Row(
              children: [
                Container(
                    width: 400,
                    height: 150,
                    padding: const EdgeInsets.only(
                        left: 10, top: 20, right: 10, bottom: 0),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black,
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
            SizedBox(),
            Row(
              children: [],
            ),
            SizedBox(),
            Row(
              children: [],
            ),
          ]),
        ),
      );
}
