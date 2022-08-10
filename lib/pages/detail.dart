import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nasa/models/nasa_manifest.dart';
import 'package:flutter_nasa/models/nasa_rover_photos.dart';
import 'package:flutter_nasa/pages/textfield.dart';
import 'package:flutter_nasa/states/loader_base.dart';
import 'package:flutter_nasa/states/nasa_manifest.dart';
import 'package:flutter_nasa/states/nasa_photo.dart';
import 'package:page_transition/page_transition.dart';
import 'package:lottie/lottie.dart';

const Color _primaryTextColor = Colors.grey;
const Color _contentTextColor = Colors.black;

class DetailsPage extends StatelessWidget {
  final String rover;

  const DetailsPage({Key? key, required this.rover}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    NasaManifestLoaderCubit cubit = NasaManifestLoaderCubit();
    cubit.fetchNasaRoverManifest(rover);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${rover[0].toUpperCase()}${rover.substring(1)}"),
        ),
        body: BlocBuilder<NasaManifestLoaderCubit,
                LoaderState<NasaRoverManifest>>(
            bloc: cubit,
            builder: (ctx, state) {
              if (cubit.isFailed) {
                return const Center(
                  child: Text("An error was occured"),
                );
              } else if (cubit.isLoading) {
                return Center(
                  child: Lottie.network(
                    'https://assets1.lottiefiles.com/packages/lf20_j8t8fjxs.json',
                  ),
                );
              } else if (cubit.isLoaded) {
                return _RoverDetail(
                  rover: rover,
                  roverInfo: (state as Loaded<NasaRoverManifest>).loaded,
                );
              } else {
                assert(false); //should never happen
                return Container();
              }
            }),
      ),
    );
  }
}

class _RoverDetail extends StatelessWidget {
  _RoverDetail({Key? key, required this.roverInfo, required this.rover})
      : super(key: key);

  final String rover;
  final NasaRoverManifest roverInfo;
  late NasaPhotoLoaderCubit _loader;

  @override
  Widget build(BuildContext context) {
    roverInfo.photos.shuffle();
    ManifestPhotoEntry entry =
        roverInfo.photos.firstWhere((element) => element.totalPhotos > 10);
    _loader = NasaPhotoLoaderCubit()..fetchNasaRoverPhotos(rover, entry.sol);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 300,
            child: Hero(
                tag: roverInfo.name,
                child: AspectRatio(
                    aspectRatio: 16.0 / 9,
                    child: Image.asset(
                        "images/${roverInfo.name.toLowerCase()}.jpg"))),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  roverInfo.name,
                  style: const TextStyle(
                    fontFamily: 'Avenir',
                    fontSize: 56,
                    color: _primaryTextColor,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.left,
                ),
                const Text(
                  'Solar System',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    fontSize: 31,
                    color: _primaryTextColor,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
                const Divider(color: Colors.black38),
                const SizedBox(height: 32),
                Text(
                  roverInfo.landingDate.toString(),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Avenir',
                    fontSize: 20,
                    color: _contentTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 32),
                const Divider(color: Colors.black38),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 32.0),
            child: Text(
              'Gallery',
              style: TextStyle(
                fontFamily: 'Avenir',
                fontSize: 25,
                color: Color(0xff47455f),
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            height: 250,
            child:
                BlocBuilder<NasaPhotoLoaderCubit, LoaderState<NasaRoverPhotos>>(
                    bloc: _loader,
                    builder: (context, state) {
                      if (_loader.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (_loader.isFailed) {
                        return const Center(
                          child: Text("Something went wrong"),
                        );
                      }
                      NasaRoverPhotos result =
                          (state as Loaded<NasaRoverPhotos>).loaded;
                      int baseIndex = result.photos.length <= 5
                          ? 0
                          : math.Random().nextInt(result.photos.length - 5);
                      result.photos.shuffle();
                      return ListView.builder(
                          itemCount: math.min(5, result.photos.length),
                          scrollDirection:
                              Axis.horizontal, // make list scroll horizontal
                          itemBuilder: (context, index) {
                            return Card(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.network(
                                    result.photos[baseIndex + index].image
                                        .toString(),
                                    fit: BoxFit.cover,
                                  )),
                            );
                          });
                    }),
          ),
          ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  // MaterialPageRoute(

                  //   builder: (_) => TextFieldExample(
                  //     rover: roverInfo.name.toLowerCase(),

                  //   ),
                  //),
                  PageTransition(
                    child:
                        TextFieldExample(rover: roverInfo.name.toLowerCase()),
                    type: PageTransitionType.rightToLeft,
                    childCurrent: this,
                    duration: const Duration(milliseconds: 200),
                  ),
                );
              },
              icon: const Icon(Icons.newspaper),
              label: const Text("Learn more"))
        ],
      ),
    );
  }
}
