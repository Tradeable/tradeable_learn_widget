import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tradeable_learn_widget/user_story_widget/models/contracts_model.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class ContractsInfoWidget extends StatelessWidget {
  final ContractDetailsModel model;
  final VoidCallback moveToNextStep;

  const ContractsInfoWidget(
      {super.key, required this.model, required this.moveToNextStep});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Text(model.title,
                style: textStyles.smallNormal
                    .copyWith(color: colors.textColorSecondary)),
          ),
          const Divider(thickness: 1),
          ...model.contractDetails.asMap().entries.map(
                (entry) => ContractDetailsView(
                    detail: entry.value,
                    tableIndex: entry.key,
                    moveToNextStep: moveToNextStep),
              ),
        ],
      ),
    );
  }
}

class ContractDetailsView extends StatefulWidget {
  final ContractDetail detail;
  final int tableIndex;
  final VoidCallback moveToNextStep;

  const ContractDetailsView(
      {super.key,
      required this.detail,
      required this.tableIndex,
      required this.moveToNextStep});

  @override
  State<StatefulWidget> createState() => _ContractDetailsView();
}

class _ContractDetailsView extends State<ContractDetailsView> {
  late ContractDetail _detail;
  DateTime? _currentDate;
  late DateTime _startDate;
  late DateTime _endDate;
  late int _totalDays;
  late int _totalWeeks;

  @override
  void didUpdateWidget(covariant ContractDetailsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.detail != oldWidget.detail) {
      _detail = widget.detail;
      if (_detail.shouldAnimate ?? false) {
        if (widget.detail.shouldAnimate != oldWidget.detail.shouldAnimate) {
          startAnimation();
        }
      } else {
        setState(() {
          _currentDate = null;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _detail = widget.detail;
    _startDate = _parseDate(_detail.timeline.split(' to ')[0]);
    _endDate = _parseDate(_detail.timeline.split(' to ')[1]);

    _totalDays = _endDate.difference(_startDate).inDays;
    _totalWeeks = ((_totalDays / 7).ceil());

    if (_detail.shouldAnimate ?? false) {
      _currentDate = _startDate;
      startAnimation();
    }
  }

  void startAnimation() async {
    setState(() {
      _currentDate = _startDate;
    });

    int totalDays = _endDate.difference(_startDate).inDays;
    int loopLimit = (_detail.isPartiallyAnimated ?? false)
        ? (totalDays / 2).ceil()
        : totalDays;

    int counter = 0;
    do {
      await Future.delayed(Duration(
          milliseconds:
              _detail.timeFrame.toLowerCase().contains("month") ? 50 : 500));
      setState(() {
        _currentDate = _currentDate!.add(const Duration(days: 1));
      });
      counter++;
    } while (counter < loopLimit);

    if (!(_detail.isPartiallyAnimated ?? false) && _currentDate == _endDate) {
      widget.moveToNextStep();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: colors.cardBasicBackground,
        border: Border.all(color: colors.buttonBorderColor),
        boxShadow: [
          BoxShadow(
            color: colors.textColorSecondary,
            blurRadius: 0.5,
            offset: const Offset(1, 0.4),
          )
        ],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(_detail.ticker,
                  style: textStyles.smallNormal
                      .copyWith(color: getTextColor(_detail.isDisabled))),
              const SizedBox(width: 10),
              Text(_detail.timeFrame,
                  style: textStyles.smallBold
                      .copyWith(color: getTextColor(_detail.isDisabled))),
              const Spacer(),
              Text(_detail.timeline,
                  style: textStyles.smallNormal.copyWith(
                      color: getTextColor(_detail.isDisabled), fontSize: 12)),
            ],
          ),
          _detail.isExpanded
              ? Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: colors.borderColorSecondary),
                      ),
                      child: Row(
                        children: [
                          ...List.generate(
                            _detail.timeFrame.toLowerCase().contains("month")
                                ? _totalWeeks
                                : _totalDays + 1,
                            (index) {
                              String displayText;
                              DateTime currentDay;

                              if (_detail.timeFrame
                                  .toLowerCase()
                                  .contains("month")) {
                                currentDay =
                                    _startDate.add(Duration(days: index * 7));
                                int weekNumber =
                                    _getWeekNumberInYear(currentDay);
                                displayText = 'Week$weekNumber';
                              } else {
                                currentDay =
                                    _startDate.add(Duration(days: index));
                                displayText = 'D${currentDay.day}';
                              }

                              bool isBeforeCurrentDate = _currentDate != null &&
                                  currentDay.isBefore(_currentDate!);

                              bool isCurrentDay = _detail.timeFrame
                                      .toLowerCase()
                                      .contains("month")
                                  ? _currentDate != null &&
                                      _getWeekNumberInYear(currentDay) ==
                                          _getWeekNumberInYear(_currentDate!)
                                  : _currentDate != null &&
                                      currentDay.isAfter(_currentDate!
                                          .subtract(const Duration(days: 1))) &&
                                      currentDay.isBefore(_currentDate!
                                          .add(const Duration(days: 1)));

                              return Expanded(
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isBeforeCurrentDate
                                        ? colors.selectedItemColor
                                        : (isCurrentDay
                                            ? colors.selectedItemColor
                                            : null),
                                    border: Border(
                                      right: index !=
                                              (_detail.timeFrame
                                                      .toLowerCase()
                                                      .contains("month")
                                                  ? _totalWeeks - 1
                                                  : _totalDays)
                                          ? BorderSide(
                                              color:
                                                  colors.borderColorSecondary)
                                          : const BorderSide(
                                              color: Colors.transparent),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      displayText,
                                      style: textStyles.smallNormal.copyWith(
                                          color: isCurrentDay
                                              ? colors.axisColor
                                              : getTextColor(
                                                  _detail.isDisabled)),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  DateTime _parseDate(String date) {
    return DateFormat('dd-MM-yyyy').parse(date);
  }

  Color getTextColor(bool isDisabled) {
    final colors = Theme.of(context).customColors;
    return isDisabled ? colors.disabledContainer : colors.axisColor;
  }

  int _getWeekNumberInYear(DateTime date) {
    int dayOfYear = int.parse(DateFormat('D').format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }
}
