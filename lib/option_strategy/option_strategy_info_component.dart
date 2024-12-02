import 'package:flutter/material.dart';

class OptionStrategyInfoComponent extends StatelessWidget {
  const OptionStrategyInfoComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      RowEntryWidget(
          leftChild: Text("Profit",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              )),
          rightChild: Text("12,000",
              style: TextStyle(
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.w700,
              ))),
      const SizedBox(height: 16),
      RowEntryWidget(
          leftChild: Text("Break Even",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              )),
          rightChild: Text("6000",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ))),
      const SizedBox(height: 16),
      RowEntryWidget(
          leftChild: Text("Loss",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              )),
          rightChild: Text("6000",
              style: TextStyle(
                fontSize: 14,
                color: Colors.red,
                fontWeight: FontWeight.w700,
              ))),
      const SizedBox(height: 28),
      RowEntryWidget(
          leftChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("ADANIPORTS",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  )),
              Text("₹25,032.00",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ))
            ],
          ),
          rightChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("1 day change",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  )),
              Text("+17.70 (0.07%)",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.w400,
                  ))
            ],
          )),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            border: Border.all(color: const Color(0xF9B0CCE2), width: 1)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RowEntryWidget(
                leftChild: Text("Strike 24700 B",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )),
                rightChild: Text("Premium 1460.0",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ))),
            SizedBox(height: 16),
            RowEntryWidget(
                leftChild: Text("Strike 24700 S",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )),
                rightChild: Text("Premium 1460.0",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ))),
          ],
        ),
      )
    ]);
  }
}

class RowEntryWidget extends StatelessWidget {
  final Widget leftChild;
  final Widget rightChild;
  const RowEntryWidget(
      {super.key, required this.leftChild, required this.rightChild});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [leftChild, rightChild],
    );
  }
}
