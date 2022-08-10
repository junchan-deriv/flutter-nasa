import 'package:flutter/material.dart';

class TextFieldExample extends StatefulWidget {
  final String rover;
  const TextFieldExample({Key? key, required this.rover}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<TextFieldExample> {
  // Initial Selected Value
  String dropdownvalue = 'Item 1';

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  @override
  Widget build(BuildContext context) {
    final TextStyle whiteText = Theme.of(context)
        .primaryTextTheme
        .apply(bodyColor: Colors.black)
        .bodyMedium!;
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Flutter TextField Example'),
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
        child: DefaultTextStyle(
          style: whiteText,
          child: SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Container(
                      color: Colors.white.withAlpha(180),
                      child: Wrap(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(15),
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
                                      child: DropdownButton(
                                          // Initial Value
                                          value: dropdownvalue,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          isExpanded: true,
                                          // Down Arrow Icon
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          // Array list of items
                                          items: items.map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child:
                                                  Text(items, style: whiteText),
                                              alignment: Alignment.center,
                                            );
                                          }).toList(),
                                          // After selecting the desired option,it will
                                          // change button value to selected value
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              dropdownvalue = newValue!;
                                            });
                                          }),
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.all(15),
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
                                      child: DropdownButton(
                                          // Initial Value
                                          value: dropdownvalue,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          isExpanded: true,
                                          // Down Arrow Icon
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),

                                          // Array list of items
                                          items: items.map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child:
                                                  Text(items, style: whiteText),
                                              alignment: Alignment.center,
                                            );
                                          }).toList(),
                                          // After selecting the desired option,it will
                                          // change button value to selected value
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              dropdownvalue = newValue!;
                                            });
                                          }),
                                    ),
                                  ),
                                ],
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                textColor: Colors.white,
                                color: Colors.blue,
                                child: Text('ENTER'),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.pink.withAlpha(200),
                          borderRadius: BorderRadius.circular(20.0)),
                      height: 200,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.yellow.withAlpha(200),
                          borderRadius: BorderRadius.circular(20.0)),
                      height: 200,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withAlpha(200),
                          borderRadius: BorderRadius.circular(20.0)),
                      height: 200,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.orange.withAlpha(200),
                          borderRadius: BorderRadius.circular(20.0)),
                      height: 200,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.lime.withAlpha(200),
                          borderRadius: BorderRadius.circular(20.0)),
                      height: 200,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
