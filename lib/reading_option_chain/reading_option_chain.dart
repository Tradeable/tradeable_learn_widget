import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/reading_option_chain/option_chain_model.dart';
import 'package:tradeable_learn_widget/reading_option_chain/table.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class ReadingOptionChain extends StatefulWidget {
  final VoidCallback onNextClick;

  const ReadingOptionChain({super.key, required this.onNextClick});

  @override
  State<ReadingOptionChain> createState() => _ReadingOptionChainState();
}

class _ReadingOptionChainState extends State<ReadingOptionChain> {
  OptionChainModel optionChainModel = OptionChainModel();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 4),
                      child: Text(
                        optionChainModel.screenTitle,
                        style: textStyles.largeBold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Calls",
                                  style: textStyles.mediumNormal,
                                ),
                              ),
                              BuildTable(
                                  bgColor: const Color(0xff2ED47A),
                                  nodes: optionChainModel.nodes,
                                  isReversed: false,
                                  currentIndex:
                                      optionChainModel.currentNodeIndex)
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 50),
                          child: Table(
                            columnWidths: const {
                              0: FixedColumnWidth(60.0),
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            border: TableBorder.all(
                              color: colors.axisColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  color: colors.buttonColor.withOpacity(0.3),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                  ),
                                ),
                                children: List.generate(
                                  1,
                                  (index) => TableCell(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Text("Strike",
                                          textAlign: TextAlign.center,
                                          style: textStyles.smallBold),
                                    ),
                                  ),
                                ),
                              ),
                              for (int i = 0; i < 9; i++)
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: colors.cardColorSecondary
                                        .withOpacity(0.2),
                                  ),
                                  children: List.generate(
                                    1,
                                    (index) => TableCell(
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        child: Text(optionChainModel.strikes[i],
                                            textAlign: TextAlign.center,
                                            style: textStyles.smallNormal),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Puts",
                                    style: textStyles.mediumNormal),
                              ),
                              BuildTable(
                                  bgColor: const Color(0xffF7685B),
                                  nodes: optionChainModel.nodes,
                                  isReversed: true,
                                  currentIndex:
                                      optionChainModel.currentNodeIndex)
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 6),
                          width: 20,
                          height: 20,
                          color: colors.buttonColor.withOpacity(0.3),
                        ),
                        Text("In-the-Money options",
                            style: textStyles.mediumNormal)
                      ],
                    ),
                    GestureDetector(
                      onHorizontalDragEnd: (d) {
                        if (d.primaryVelocity! > 0) {
                          setState(() {
                            optionChainModel.goToPreviousNode();
                          });
                        } else if (d.primaryVelocity! < 0) {
                          setState(() {
                            optionChainModel.goToNextNode();
                          });
                        }
                        if (optionChainModel.isFinished) {
                          widget.onNextClick();
                        }
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            children: [
                              Text("Swipe to learn more",
                                  style: textStyles.smallNormal),
                              const SizedBox(height: 10),
                              Container(
                                height: 200,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: colors.cardColorSecondary,
                                      width: 2),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                      optionChainModel
                                          .nodes[
                                              optionChainModel.currentNodeIndex]
                                          .meta,
                                      textAlign: TextAlign.center,
                                      style: textStyles.mediumNormal),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            left: -10,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  optionChainModel.goToPreviousNode();
                                });
                              },
                              icon: const Icon(Icons.arrow_circle_left),
                              color: optionChainModel.currentNodeIndex > 0
                                  ? colors.primary
                                  : colors.cardColorSecondary,
                            ),
                          ),
                          Positioned(
                            right: -10,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  optionChainModel.goToNextNode();
                                  if (optionChainModel.isFinished) {
                                    widget.onNextClick();
                                  }
                                });
                              },
                              icon: const Icon(Icons.arrow_circle_right),
                              color: optionChainModel.currentNodeIndex < 2
                                  ? colors.primary
                                  : colors.cardColorSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: ButtonWidget(
              color: colors.primary,
              btnContent: "Next",
              onTap: () {
                widget.onNextClick();
              }),
        ),
      ],
    );
  }
}
