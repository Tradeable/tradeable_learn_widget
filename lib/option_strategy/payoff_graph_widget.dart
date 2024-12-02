import 'package:flutter/material.dart';

class PayoffGraphWidget extends StatefulWidget {
  const PayoffGraphWidget({super.key});

  @override
  State<PayoffGraphWidget> createState() => _PayoffGraphWidgetState();
}

class _PayoffGraphWidgetState extends State<PayoffGraphWidget> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Test your results by moving the slider below"),
        ],
      ),
    );
  }
}
