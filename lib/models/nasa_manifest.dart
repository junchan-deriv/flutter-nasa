import 'dart:convert';

enum RoverStatus { active, complete }

enum RoverCamera {
// ignore: constant_identifier_names
  FHAZ,
  // ignore: constant_identifier_names
  RHAZ,
  // ignore: constant_identifier_names
  MAST,
  // ignore: constant_identifier_names
  CHEMCAM,
  // ignore: constant_identifier_names
  MAHLI,
  // ignore: constant_identifier_names
  MARDI,
  // ignore: constant_identifier_names
  NAVCAM,
  // ignore: constant_identifier_names
  PANCAM,
  // ignore: constant_identifier_names
  MINITES,
  // ignore: constant_identifier_names
  ENTRY
}

///
/// The manifest returned from /:name/manifest
///
class NasaRoverManifest {
  final String name;
  final DateTime landingDate;
  final DateTime launchDate;
  final RoverStatus status;
  final int maxSol;
  final DateTime maxDate;
  final int totalPhotos;
  final List<ManifestPhotoEntry> photos;
  NasaRoverManifest(
      {required this.name,
      required this.landingDate,
      required this.launchDate,
      required this.status,
      required this.photos,
      required this.maxDate,
      required this.maxSol,
      required this.totalPhotos});
  factory NasaRoverManifest.fromMap(Map<String, dynamic> json) =>
      NasaRoverManifest(
        name: json["name"],
        landingDate: DateTime.parse(json["landing_date"]),
        launchDate: DateTime.parse(json["launch_date"]),
        status: RoverStatus.values.byName(json["status"]),
        maxDate: DateTime.parse(json["max_date"]),
        maxSol: (json["max_sol"]).toInt(),
        totalPhotos: (json["total_photos"]).toInt(),
        photos: List<ManifestPhotoEntry>.from(
          json["photos"].map((x) => ManifestPhotoEntry.fromMap(x)),
        ),
      );
  factory NasaRoverManifest.fromJson(String json) =>
      NasaRoverManifest.fromMap(jsonDecode(json)["photo_manifest"]);
}

///
///The photo entry returned
///
class ManifestPhotoEntry {
  final int sol;
  final DateTime earthDate;
  final int totalPhotos;
  final List<RoverCamera> cameras;
  ManifestPhotoEntry(
      {required this.sol,
      required this.earthDate,
      required this.totalPhotos,
      required this.cameras});
  factory ManifestPhotoEntry.fromMap(Map<String, dynamic> json) =>
      ManifestPhotoEntry(
        sol: (json['sol']).toInt(),
        earthDate: DateTime.parse(json['earth_date']),
        totalPhotos: (json['total_photos']).toInt(),
        cameras: List<RoverCamera>.from(
          json['cameras'].map(
            (x) => RoverCamera.values.byName(x),
          ),
        ),
      );
}
