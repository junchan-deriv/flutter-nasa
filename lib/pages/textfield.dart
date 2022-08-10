import 'package:flutter/material.dart';
import 'package:flutter_nasa/models/nasa_manifest.dart';
import 'package:flutter_nasa/states/nasa_photo.dart';
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
  @override
  void initState() {
    super.initState();
    _loader = NasaPhotoLoaderCubit();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle whiteText = Theme.of(context)
        .primaryTextTheme
        .apply(bodyColor: Colors.black)
        .bodyMedium!;
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Flutter TextField Example'),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitHeight,
            image: AssetImage(
              "images/space.gif",
            ),
          ),
        ),
        child: CustomScrollView(slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate((_, __) {
            return Padding(
              padding: const EdgeInsets.all(15),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  color: Colors.white.withAlpha(180),
                  child: Wrap(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text("Sol:"),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
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
                                child: Text("Camera:"),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: DropdownButton<RoverCamera?>(
                                      // Initial Value
                                      value: camera,
                                      borderRadius: BorderRadius.circular(10),
                                      isExpanded: true,
                                      // Down Arrow Icon
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),

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
                                          camera = newValue!;
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
                                    MaterialStateProperty.all(Colors.blue)),
                            child: const Text('ENTER',
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
            );
          }, childCount: 1)),
          SliverGrid(
              delegate: SliverChildBuilderDelegate((ctx, index) {
                return Container(color: Colors.yellow);
              }, childCount: 10),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10)),
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
        ]),
      ),
    );
  }
}
