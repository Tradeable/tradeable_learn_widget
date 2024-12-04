import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/options_educorner/options_educorner_container.dart';
import 'package:tradeable_learn_widget/options_educorner/options_educorner_model.dart';
import 'package:tradeable_learn_widget/options_educorner/widgets/gauge_widget.dart';
import 'package:tradeable_learn_widget/options_educorner/widgets/gradient_slider.dart';
import 'package:tradeable_learn_widget/options_educorner/widgets/info_button.dart';
import 'package:tradeable_learn_widget/options_educorner/widgets/play_button.dart';
import 'package:tradeable_learn_widget/options_educorner/widgets/scene_widget.dart';
import 'package:tradeable_learn_widget/options_educorner/widgets/toggle_widget.dart';

class OptionEduCorner extends StatefulWidget {
  final OptionsEduCornerModel model;
  final VoidCallback onNextClick;

  const OptionEduCorner(
      {super.key, required this.model, required this.onNextClick});

  @override
  State<OptionEduCorner> createState() => _OptionEduCornerState();
}

class _OptionEduCornerState extends State<OptionEduCorner>
    with TickerProviderStateMixin {
  late OptionsEduCornerModel model;
  late AnimationController _controller;
  late AnimationController _needleController;
  late Animation<double> _animation;
  late Animation<double> _needleAnimation;
  bool _toggleValue = false;
  bool isPlaying = false;

  List<double> callValues = [];
  List<double> putValues = [];

  @override
  void initState() {
    super.initState();
    model = widget.model;
    switch (model.educornerType) {
      case "Delta":
        callValues = model.callDelta;
        putValues = model.putDelta;
        break;
      case "Gamma":
        callValues = model.callGamma;
        putValues = model.putGamma;
        _toggleValue = true;
        break;
      case "Vega":
        callValues = model.callVega;
        putValues = model.putVega;
        break;
    }

    var a = List.from(callValues);
    var b = List.from(putValues);

    a.sort();
    b.sort();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _needleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _needleAnimation = Tween<double>(
      begin: _toggleValue ? callValues.first : putValues.first,
      end: _toggleValue ? callValues.last : putValues.last,
    ).animate(
      CurvedAnimation(parent: _needleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _needleController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    setState(() {
      isPlaying = true;
      _controller.forward(from: 0);
      _needleController.forward(from: 0);
    });
  }

  void _toggleChanged(bool value) {
    setState(() {
      isPlaying = false;
      _toggleValue = value;
      _controller.stop();
      _needleController.reset();
      _needleAnimation = Tween<double>(
        begin: _toggleValue ? callValues.first : putValues.first,
        end: _toggleValue ? callValues.last : putValues.last,
      ).animate(
        CurvedAnimation(parent: _needleController, curve: Curves.easeInOut),
      );
      _needleController.forward(from: 0);
    });
  }

  void deaccelerate() {
    setState(() {
      isPlaying = false;
      _controller.stop();
      _needleController.reset();
      _needleAnimation = Tween<double>(
        begin: _toggleValue ? callValues.first : putValues.first,
        end: _toggleValue ? callValues.last : putValues.last,
      ).animate(
        CurvedAnimation(parent: _needleController, curve: Curves.easeInOut),
      );
      _needleController.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return OptionsEduCorner(
      title: model.educornerType,
      topSection: OptionEduCornerScene(
        animation: _animation,
        toggleValue: _toggleValue,
        speedMultiplier: (_needleAnimation.value * 2) + 0.5,
        strikePrices: model.strikePrices,
        values: _toggleValue ? callValues : putValues,
        carValues: model.carValues,
        modelType: model.educornerType,
      ),
      middleSection: EduCornerActionsSection(
        firstChild: model.educornerType == "Vega"
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          'Implied Volatilty: ',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        color: const Color(0xff121216),
                        padding: const EdgeInsets.all(8),
                        child: const Text("0.00",
                            style: TextStyle(
                                color: Color(0xffFFCA28),
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          'Vega: ',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        color: const Color(0xff121216),
                        padding: const EdgeInsets.all(8),
                        child: Text(_needleAnimation.value.toStringAsFixed(2),
                            style: const TextStyle(
                                color: Color(0xffFFCA28),
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      )
                    ],
                  ),
                ],
              )
            : OptionEduCornerGaugeWidget(
                needleAnimation: _needleAnimation,
                toggleValue: _toggleValue,
                callValues: callValues,
                putValues: putValues),
        secondChild: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OptionEducornerInfoBtn(
                  assetPath: "assets/info.png",
                  color: const Color(0xff4DC1FF),
                  action: () {},
                ),
                const SizedBox(width: 10),
                PlayButton(onPressed: _startAnimation),
              ],
            ),
            const SizedBox(height: 20),
            model.educornerType == "Delta"
                ? OptionEducornerToggle(
                    toggleValue: _toggleValue,
                    toggleChanged: _toggleChanged,
                  )
                : model.educornerType == "Gamma"
                    ? Row(
                        children: [
                          const SizedBox(
                              width: 100,
                              child: Text(
                                "Change in delta:",
                                style: TextStyle(fontSize: 15),
                              )),
                          Container(
                            color: const Color(0xff121216),
                            padding: const EdgeInsets.all(8),
                            child: Text(
                                model.callDelta[model.callGamma.indexOf(
                                        double.parse(_needleAnimation.value
                                            .toStringAsFixed(2)))]
                                    .toString(),
                                style: const TextStyle(
                                    color: Color(0xffFFCA28),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          )
                        ],
                      )
                    : Container(
                        height: 40,
                        width: 150,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: GradientSlider(
                          onChanged: (value) {
                            if (value == 0) {
                            } else if (value == 1) {
                              _toggleChanged(true);
                            } else if (value == -1) {
                              _toggleChanged(false);
                            }
                          },
                        ))
          ],
        ),
      ),
      explanationSection: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Text("Explanation",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          Container(
            width: double.infinity,
            height: 140,
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xff373740),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return RawScrollbar(
                    thumbVisibility: true,
                    thickness: 8,
                    thumbColor: const Color(0xffFFA726),
                    radius: const Radius.circular(10),
                    child: SingleChildScrollView(
                      child: Text(
                        _toggleValue
                            ? model.explanations[0]
                            : model.explanations[1],
                        softWrap: true,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      onNextPressed: () {
        widget.onNextClick();
        // finish(widget.node.edges?.first.pathId ?? "finished", true);
      },
    );
  }

  List<Widget> buildFixedCounterContainers(String number) {
    String numberStr = number.toString().padLeft(number.toString().length, '0');
    return numberStr.split('').map((digit) {
      return Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xff121216),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          digit,
          style: const TextStyle(
            fontSize: 28,
            color: Color(0xffFFCA28),
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }).toList();
  }
}

class EduCornerActionsSection extends StatelessWidget {
  final Widget firstChild;
  final Widget secondChild;

  const EduCornerActionsSection({
    super.key,
    required this.firstChild,
    required this.secondChild,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          firstChild,
          secondChild,
        ],
      ),
    );
  }
}
