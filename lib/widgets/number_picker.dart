import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
/// Widget for the number picker withthe -/+ control
///
class NumberPickerWidget extends StatefulWidget {
  final int value;
  final int minValue;
  final int maxValue;
  final String? hint;

  ///
  /// Callback function to be called when the value is actually updated
  ///
  final void Function(int newVal) onUpdated;
  const NumberPickerWidget(
      {Key? key,
      required this.value,
      required this.maxValue,
      required this.onUpdated,
      this.hint = "type your number",
      this.minValue = 0})
      : super(key: key);

  @override
  State<NumberPickerWidget> createState() => _NumberPickerWidgetState();
}

class _NumberPickerWidgetState extends State<NumberPickerWidget> {
  late int value;
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    assert(widget.minValue < widget.maxValue &&
        widget.minValue <= widget.value &&
        widget.maxValue >= widget.value);
    value = widget.value;
    _controller = TextEditingController(text: value.toString());
    _controller.addListener(() {
      //check the value with the rendering
      try {
        //attempt to parse it
        int parsed = int.parse(_controller.text);
        //if it differs, update the UI
        if (parsed != value) {
          setState(() {
            value = parsed;
          });
          //if the value is valid, also propogate to parent
          if (valid) {
            widget.onUpdated(value);
          }
        }
      } catch (e) {
        _controller.text = value.toString();
      }
    });
  }

  //shorthands for dealing with the relationships
  bool get canDecrease => value > widget.minValue;
  bool get canIncrease => value < widget.maxValue;
  bool get valid => widget.minValue <= value && widget.maxValue >= value;

  void _decrease() {
    //if the decrement is possible
    if (canDecrease) {
      setState(() {
        //update and propogate to parent
        value--;
        _controller.text = value.toString();
      });
      widget.onUpdated(value);
    }
  }

  void _increase() {
    //if increment is possible
    if (canIncrease) {
      setState(() {
        //update and propogate to parent
        value++;
        _controller.text = value.toString();
      });
      widget.onUpdated(value);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //the style for the -/+ button
    ButtonStyle style = ButtonStyle(
      textStyle: MaterialStateProperty.all(
        const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    return Row(children: [
      Expanded(
        child: TextButton(
            style: style,
            onPressed: canDecrease ? _decrease : null,
            child: const Text("-",
                style: TextStyle(color: Color.fromARGB(255, 63, 60, 60)))),
      ),
      Expanded(
        flex: 4,
        child: TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          //allow one line digit only input
          inputFormatters: [
            FilteringTextInputFormatter.singleLineFormatter,
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            hintText: widget.hint,
            //show the error text when it is invalid
            errorText: valid
                ? null
                : "The value must be between ${widget.minValue} and ${widget.maxValue}",
          ),
        ),
      ),
      Expanded(
        child: TextButton(
            style: style,
            onPressed: canIncrease ? _increase : null,
            child: const Text("+",
                style: TextStyle(color: Color.fromARGB(255, 63, 60, 60)))),
      ),
    ]);
  }
}
