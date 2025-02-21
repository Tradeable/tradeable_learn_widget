import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/trade_taker_widget.dart';

class TradeTakerForm extends StatefulWidget {
  final TradeFormModel model;
  final List<TradeTypeModel> tradeTypeModel;
  final Function(TradeFormModel) tradeFormModel;

  const TradeTakerForm(
      {super.key, required this.model, required this.tradeFormModel, required this.tradeTypeModel});

  @override
  State<StatefulWidget> createState() => _TradeTakerForm();
}

class _TradeTakerForm extends State<TradeTakerForm> {
  @override
  Widget build(BuildContext context) {
    return TradeTakerWidget(
      model: widget.model,
      tradeTypes: widget.tradeTypeModel,
      tradeForm: (tradeFormModel) {
        widget.tradeFormModel(tradeFormModel);
      },
    );
  }
}
