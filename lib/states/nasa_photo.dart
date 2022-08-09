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
  @override
  String toString() {
    return rover;
  }
}

///
/// A substate that the data is in transitive loading where
/// it is fetching the new batch of data
///
class NasaPhotoTransitiveLoading extends Loading<NasaRoverPhotos> {
  final NasaRoverPhotos cached;
  NasaPhotoTransitiveLoading({required this.cached, required super.tag});
}

class NasaPhotoLoaderCubit extends LoaderCubitBase<NasaRoverPhotos> {
  void fetchNasaRoverPhotos(String rover, int sol,
      {RoverCamera? camera, int page = 1}) {
    //alias to internal call
    loadStuffsInternal(
      NasaService.getRoverPhotos(rover, sol, camera, page),
      _NasaPhotoLoaderTag(
        camera: camera,
        rover: rover,
        sol: sol,
        page: page,
      ),
    );
  }

  ///
  /// fetch next page
  ///
  void fetchNextPage() async {
    if (!isLoaded || state.tag is! _NasaPhotoLoaderTag) {
      throw Exception("Cannot perform the fetch, the tag is missing");
    }
    _NasaPhotoLoaderTag tag = state.tag;
    //put into transitive loading state instead of loading state
    //to allow the UI still having rendering while it is loading
    //in background
    emit(
      NasaPhotoTransitiveLoading(
        cached: (state as Loaded<NasaRoverPhotos>).loaded,
        tag: tag,
      ),
    );
    //prepare the request
    try {
      int page = tag.page + 1;
      NasaRoverPhotos nextBatch = await NasaService.getRoverPhotos(
          tag.rover, tag.sol, tag.camera, page);
      //with both of the requests merge it
      NasaRoverPhotos merged = NasaRoverPhotos(
          photos: [
        (state as Loaded<NasaRoverPhotos>).loaded.photos,
        nextBatch.photos
        //expand(x) performs mapping for x=>x' where x' is zero or more
        //elements which will added into the list
        //effectively this in js
        //[a,b,c].reduce((c,v)=>{for(const _v of v)c.push(v);return c;},[])
      ].expand((x) => x).toList());
      //emit the final loaded event
      emit(
        Loaded<NasaRoverPhotos>(
          loaded: merged,
          tag: _NasaPhotoLoaderTag(
            rover: tag.rover,
            camera: tag.camera,
            sol: tag.sol,
            page: page,
          ),
        ),
      );
    } on Error catch (e) {
      emit(LoaderError(error: e, tag: tag));
    }
  }
}
