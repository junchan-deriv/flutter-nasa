import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nasa/models/nasa_manifest.dart';
import 'package:flutter_nasa/models/nasa_rover_photos.dart';
import 'package:flutter_nasa/pages/textfield.dart';
import 'package:flutter_nasa/states/loader_base.dart';
import 'package:flutter_nasa/states/nasa_manifest.dart';
import 'package:flutter_nasa/states/nasa_photo.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

const Color _primaryTextColor = Colors.white;
String _dateTimeToString(DateTime s) {
  return "${s.year}-${s.month}-${s.day}";
}

class DetailsPage extends StatelessWidget {
  final String rover;

  const DetailsPage({Key? key, required this.rover}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    NasaManifestLoaderCubit cubit = NasaManifestLoaderCubit();
    cubit.fetchNasaRoverManifest(rover);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black, // background
        // appBar: AppBar(
        //   title: Text("${rover[0].toUpperCase()}${rover.substring(1)}"),
        // ),
        body: BlocBuilder<NasaManifestLoaderCubit,
                LoaderState<NasaRoverManifest>>(
            bloc: cubit,
            builder: (ctx, state) {
              if (cubit.isFailed) {
                return Center(
                  child: Text(AppLocalizations.of(ctx)!.errorMessage),
                );
              } else if (cubit.isLoading) {
                return Center(
                  child: Lottie.network(
                    'https://assets1.lottiefiles.com/packages/lf20_j8t8fjxs.json',
                    errorBuilder: (context, error, stackTrace) {
                      return const CircularProgressIndicator();
                    },
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

// ignore: must_be_immutable
class _RoverDetail extends StatelessWidget {
  _RoverDetail({Key? key, required this.roverInfo, required this.rover})
      : super(key: key);

  final String rover;
  final NasaRoverManifest roverInfo;
  late NasaPhotoLoaderCubit _loader;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    roverInfo.photos.shuffle();
    ManifestPhotoEntry entry =
        roverInfo.photos.firstWhere((element) => element.totalPhotos > 10);
    _loader = NasaPhotoLoaderCubit()..fetchNasaRoverPhotos(rover, entry.sol);
    return Stack(
      children: [
        SingleChildScrollView(
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: size.height * 0.5,
                child: Hero(
                  tag: roverInfo.name,
                  child: Image.asset(
                    "images/${roverInfo.name.toLowerCase()}.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.45),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 4, 20, 32),
                    borderRadius: BorderRadius.circular(50)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              height: 10,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: size.width * 0.30,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  )
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              roverInfo.name,
                              style: const TextStyle(
                                fontFamily: 'Avenir',
                                fontSize: 36,
                                color: _primaryTextColor,
                                fontWeight: FontWeight.w900,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          const Divider(color: Colors.black38),
                          const SizedBox(height: 32),
                          DescriptionEntry(
                              title:
                                  AppLocalizations.of(context)!.launchingDate,
                              description:
                                  _dateTimeToString(roverInfo.launchDate)),
                          DescriptionEntry(
                              title: AppLocalizations.of(context)!.landingDate,
                              description:
                                  _dateTimeToString(roverInfo.landingDate)),
                          DescriptionEntry(
                              title: AppLocalizations.of(context)!.status,
                              description: roverInfo.status.name),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MaterialButton(
                          color: const Color.fromARGB(155, 230, 115, 70),
                          onPressed: () {
                            Navigator.of(context).push(
                              // MaterialPageRoute(

                              //   builder: (_) => TextFieldExample(
                              //     rover: roverInfo.name.toLowerCase(),

                              //   ),
                              //),
                              PageTransition(
                                child: TextFieldExample(
                                    rover: rover, manifest: roverInfo),
                                type: PageTransitionType.rightToLeft,
                                childCurrent: this,
                                duration: const Duration(milliseconds: 200),
                              ),
                            );
                          },
                          child: Row(children: const [
                            Icon(Icons.newspaper),
                            Text(
                              "Learn more",
                              style: TextStyle(fontFamily: 'ChakraPetch'),
                            )
                          ]),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 32.0),
                      child: Text(
                        'Gallery',
                        style: TextStyle(
                          fontFamily: 'ChakraPetch-Light',
                          fontSize: 28,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: BlocBuilder<NasaPhotoLoaderCubit,
                              LoaderState<NasaRoverPhotos>>(
                          bloc: _loader,
                          builder: (context, state) {
                            if (_loader.isLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (_loader.isFailed) {
                              return const Center(
                                child: Text(
                                  "Something went wrong",
                                  style: TextStyle(color: _primaryTextColor),
                                ),
                              );
                            }
                            NasaRoverPhotos result =
                                (state as Loaded<NasaRoverPhotos>).loaded;
                            int baseIndex = result.photos.length <= 5
                                ? 0
                                : math.Random()
                                    .nextInt(result.photos.length - 5);
                            result.photos.shuffle();
                            return ListView.builder(
                                itemCount: math.min(5, result.photos.length),
                                scrollDirection: Axis
                                    .horizontal, // make list scroll horizontal
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      child: AspectRatio(
                                          aspectRatio: 1,
                                          child: Image.network(
                                            result
                                                .photos[baseIndex + index].image
                                                .toString(),
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                  );
                                });
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          child: SizedBox(
            width: 50,
            child: AspectRatio(
              aspectRatio: 1,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: SvgPicture.asset(
                  "images/back_arrow3.svg",
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DescriptionEntry extends StatelessWidget {
  final String title, description;
  const DescriptionEntry(
      {Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: 20,
                  color: _primaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Text(
                description,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: 20,
                  color: _primaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        const Divider(color: Colors.black38),
      ],
    );
  }
}
