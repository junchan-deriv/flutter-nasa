import 'dart:convert';

import 'package:flutter_nasa/models/nasa_manifest.dart';

class NasaRoverPhotos {
  final List<NasaRoverPhotoEntry> photos;

  NasaRoverPhotos({required this.photos});
  factory NasaRoverPhotos.fromJson(String str) => NasaRoverPhotos(
        photos: List<NasaRoverPhotoEntry>.from(
          jsonDecode(str)['photos'].map(
            (z) => NasaRoverPhotoEntry.fromMap(z),
          ),
        ),
      );
}

class NasaRoverPhotoEntry {
  final int id;
  final int sol;
  final DateTime earthDate;
  final Uri image;
  final NasaRoverCamera camera;
  NasaRoverPhotoEntry(
      {required this.id,
      required this.sol,
      required this.earthDate,
      required this.image,
      required this.camera});
  factory NasaRoverPhotoEntry.fromMap(Map<String, dynamic> map) =>
      NasaRoverPhotoEntry(
        id: map['id'].toInt(),
        sol: map['sol'].toInt(),
        earthDate: DateTime.parse(map['earth_date']),
        image: Uri.parse(map['img_src']),
        camera: NasaRoverCamera.fromMap(map['camera']),
      );
}

class NasaRoverCamera {
  final int id;
  final RoverCamera name;
  final String fullName;
  NasaRoverCamera(
      {required this.id, required this.name, required this.fullName});
  factory NasaRoverCamera.fromMap(Map<String, dynamic> map) => NasaRoverCamera(
      id: map["id"].toInt(),
      name: RoverCamera.values.byName(map['name']),
      fullName: map['full_name']);
}
