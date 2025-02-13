import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/fno_buy_story/price_decrease_model.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class PriceDecreased extends StatefulWidget {
  final PriceDecreaseModel model;
  final VoidCallback onNextClick;

  const PriceDecreased(
      {super.key, required this.model, required this.onNextClick});

  @override
  State<PriceDecreased> createState() => _PriceDecreasedState();
}

class _PriceDecreasedState extends State<PriceDecreased> {
  late PriceDecreaseModel model;
  String userResponse = "";

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: LayoutBuilder(builder: (context, constraints) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        model.title,
                        style: textStyles.largeBold,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        model.description,
                        style: textStyles.largeNormal,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 80),
                      Text(
                        model.question,
                        style: textStyles.mediumNormal,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        crossAxisSpacing: 20,
                        childAspectRatio: 1 / 0.5,
                        padding: const EdgeInsets.all(10),
                        children: model.options
                            .map(
                              (e) => PriceDecreaseMCQOptions(
                                  option: e,
                                  correctResponse: model.correctResponse,
                                  onTap: (option) {
                                    setState(() {
                                      userResponse = option;
                                    });
                                  },
                                  selectedOption: userResponse),
                            )
                            .toList(),
                      ),
                    ],
                  );
                })),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: ButtonWidget(
              color:
                  userResponse.isNotEmpty ? colors.primary : colors.secondary,
              btnContent: 'Submit',
              onTap: () {
                if (userResponse.isNotEmpty) {
                  widget.onNextClick();
                }
              }),
        ),
      ],
    );
  }
}

class PriceDecreaseMCQOptions extends StatelessWidget {
  final String option;
  final Function(String option) onTap;
  final String? selectedOption;
  final String? correctResponse;
  final AutoSizeGroup? group;

  const PriceDecreaseMCQOptions(
      {super.key,
      required this.option,
      required this.onTap,
      required this.selectedOption,
      this.group,
      this.correctResponse});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(option);
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: selectedOption != ""
                ? selectedOption == option
                    ? correctResponse == option
                        ? Colors.green
                        : const Color(0xFFFF7B20)
                    : correctResponse == option
                        ? Colors.green
                        : const Color(0xFF252A34)
                : const Color(0xFF252A34),
          ),
          child: Center(
            child: AutoSizeText(option,
                group: group,
                maxLines: 1,
                minFontSize: 10,
                maxFontSize: 20,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          )),
    );
  }
}
