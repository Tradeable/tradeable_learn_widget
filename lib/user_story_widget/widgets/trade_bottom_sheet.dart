import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:flutter/services.dart';

class TradeBottomSheet extends StatefulWidget {
  final Function(String) confirmOrder;

  const TradeBottomSheet({super.key, required this.confirmOrder});

  @override
  State<StatefulWidget> createState() => _TradeBottomSheet();
}

class _TradeBottomSheet extends State<TradeBottomSheet> {
  final TextEditingController controller = TextEditingController();
  double sliderValue = 0;
  double sliderMaxValue = 500;
  String selectedOrderType = 'Market';
  String selectedValidity = 'Day';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: colors.cardBasicBackground,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Strike",
                      style: textStyles.smallNormal
                          .copyWith(color: colors.textColorSecondary)),
                  Text("BANKNIFTY2500123CE", style: textStyles.mediumBold),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Text("Quantity to Trade", style: textStyles.smallNormal),
                      const Spacer(),
                      SizedBox(
                        width: 180,
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: "Enter quantity",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d+$')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              double newValue = double.tryParse(value) ?? 0;
                              if (newValue > sliderMaxValue) {
                                newValue = sliderMaxValue;
                              }
                              controller.text = newValue.toStringAsFixed(0);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Slider(
                    value: sliderValue.clamp(0, sliderMaxValue),
                    min: 0,
                    max: sliderMaxValue,
                    thumbColor: colors.axisColor,
                    activeColor: colors.axisColor,
                    inactiveColor: colors.borderColorSecondary,
                    divisions: 100,
                    onChanged: (value) {
                      setState(() {
                        sliderValue = value;
                        controller.text = value.toStringAsFixed(0);
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text("Order Type", style: textStyles.smallNormal),
                      const Spacer(),
                      _buildPill('Market'),
                      _buildPill('Limit'),
                      _buildPill('Trigger'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text("Market Price", style: textStyles.smallNormal),
                      const Spacer(),
                      const SizedBox(
                        width: 180,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Market Price",
                            border: OutlineInputBorder(),
                          ),
                          enabled: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text("Validity", style: textStyles.smallNormal),
                      const Spacer(),
                      _buildPill('Day'),
                      _buildPill('GTT'),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          ButtonWidget(
              color: colors.primary,
              btnContent: "Confirm Order",
              onTap: () {
                widget.confirmOrder(controller.text);
                Navigator.of(context).pop();
              })
        ],
      ),
    );
  }

  Widget _buildPill(String label) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    final isSelected = label == selectedOrderType || label == selectedValidity;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (label == 'Market' || label == 'Limit' || label == 'Trigger') {
            selectedOrderType = label;
          } else {
            selectedValidity = label;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          border: Border.all(
              color: isSelected
                  ? colors.axisColor
                  : colors.textColorSecondary.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: textStyles.smallNormal.copyWith(
                color: isSelected
                    ? colors.axisColor
                    : colors.textColorSecondary.withOpacity(0.6))),
      ),
    );
  }
}
