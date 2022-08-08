import 'package:flutter/material.dart';
import 'package:flutter_nasa/models/nasa_rover_photos.dart';
import 'package:transparent_image/transparent_image.dart';

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
          Hero(
            tag: nasa.id,
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: nasa.image.toString(),
              fit: BoxFit.contain,
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Text(
                    nasa.earthDate.toString(),
                    style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic),
                  ),
                  Container(
                    width: 200,
                    child: const Text(
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
          //todo add more info here
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                textStyle: TextStyle(fontSize: 20),
              ),
              child: Text('Learn More'),
              onPressed: () {})
        ],
      ),
    );
  }
}
