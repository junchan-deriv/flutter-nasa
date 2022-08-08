import 'package:flutter_nasa/models/nasa_rover_photos.dart';

///
/// Common header for the Nasa Api
///
const String apiKey = "DEMO_KEY";
Uri _constructEndpointUri(
    {required String path, Map<String, dynamic>? queryParams}) {
  Map<String, dynamic> params = queryParams ?? {};
  if (!params.containsKey("api_key")) {
    params["api_key"] = apiKey;
  }
  return Uri(
      scheme: "https",
      host: "api.nasa.gov",
      pathSegments: ["/mars-photos/api/v1", path],
      queryParameters: params);
}

class NasaService {
//  static Future<NasaRoverPhotos> getRoverPhotos()
}
