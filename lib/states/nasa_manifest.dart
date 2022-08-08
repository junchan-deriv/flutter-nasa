import 'package:flutter_nasa/models/nasa_manifest.dart';
import 'package:flutter_nasa/services/nasa.dart';
import 'package:flutter_nasa/states/loader_base.dart';

class NasaManifestLoaderCubit extends LoaderCubitBase<NasaRoverManifest> {
  void fetchNasaRoverManifest(String roverName) {
    //alias to internal call
    loadStuffsInternal(NasaService.getRoverManifest(roverName), roverName);
  }
}
