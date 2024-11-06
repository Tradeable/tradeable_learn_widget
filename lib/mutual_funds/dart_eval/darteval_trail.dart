import 'package:flutter/material.dart';
import 'package:dart_eval/dart_eval.dart';

class DynamicWidget extends StatefulWidget {
  const DynamicWidget({super.key});

  @override
  State<DynamicWidget> createState() => _DynamicWidgetState();
}

class _DynamicWidgetState extends State<DynamicWidget> {
  final _controller = TextEditingController();
  String result = '';
  double _sliderValue = 0;
  double _minSliderValue = 0;
  double _maxSliderValue = 1;
  List<int> _dropdownItems = [0, 1];
  int? _selectedDropdownValue;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_checkEvenOdd);
  }

  @override
  void dispose() {
    _controller.removeListener(_checkEvenOdd);
    _controller.dispose();
    super.dispose();
  }

  void _checkEvenOdd() {
    final input = int.tryParse(_controller.text);
    if (input == null) {
      setState(() {
        result = '';
        _minSliderValue = 0;
        _maxSliderValue = 1;
        _sliderValue = _minSliderValue;
        _dropdownItems = [0, 1];
        _selectedDropdownValue = null;
      });
      return;
    }

    const evenOddProgram = r'''
      String main(int num) {
        return num % 2 == 0 ? "Even" : "Odd";
      }
    ''';

    const sliderRangeProgram = r'''
      List<dynamic> main(int num) {
        return num % 2 == 0 ? [0.0, 50.0] : [50.0, 100.0];
      }
    ''';

    final evenOddResult = eval(evenOddProgram, function: 'main', args: [input]);
    final rangeResult =
        eval(sliderRangeProgram, function: 'main', args: [input])
            as List<dynamic>;

    setState(() {
      result = evenOddResult.toString();
      _minSliderValue = (rangeResult[0].$value as double);
      _maxSliderValue = (rangeResult[1].$value as double);
      _sliderValue = _minSliderValue;

      _generateDropdownItems(input);
    });
  }

  void _generateDropdownItems(int input) {
    const dropdownItemsProgram = r'''
      List<dynamic> main(int num, int start) {
        List<int> items = [];
        if (num % 2 == 0) {
          for (int i = 0; i < 10; i++) {
            items.add(start + i);
          }
        } else {
          for (int i = 0; i < 5; i++) {
            items.add(start + i);
          }
        }
        return items;
      }
    ''';

    final dropdownResult = eval(dropdownItemsProgram,
        function: 'main', args: [input, _sliderValue.toInt()]) as List<dynamic>;

    setState(() {
      _dropdownItems =
          dropdownResult.map((item) => (item.$value as int)).toList();
      _selectedDropdownValue =
          _dropdownItems.isNotEmpty ? _dropdownItems[0] : null;
    });
  }

  void _updateTextField(int value) {
    _controller.text = value.toString();
    _checkEvenOdd();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Enter a number'),
          ),
          Text('Result: $result', style: const TextStyle(fontSize: 18)),
          Slider(
            value: _sliderValue,
            min: _minSliderValue,
            max: _maxSliderValue,
            divisions: (_maxSliderValue - _minSliderValue).toInt(),
            onChanged: (newValue) {
              setState(() {
                _sliderValue = newValue;
                _generateDropdownItems(int.tryParse(_controller.text) ?? 0);
              });
            },
          ),
          Text('Slider Value: ${_sliderValue.toInt()}'),
          DropdownButton<int>(
            value: _selectedDropdownValue,
            hint: const Text('Select an item'),
            onChanged: (newValue) {
              setState(() {
                _selectedDropdownValue = newValue;
                if (newValue != null) {
                  _updateTextField(newValue);
                }
              });
            },
            items: _dropdownItems.map((item) {
              return DropdownMenuItem<int>(
                value: item,
                child: Text(item.toString()),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
