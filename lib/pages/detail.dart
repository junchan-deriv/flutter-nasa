import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nasa/models/nasa_manifest.dart';
import 'package:flutter_nasa/pages/textfield.dart';
import 'package:flutter_nasa/states/loader_base.dart';
import 'package:flutter_nasa/states/nasa_manifest.dart';
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
  const _RoverDetail({
    Key? key,
    required this.roverInfo,
  }) : super(key: key);

  final NasaRoverManifest roverInfo;

  @override
  Widget build(BuildContext context) {
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
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    fontSize: 56,
                    color: _primaryTextColor,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  'Solar System',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    fontSize: 31,
                    color: _primaryTextColor,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
                Divider(color: Colors.black38),
                SizedBox(height: 32),
                Text(
                  roverInfo.landingDate.toString(),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    fontSize: 20,
                    color: _contentTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 32),
                Divider(color: Colors.black38),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Text(
              'Gallery',
              style: TextStyle(
                fontFamily: 'Avenir',
                fontSize: 25,
                color: const Color(0xff47455f),
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            height: 250,
            child: ListView.builder(
                itemCount: roverInfo.totalPhotos,
                scrollDirection: Axis.horizontal, // make list scroll horizontal
                itemBuilder: (context, index) {
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(
                          "https://http.cat/101",
                          fit: BoxFit.cover,
                        )),
                  );
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
