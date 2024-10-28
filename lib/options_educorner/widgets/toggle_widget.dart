import 'package:flutter/material.dart';

class OptionEducornerToggle extends StatelessWidget {
  final bool toggleValue;
  final ValueChanged<bool> toggleChanged;

  const OptionEducornerToggle({
    super.key,
    required this.toggleValue,
    required this.toggleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'PUT',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Switch(
            value: toggleValue,
            onChanged: toggleChanged,
            activeColor: Colors.green,
            inactiveThumbColor: Colors.orange,
            inactiveTrackColor: Colors.orange.withOpacity(0.4),
          ),
        ),
        const Text(
          'CALL',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
