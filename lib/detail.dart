import 'package:flutter/material.dart';
import 'package:flutter_nasa/models/nasa_rover_photos.dart';

class DetailsPage extends StatelessWidget {
  final NasaRoverPhotoEntry nasa;

  const DetailsPage({Key? key, required this.nasa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nasa.camera.fullName),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          Hero(
            tag: nasa.earthDate,
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: nasa.image.toString(),
              fit: BoxFit.contain,
            ),
          ),
          Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Text(
                    nasa.earthDate.toString(),
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic),
                  ),
                  Container(
                    width: 200,
                    child: Text(
                      "(C) Nasa",
                      softWrap: true,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              )),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
            child: Text(
              nasa.sol,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
