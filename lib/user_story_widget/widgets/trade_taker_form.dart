import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/rr_widget/rr_model.dart';
import 'package:tradeable_learn_widget/utils/trade_taker_widget.dart';

class TradeTakerForm extends StatefulWidget {
  final RRModel rrModel;
  final Function(TradeFormModel) tradeFormModel;

  const TradeTakerForm(
      {super.key, required this.rrModel, required this.tradeFormModel});

  @override
  State<StatefulWidget> createState() => _TradeTakerForm();
}

class _TradeTakerForm extends State<TradeTakerForm> {
  @override
  Widget build(BuildContext context) {
    return TradeTakerWidget(
      model: widget.rrModel,
      tradeTypes: [
        TradeTypeModel(
            tradeType: TradeType.intraday,
            isLocked: false,
            executionTypes: [
              ExecutionTypeModel(
                  executionType: ExecutionType.regular, isLocked: false),
              ExecutionTypeModel(
                  executionType: ExecutionType.amo, isLocked: true),
              ExecutionTypeModel(
                  executionType: ExecutionType.cover, isLocked: true),
              ExecutionTypeModel(
                  executionType: ExecutionType.iceberg, isLocked: true)
            ]),
        TradeTypeModel(
            tradeType: TradeType.delivery, isLocked: true, executionTypes: []),
      ],
      tradeForm: (tradeFormModel) {
        widget.tradeFormModel(tradeFormModel);
      },
    );
  }
}
