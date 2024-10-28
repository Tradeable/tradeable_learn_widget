import 'package:flutter/material.dart';

class OptionEduCornerScene extends StatelessWidget {
  final Animation<double> animation;
  final bool toggleValue;
  final double speedMultiplier;
  final List<int> strikePrices;
  final List<double> values;
  final List<int> carValues;
  final String modelType;

  const OptionEduCornerScene(
      {super.key,
      required this.animation,
      required this.toggleValue,
      required this.speedMultiplier,
      required this.strikePrices,
      required this.values,
      required this.carValues,
      required this.modelType});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double animationValue = animation.value * 2 * screenWidth;

    final double buildingOffset = toggleValue
        ? -animationValue * speedMultiplier % screenWidth
        : (animationValue) % screenWidth;

    final double roadWidth = screenWidth * 2;
    final double roadSegment = roadWidth / (strikePrices.length);
    final double currentRoadOffset = animation.value * roadWidth;

    int strikePriceIndex = (currentRoadOffset / roadSegment).round();
    strikePriceIndex = strikePriceIndex.clamp(0, strikePrices.length - 1);

    final double centeredCarOffset = (screenWidth - roadSegment) / 2;

    List<String> btexts = ["OTM", "OTM", "ATM", "ITM", "ITM", "ITM"];
    return Stack(
      children: [
        Positioned(
            left: buildingOffset,
            bottom: 50,
            child: Image.asset(
              "assets/delta_tree.png",
              package: 'tradeable_learn_widget/lib',
              height: 160,
            )),
        Positioned(
          left: (screenWidth - 100) / 2,
          bottom: 50,
          child: Transform(
            alignment: Alignment.center,
            transform:
                toggleValue ? Matrix4.identity() : Matrix4.rotationY(3.14159),
            child: Image.asset(
              "assets/delta_car.png",
              package: 'tradeable_learn_widget/lib',
              height: 40,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 120,
          child: Center(
            child: Column(
              children: [
                modelType == "Vega"
                    ? Container()
                    : Container(
                        width: 70,
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xff373740),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8)),
                        ),
                        child: Center(
                          child: Text(
                            modelType == "Delta"
                                ? "Premium"
                                : modelType == "Gamma"
                                    ? "Delta"
                                    : "",
                            style: const TextStyle(fontSize: 12),
                          ),
                        )),
                Container(
                  width: 70,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: modelType == "Vega"
                        ? BorderRadius.circular(8)
                        : const BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                  ),
                  child: Center(
                    child: Text(
                      carValues[strikePriceIndex].toString(),
                      style: const TextStyle(
                        color: Color(0xffFFCA28),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          left: 0,
          bottom: 40,
          right: 0,
          child: Divider(
            thickness: 5,
            color: Color(0xff91969B),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: -2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(strikePrices.length, (index) {
              final double offsetPosition = roadSegment * index -
                  currentRoadOffset +
                  centeredCarOffset -
                  180;
              return Transform.translate(
                offset: Offset(offsetPosition, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      strikePrices[index].toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    Text(
                      btexts[index].toString(),
                      style: TextStyle(
                          fontSize: 12,
                          color: btexts[index] == "ATM"
                              ? Colors.green
                              : Colors.orange),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(15, (index) {
              double lineHeight = index % 2 == 0 ? 20 : 8;
              return Container(
                width: 2,
                height: lineHeight,
                color: const Color(0xff91969B),
              );
            }),
          ),
        ),
      ],
    );
  }
}
