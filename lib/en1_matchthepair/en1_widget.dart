import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/en1_matchthepair/en1_model.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class EN1 extends StatefulWidget {
  final EN1Model model;
  final VoidCallback onNextClick;

  const EN1({super.key, required this.model, required this.onNextClick});

  @override
  State<EN1> createState() => _EN1State();
}

class _EN1State extends State<EN1> {
  late EN1Model model;

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text("Match the pair",
                          style: textStyles.mediumNormal)),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: model.leftColumn
                                .map(
                                  (e) => LeftColumnItemWidget(
                                    item: e,
                                    onTap: () {
                                      setState(() {
                                        onLeftColumnItemTap(e);
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: model.rightColumn
                                .map(
                                  (e) => RightColumnItemWidget(
                                    item: e,
                                    onTap: () {
                                      setState(() {
                                        onRightColumnItemTap(e);
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 16),
                    child: ButtonWidget(
                        color: model.state == EN1State.isMatching
                            ? colors.secondary
                            : colors.primary,
                        btnContent: "Next",
                        onTap: () {
                          if (model.state == EN1State.submitResponse) {
                            widget.onNextClick();
                          }
                        }),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void onLeftColumnItemTap(LeftColumItem item) {
    if (model.state == EN1State.isMatching) {
      model.selectedItemLeft?.state = ColumnItemState.unselected;
      model.selectedItemRight?.state = ColumnItemState.unselected;
      model.selectedItemLeft = null;
      model.selectedItemRight = null;
      if (item.state == ColumnItemState.selected) {
        item.state = ColumnItemState.unselected;
      } else {
        for (LeftColumItem item in model.leftColumn) {
          if (item.state == ColumnItemState.selected) {
            item.state = ColumnItemState.unselected;
          }
        }
        item.state = ColumnItemState.selected;
      }
      checkAnswer();
    }
  }

  void onRightColumnItemTap(RightColumnItem item) {
    if (model.state == EN1State.isMatching) {
      model.selectedItemRight?.state = ColumnItemState.unselected;
      model.selectedItemLeft?.state = ColumnItemState.unselected;
      model.selectedItemLeft = null;
      model.selectedItemRight = null;
      if (item.state == ColumnItemState.selected) {
        item.state = ColumnItemState.unselected;
      } else {
        for (RightColumnItem item in model.rightColumn) {
          if (item.state == ColumnItemState.selected) {
            item.state = ColumnItemState.unselected;
          }
        }
        item.state = ColumnItemState.selected;
      }
      checkAnswer();
    }
  }

  void checkAnswer() async {
    int correctCount = 0;
    for (LeftColumItem itemL in model.leftColumn) {
      if (itemL.state == ColumnItemState.selected) {
        for (RightColumnItem itemR in model.rightColumn) {
          if (itemR.state == ColumnItemState.selected) {
            if (itemR.item.tags.contains(itemL.text)) {
              itemL.state = ColumnItemState.correct;
              itemR.state = ColumnItemState.correct;
            } else {
              itemL.state = ColumnItemState.incorrect;
              itemR.state = ColumnItemState.incorrect;
              model.selectedItemLeft = itemL;
              model.selectedItemRight = itemR;
              // showError();
            }
          }
        }
      }
      if (itemL.state == ColumnItemState.correct) {
        correctCount++;
      }
    }
    if (correctCount == model.leftColumn.length) {
      setState(() {
        model.isCorrect = true;
        model.state = EN1State.submitResponse;
      });
      //todo
      // finish(widget.node.edges?.first.pathId ?? "finished", model.isCorrect);
    }
  }
}

class LeftColumnItemWidget extends StatelessWidget {
  final LeftColumItem item;
  final VoidCallback onTap;

  const LeftColumnItemWidget(
      {super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    Color shadowColor = colors.borderColorSecondary;
    Color itemColor = colors.cardColorSecondary;
    switch (item.state) {
      case ColumnItemState.unselected:
        shadowColor = colors.cardColorSecondary;
        break;
      case ColumnItemState.selected:
        shadowColor = colors.primary;
        itemColor = colors.borderColorPrimary.withOpacity(0.4);
        break;
      case ColumnItemState.correct:
        shadowColor = colors.bullishColor;
        break;
      case ColumnItemState.incorrect:
        shadowColor = colors.bearishColor;
        break;
    }
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: shadowColor, width: 1),
          color: itemColor.withOpacity(0.2),
        ),
        child: Center(
          child: AutoSizeText(
            item.text,
            maxFontSize: 15,
            minFontSize: 10,
            textAlign: TextAlign.center,
            textScaleFactor: 1,
            style:
                TextStyle(fontWeight: FontWeight.bold, color: colors.primary),
          ),
        ),
      ),
    );
  }
}

class RightColumnItemWidget extends StatelessWidget {
  final RightColumnItem item;
  final VoidCallback onTap;

  const RightColumnItemWidget(
      {super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    Color shadowColor = colors.borderColorSecondary;
    switch (item.state) {
      case ColumnItemState.unselected:
        shadowColor = colors.cardColorSecondary;
        break;
      case ColumnItemState.selected:
        shadowColor = colors.primary;
        break;
      case ColumnItemState.correct:
        shadowColor = colors.bullishColor;
        break;
      case ColumnItemState.incorrect:
        shadowColor = colors.bearishColor;
        break;
    }
    if (item.item.imgSrc.contains("https")) {
      return InkWell(
        onTap: onTap,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        child: Center(
          child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: const HSLColor.fromAHSL(1, 230, 0.1, 0.2).toColor(),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  item.item.imgSrc,
                  width: 100,
                  height: 100,
                ),
              )),
        ),
      );
    } else {
      return InkWell(
        onTap: onTap,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        child: Container(
          height: 40,
          margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: shadowColor, width: 1),
            color: colors.cardColorSecondary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: AutoSizeText(
              item.item.imgSrc,
              maxFontSize: 15,
              minFontSize: 10,
              textAlign: TextAlign.center,
              textScaleFactor: 1,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }
  }
}
