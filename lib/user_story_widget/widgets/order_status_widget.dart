import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/horizontal_line_question/horizontal_line_model.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class OrderStatusWidget extends StatefulWidget {
  final String limitPrice;
  final String quantity;
  final HorizontalLineModel model;

  const OrderStatusWidget(
      {super.key,
      required this.limitPrice,
      required this.quantity,
      required this.model});

  @override
  State<OrderStatusWidget> createState() => _OrderStatusWidgetState();
}

class _OrderStatusWidgetState extends State<OrderStatusWidget> {
  String profit = "00";
  String loss = "00";

  @override
  void initState() {
    super.initState();
    _loadAllCandles();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.borderColorSecondary)),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text("BANKNIFTY2500123CE", style: textStyles.mediumBold),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow("Market Price: ", widget.limitPrice, context),
                  const SizedBox(height: 6),
                  _buildRow("Quantity: ", widget.quantity, context),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildRow("Profit: ", profit, context,
                      color: colors.bullishColor),
                  const SizedBox(height: 6),
                  _buildRow("Loss: ", loss, context,
                      color: colors.bearishColor),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, BuildContext context,
      {Color? color}) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    return Row(
      children: [
        Text(
          label,
          style:
              textStyles.smallNormal.copyWith(color: colors.textColorSecondary),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: textStyles.smallBold
              .copyWith(color: color ?? colors.axisColor, fontSize: 16),
        ),
      ],
    );
  }

  void _loadAllCandles() async {
    double limitPrice = double.parse(widget.limitPrice);
    double quantity = double.parse(widget.quantity);

    for (int i = 0; i < widget.model.candles.length; i++) {
      final candle = widget.model.candles[i];
      double closePrice = candle.close;

      double diff = closePrice - limitPrice;
      double profitOrLoss = diff * quantity;

      if (profitOrLoss >= 0) {
        setState(() {
          profit = profitOrLoss.toStringAsFixed(2);
          loss = "00";
        });
      } else {
        setState(() {
          loss = profitOrLoss.toStringAsFixed(2);
          profit = "00";
        });
      }

      await Future.delayed(
          Duration(milliseconds: widget.model.candleSpeed ?? 50));
    }
  }
}
