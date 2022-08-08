import 'package:flutter_nasa/models/nasa_manifest.dart';
import 'package:flutter_nasa/models/nasa_rover_photos.dart';
import 'package:flutter_nasa/services/nasa.dart';
import 'package:flutter_nasa/states/loader_base.dart';

class _NasaPhotoLoaderTag {
  final String rover;
  final int sol;
  final RoverCamera? camera;
  int page;
  _NasaPhotoLoaderTag(
      {required this.rover,
      required this.sol,
      required this.camera,
      required this.page});
}

class NasaPhotoLoaderCubit extends LoaderCubitBase<NasaRoverPhotos> {
  void fetchNasaRoverPhotos(String rover, int sol,
      {RoverCamera? camera, int page = 1}) {
    //alias to internal call
    loadStuffsInternal(
        NasaService.getRoverPhotos(rover, sol, camera, page),
        _NasaPhotoLoaderTag(
            camera: camera, rover: rover, sol: sol, page: page));
  }
}
