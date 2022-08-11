import 'dart:ui';

import 'package:drop_shadow_image/drop_shadow_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_nasa/pages/detail.dart';
import 'package:flutter_nasa/widgets/blurred_image.dart';

class RoverPage extends StatelessWidget {
  const RoverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const List<String> rovers = <String>[
      'Curiosity',
      'Spirit',
      'Opportunity',
    ];

    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 131, 125, 125),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/stars.jpg'), fit: BoxFit.cover)),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              elevation: 15,
              backgroundColor: Color.fromARGB(255, 19, 17, 17),
              flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 25.0, bottom: 30),
                  title: Text(
                    "Mars Rovers",
                    style: TextStyle(
                        fontFamily: 'ChakraPetch',
                        fontSize: 30,
                        color: Colors.white),
                  ),
                  background: ClipRRect(
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(200)),
                      child: Image.asset("images/mars-nasa.jpg",
                          fit: BoxFit.cover))),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(200), //200 ,200
              )),
              pinned: true,
              expandedHeight: MediaQuery.of(context).size.height * 0.250,
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
              (context, index) {
                final String rover = rovers[index].toLowerCase();
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return DetailsPage(rover: rover);
                    }));
                  },
                  child: Container(
                    child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20).copyWith(
                              bottomRight: Radius.zero,
                              bottomLeft: Radius.zero),
                          child: BlurredImage(
                            image: Image.asset(
                              'images/$rover.jpg',
                              height: 260,
                              fit: BoxFit.fill,
                            ),
                          ),
                          //BluredImage is the widget
                        )),
                  ),
                );
              },
              childCount: rovers.length,
            )),
          ],
        ),
      ),
    );
  }
}
