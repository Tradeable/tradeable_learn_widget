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
      tradeTypes: widget.rrModel.tradeTypeModel ?? [],
      tradeForm: (tradeFormModel) {
        widget.tradeFormModel(tradeFormModel);
      },
    );
  }
}
