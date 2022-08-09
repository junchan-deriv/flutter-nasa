import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class RoverPage extends StatelessWidget {
  const RoverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 58, 57, 57),
        appBar: AppBar(
          elevation: 15,
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20), //200 ,200
                  bottomRight: Radius.circular(300))),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "The Mars Rovers",
                      style: TextStyle(
                          fontFamily: 'ChakraPetch',
                          fontSize: 50,
                          color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 59)
              ],
            ),
          ),
        ),
        body: Center(
          child: ListView(children: <Widget>[
            GestureDetector(
              onTap: () {},
              child: Container(
                child: new Image.asset(
                  'images/curiosity.jpg',
                  height: 250,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                child: new Image.asset('images/spirit.jpg',
                    height: 250, fit: BoxFit.fill),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                child: new Image.asset('images/opportunity.jpg',
                    height: 250, fit: BoxFit.fill),
              ),
            ),
          ]),
        ));
  }
}
