import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/user_story_widget/models/option_chain_model.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/trade_taker_form.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/utils/trade_taker_widget.dart';

class DeltaOptionChainWidget extends StatefulWidget {
  final OptionData data;
  final Function(OptionEntry?, String) onRowSelected;
  final OptionEntry? selectedOptionEntry;

  const DeltaOptionChainWidget({
    super.key,
    required this.data,
    required this.onRowSelected,
    this.selectedOptionEntry,
  });

  @override
  State<StatefulWidget> createState() => _DeltaOptionChainWidget();
}

class _DeltaOptionChainWidget extends State<DeltaOptionChainWidget> {
  int? selectedRow;
  OptionEntry? selectedRowObject;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildTopLabel("Greeks Option Chain"),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(child: _buildHeader('Delta')),
              Expanded(child: _buildHeader('Call Premium')),
              Expanded(child: _buildHeader('Strike')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildDataColumn(
                    data: widget.data.options.call.entries, isCallColumn: true),
              ),
              Expanded(
                child: _buildDataColumn(
                    data: widget.data.options.put.entries, isCallColumn: false),
              ),
              Expanded(
                child: _buildStrikeColumn(
                  entries: widget.data.options.call.entries,
                  backgroundColor: colors.buttonColor,
                ),
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
          final isMiddleItem = entryIndex == halfLength;
          final backgroundColor = colors.buttonColor;
          final isSelected = selectedRow == entryIndex;

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
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  alignment: Alignment.center,
                  decoration: isMiddleItem
                      ? BoxDecoration(
                          color: backgroundColor,
                          border: Border(
                            top: BorderSide(color: colors.axisColor, width: 1),
                            bottom:
                                BorderSide(color: colors.axisColor, width: 1),
                            left: isCallColumn
                                ? BorderSide(color: colors.axisColor, width: 1)
                                : BorderSide.none,
                          ),
                        )
                      : null,
                  child: Column(
                    children: [
                      if (!widget.data.options.showValues)
                        const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                      if (!widget.data.options.showValues)
                        const SizedBox(height: 14),
                    ],
                  ),
                ),
              ),
              if (widget.data.options.showValues)
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
                    decoration: isMiddleItem
                        ? BoxDecoration(
                            border: Border(
                              top:
                                  BorderSide(color: colors.axisColor, width: 1),
                              bottom:
                                  BorderSide(color: colors.axisColor, width: 1),
                              left: isCallColumn
                                  ? BorderSide(
                                      color: colors.axisColor, width: 1)
                                  : BorderSide.none,
                            ),
                          )
                        : null,
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
                  builder: (context) => TradeTakerForm(
                      model: TradeFormModel(
                          target: "0",
                          stopLoss: "0",
                          quantity: 0,
                          isNse: true,
                          isSell: false,
                          tradeType: TradeType.intraday,
                          orderType: OrderType.market,
                          isCallTrade: entry.isCallTrade = isCallColumn),
                      tradeFormModel: (tf) {
                        setState(() {
                          entry.isBuy = label == 'BUY';
                          entry.isCallTrade = isCallColumn;
                        });
                        widget.onRowSelected(entry, tf.quantity.toString());
                        setState(() {
                          selectedRow = null;
                        });
                      },
                      tradeTypeModel: widget.data.tradeTypeModel ?? []));
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
    final colors = Theme.of(context).customColors;

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
              decoration: index == entries.length ~/ 2
                  ? BoxDecoration(
                      border: Border(
                        top: BorderSide(color: colors.axisColor, width: 1),
                        bottom: BorderSide(color: colors.axisColor, width: 1),
                        right: BorderSide(color: colors.axisColor, width: 1),
                      ),
                    )
                  : null,
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
