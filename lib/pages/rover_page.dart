import 'package:flutter/material.dart';
import 'package:flutter_nasa/pages/detail.dart';
import 'package:flutter_nasa/widgets/bordered_image.dart';
import 'package:flutter_nasa/widgets/master_detail_tablet.dart';

class RoverPage extends StatelessWidget {
  const RoverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const List<String> rovers = <String>[
      'Curiosity',
      'Spirit',
      'Opportunity',
    ];
    Size size = MediaQuery.of(context).size;
    bool mobile = size.longestSide == size.height;
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 131, 125, 125),
      body: mobile
          ? const RoverPageBody(rovers: rovers)
          : MasterDetailRenderer(
              master: const RoverPageBody(
                rovers: rovers,
              ),
              detail: (_) => const DetailsPage(
                    rover: "curiosity",
                  )),
    );
  }
}

class RoverPageBody extends StatelessWidget {
  const RoverPageBody({
    Key? key,
    required this.rovers,
  }) : super(key: key);

  final List<String> rovers;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/stars.jpg'), fit: BoxFit.cover)),
      child: CustomScrollView(
        primary: !inTabletView(context),
        slivers: [
          SliverAppBar(
            elevation: 15,
            backgroundColor: const Color.fromARGB(255, 19, 17, 17),
            flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 25.0, bottom: 30),
                title: const Text(
                  "Mars Rovers",
                  style: TextStyle(
                      fontFamily: 'ChakraPetch',
                      fontSize: 30,
                      color: Colors.white),
                ),
                background: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(200)),
                    child: Image.asset("images/mars-nasa.jpg",
                        fit: BoxFit.cover))),
            shape: const RoundedRectangleBorder(
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
                  Widget buildPage(BuildContext context) {
                    return DetailsPage(rover: rover);
                  }

                  if (pushDetailToTabletViewAsRoot(context, buildPage)) {
                    return;
                  }
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: buildPage));
                },
                // ignore: avoid_unnecessary_containers
                child: Container(
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20).copyWith(
                            bottomRight: Radius.zero, bottomLeft: Radius.zero),
                        child: BorderedImage(
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
    );
  }
}
