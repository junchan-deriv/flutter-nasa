import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nasa/models/nasa_manifest.dart';
import 'package:flutter_nasa/models/nasa_rover_photos.dart';
import 'package:flutter_nasa/states/loader_base.dart';
import 'package:flutter_nasa/states/nasa_photo.dart';
import 'package:flutter_nasa/widgets/master_detail_tablet.dart';
import 'package:flutter_nasa/widgets/network_image.dart';
import 'package:flutter_nasa/widgets/number_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DiscoveryPage extends StatefulWidget {
  final String rover;
  final NasaRoverManifest manifest;
  const DiscoveryPage({Key? key, required this.rover, required this.manifest})
      : super(key: key);

  @override
  State<DiscoveryPage> createState() => _State();
}

class _State extends State<DiscoveryPage> {
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: inTabletView(context)
            ? BackButton(
                onPressed: () => popDetailFromTabletView(context),
              )
            : null,
        title: Text(
          AppLocalizations.of(context)!.discoverMore,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontFamily: 'ChakraPetch',
          ),
        ),
        // foregroundColor: Colors.pink,
        backgroundColor: const Color.fromARGB(255, 36, 24, 24),
        elevation: 22,
        shadowColor: const Color.fromARGB(255, 49, 49, 49),
        shape: const RoundedRectangleBorder(
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
              if (state is! LoaderError) {
                return;
              }
              print((state as LoaderError).error.toString());
              //pop up error message
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(AppLocalizations.of(context)!.errorMessage),
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
                  delegate: _Form(this, loader: _loader),
                ),
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
                          child: Center(
                            child: Text(AppLocalizations.of(context)!.noData),
                          ),
                        ),
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

class _Form extends SliverChildBuilderDelegate {
  _State pageState;
  _Form(this.pageState, {required NasaPhotoLoaderCubit loader})
      : super((context, _) {
          final TextStyle blackText = Theme.of(context)
              .primaryTextTheme
              .apply(bodyColor: Colors.black)
              .bodyMedium!;
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 62, 63, 100).withAlpha(180),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 51, 46, 46)
                          .withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
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
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color.fromARGB(
                                        255, 173, 164, 164)),
                                child: NumberPickerWidget(
                                  maxValue: pageState.widget.manifest.maxSol,
                                  value: pageState.sol,
                                  onUpdated: (val) => pageState.sol = val,
                                ),
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)!.camera,
                                style: const TextStyle(
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
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color.fromARGB(
                                        255, 173, 164, 164)),
                                child: DropdownButton<RoverCamera?>(
                                    // Initial Value
                                    value: pageState.camera,
                                    borderRadius: BorderRadius.circular(10),
                                    isExpanded: true,
                                    // Down Arrow Icon
                                    icon: const Icon(Icons.keyboard_arrow_down),

                                    // Array list of items
                                    items: [null, ...RoverCamera.values]
                                        .map((RoverCamera? item) {
                                      return DropdownMenuItem(
                                        value: item,
                                        alignment: Alignment.center,
                                        child: Text(
                                            item?.name ??
                                                AppLocalizations.of(context)!
                                                    .all,
                                            style: blackText),
                                      );
                                    }).toList(),
                                    // After selecting the desired option,it will
                                    // change button value to selected value
                                    onChanged: (RoverCamera? newValue) {
                                      //this is valid because the form is technically a part of the page
                                      // ignore: invalid_use_of_protected_member
                                      pageState.setState(() {
                                        pageState.camera = newValue;
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
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(155, 230, 115, 70))),
                          child: Text(AppLocalizations.of(context)!.search,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 3, 3, 3))),
                          onPressed: () {
                            loader.fetchNasaRoverPhotos(
                                pageState.widget.rover, pageState.sol,
                                camera: pageState.camera);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          );
        }, childCount: 1);
}
