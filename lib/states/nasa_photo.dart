import 'package:flutter_nasa/models/nasa_manifest.dart';
import 'package:flutter_nasa/models/nasa_rover_photos.dart';
import 'package:flutter_nasa/services/nasa.dart';
import 'package:flutter_nasa/states/loader_base.dart';

class NasaPhotoLoaderCubit extends LoaderCubitBase<NasaRoverPhotos> {
  void fetchNasaRoverPhotos(String rover, int sol, [RoverCamera? camera]) {
    //alias to internal call
    loadStuffsInternal(NasaService.getRoverPhotos(rover, sol, camera), rover);
  }
}
