import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class RoverPage extends StatelessWidget {
  const RoverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: const Text(
              "Mars Rover",
              style: TextStyle(
                  fontFamily: 'ChakraPetch',
                  fontSize: 40,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        body: Center(
          child: Column(children: [
            Container(
              height: 90.0,
              width: 300.0,
              color: Colors.red,
            ),
            Container(
              height: 90.0,
              width: 300.0,
              color: Color.fromARGB(255, 145, 84, 80),
            ),
            Container(
              height: 90.0,
              width: 300.0,
              color: Colors.red,
            ),
          ]),
        ));
  }
}
