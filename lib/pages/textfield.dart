import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nasa/models/nasa_manifest.dart';
import 'package:flutter_nasa/models/nasa_rover_photos.dart';
import 'package:flutter_nasa/states/loader_base.dart';
import 'package:flutter_nasa/states/nasa_photo.dart';
import 'package:flutter_nasa/widgets/network_image.dart';
import 'package:flutter_nasa/widgets/number_picker.dart';

class TextFieldExample extends StatefulWidget {
  final String rover;
  final NasaRoverManifest manifest;
  const TextFieldExample(
      {Key? key, required this.rover, required this.manifest})
      : super(key: key);

  @override
  State<TextFieldExample> createState() => _State();
}

class _State extends State<TextFieldExample> {
  int sol = 0;
  RoverCamera? camera;
  late NasaPhotoLoaderCubit _loader;
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _loader = NasaPhotoLoaderCubit();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_loader.isLoaded && _loader.haveNextPage) {
        ScrollPosition position = _scrollController.position;
        if (position.pixels >= position.maxScrollExtent * 0.98) {
          _loader.fetchNextPage();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle whiteText = Theme.of(context)
        .primaryTextTheme
        .apply(bodyColor: Colors.black)
        .bodyMedium!;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Discover More',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontFamily: 'ChakraPetch',
          ),
        ),
        // foregroundColor: Colors.pink,
        backgroundColor: Color.fromARGB(255, 36, 24, 24),
        elevation: 22,
        shadowColor: Color.fromARGB(255, 49, 49, 49),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(40))),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitHeight,
            image: AssetImage(
              "images/stars.jpg",
            ),
          ),
        ),
        child: BlocConsumer<NasaPhotoLoaderCubit, LoaderState<NasaRoverPhotos>>(
            bloc: _loader,
            listener: (context, state) {
              if (!_loader.isFailed) {
                return;
              }
              print((state as LoaderError).error.toString());
              //pop up error message
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Error occured"),
              ));
            },
            builder: (context, state) {
              NasaRoverPhotos? photosData;
              if (state is NasaPhotoTransitiveLoading) {
                photosData = state.cached;
              } else if (state is Loaded<NasaRoverPhotos>) {
                photosData = (state).loaded;
              }

              return CustomScrollView(controller: _scrollController, slivers: [
                SliverList(
                    delegate: SliverChildBuilderDelegate((_, __) {
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        decoration: BoxDecoration(
                          color:
                              Color.fromARGB(255, 62, 63, 100).withAlpha(180),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 51, 46, 46)
                                  .withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Wrap(
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        "Sol:",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'ChakraPetch',
                                            fontSize: 25),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Color.fromARGB(
                                                255, 173, 164, 164)),
                                        child: NumberPickerWidget(
                                          maxValue: widget.manifest.maxSol,
                                          value: sol,
                                          onUpdated: (val) => sol = val,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        "Camera :",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'ChakraPetch',
                                            fontSize: 20),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Color.fromARGB(
                                                255, 173, 164, 164)),
                                        child: DropdownButton<RoverCamera?>(
                                            // Initial Value
                                            value: camera,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            isExpanded: true,
                                            // Down Arrow Icon
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down),

                                            // Array list of items
                                            items: [null, ...RoverCamera.values]
                                                .map((RoverCamera? item) {
                                              return DropdownMenuItem(
                                                value: item,
                                                alignment: Alignment.center,
                                                child: Text(item?.name ?? "All",
                                                    style: whiteText),
                                              );
                                            }).toList(),
                                            // After selecting the desired option,it will
                                            // change button value to selected value
                                            onChanged: (RoverCamera? newValue) {
                                              setState(() {
                                                camera = newValue;
                                              });
                                            }),
                                      ),
                                    ),
                                  ],
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Color.fromARGB(
                                                  155, 230, 115, 70))),
                                  child: const Text('ENTER',
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 3, 3, 3))),
                                  onPressed: () {
                                    _loader.fetchNasaRoverPhotos(
                                        widget.rover, sol);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
                  );
                }, childCount: 1)),
                if (photosData != null && photosData.photos.isNotEmpty)
                  SliverGrid(
                    delegate: SliverChildBuilderDelegate((ctx, index) {
                      return AspectRatio(
                        aspectRatio: 16.0 / 9,
                        child: SizedBox(
                            width: 200,
                            child: NetworkImageWidget(
                              url: photosData!.photos[index].image.toString(),
                            )),
                      );
                    }, childCount: photosData.photos.length),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10),
                  ),
                if (photosData != null && photosData.photos.isEmpty)
                  SliverList(
                    delegate: SliverChildBuilderDelegate((_, __) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                            color: Colors.white.withAlpha(200),
                            height: 200,
                            child: const Center(
                                child: Text(
                                    "There is no data for the selected criteria"))),
                      );
                    }, childCount: 1),
                  ),
                if (_loader.isLoading)
                  SliverList(
                    delegate: SliverChildBuilderDelegate((_, __) {
                      return SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(),
                          ],
                        ),
                      );
                    }, childCount: 1),
                  )
              ]);
            }),
      ),
    );
  }
}
