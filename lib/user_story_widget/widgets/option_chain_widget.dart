import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/user_story_widget/models/option_chain_model.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/trade_bottom_sheet.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class OptionsDataWidget extends StatefulWidget {
  final Options data;
  final Function(OptionEntry?, String) onRowSelected;
  final OptionEntry? selectedOptionEntry;

  const OptionsDataWidget({
    super.key,
    required this.data,
    required this.onRowSelected,
    this.selectedOptionEntry,
  });

  @override
  State<StatefulWidget> createState() => _OptionsDataWidget();
}

class _OptionsDataWidget extends State<OptionsDataWidget> {
  int? selectedRow;
  OptionEntry? selectedRowObject;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              _buildTopLabel('CALL'),
              const Spacer(flex: 2),
              _buildTopLabel('PUT'),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildHeader('Premium')),
              Expanded(child: _buildHeader('Strike')),
              Expanded(child: _buildHeader('Premium')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildDataColumn(
                    data: widget.data.call.entries, isCallColumn: true),
              ),
              Expanded(
                child: _buildStrikeColumn(
                  entries: widget.data.call.entries,
                  backgroundColor: colors.buttonColor,
                ),
              ),
              Expanded(
                child: _buildDataColumn(
                    data: widget.data.put.entries, isCallColumn: false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopLabel(String text) {
    final textStyles = Theme.of(context).customTextStyles;
    return Text(text, style: textStyles.mediumNormal);
  }

  Widget _buildHeader(String text) {
    final textStyles = Theme.of(context).customTextStyles;
    return Container(
      alignment: Alignment.center,
      child: Text(text, style: textStyles.smallNormal),
    );
  }

  Widget _buildDataColumn({
    required List<OptionEntry> data,
    required bool isCallColumn,
  }) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;
    int halfLength = data.length ~/ 2;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        data.length,
        (entryIndex) {
          final entry = data[entryIndex];
          final isFirstHalf = entryIndex < halfLength;

          Color backgroundColor = isCallColumn
              ? (isFirstHalf ? const Color(0xffEFDCE4) : colors.buttonColor)
              : (isFirstHalf ? colors.buttonColor : const Color(0xffEFDCE4));

          bool isSelected = selectedRow == entryIndex;

          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedRow = isSelected ? null : entryIndex;
                    selectedRowObject = isSelected ? null : entry;
                  });
                },
                child: Container(
                  color: backgroundColor,
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      if (!widget.data.showValues) const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (!isCallColumn)
                            _buildBuySellButton(
                                isSelected, false, isCallColumn, entry),
                          Expanded(
                            child: Center(
                              child: Text(
                                entry.premium.toStringAsFixed(
                                  entry.premium.toString().endsWith('.0')
                                      ? 0
                                      : 2,
                                ),
                                style: textStyles.smallNormal.copyWith(
                                  color: colors.axisColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          if (isCallColumn)
                            _buildBuySellButton(
                                isSelected, false, isCallColumn, entry),
                        ],
                      ),
                      if (!widget.data.showValues) const SizedBox(height: 14),
                    ],
                  ),
                ),
              ),
              if (widget.data.showValues)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRow = isSelected ? null : entryIndex;
                      selectedRowObject = isSelected ? null : entry;
                    });
                  },
                  child: Container(
                    color: backgroundColor,
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!isCallColumn)
                          _buildBuySellButton(
                              isSelected, true, isCallColumn, entry),
                        Expanded(
                          child: Center(
                            child: Text(
                              entry.value.toStringAsFixed(
                                entry.value.toString().endsWith('.0') ? 0 : 2,
                              ),
                              style: textStyles.smallNormal.copyWith(
                                color: colors.textColorSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        if (isCallColumn)
                          _buildBuySellButton(
                              isSelected, true, isCallColumn, entry),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBuySellButton(
      bool isSelected, bool isValue, bool isCallColumn, OptionEntry entry) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;
    if (!isSelected) return const SizedBox.shrink();

    String label = isValue ? 'SELL' : 'BUY';
    Color color = isValue ? colors.bearishColor : colors.bullishColor;

    bool isButtonEnabled = isValue ? entry.isSellEnabled : entry.isBuyEnabled;

    return InkWell(
      onTap: isButtonEnabled
          ? () {
              showModalBottomSheet(
                context: context,
                builder: (context) => TradeBottomSheet(
                  confirmOrder: (quantity) {
                    setState(() {
                      entry.isBuy = label == 'BUY';
                      entry.isCallTrade = isCallColumn;
                    });
                    widget.onRowSelected(entry, quantity);
                    setState(() {
                      selectedRow = null;
                    });
                  },
                ),
              );
            }
          : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: isButtonEnabled ? color : color.withOpacity(0.5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: textStyles.smallNormal
              .copyWith(fontSize: 12)
              .copyWith(color: colors.buttonColor),
        ),
      ),
    );
  }

  Widget _buildStrikeColumn({
    required List<OptionEntry> entries,
    required Color backgroundColor,
  }) {
    final textStyles = Theme.of(context).customTextStyles;

    return Container(
      color: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          entries.length,
          (index) => GestureDetector(
            onTap: () {
              setState(() {
                selectedRow = selectedRow == index ? null : index;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
              alignment: Alignment.center,
              child: Text(
                entries[index].strike.toStringAsFixed(2),
                style: textStyles.smallNormal.copyWith(fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
