import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/rr_widget/rr_model.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

enum TradeType { intraday, delivery }

extension TradeTypeExtension on TradeType {
  String get name {
    switch (this) {
      case TradeType.intraday:
        return 'INTRADAY';
      case TradeType.delivery:
        return 'DELIVERY';
    }
  }
}

enum ExecutionType { regular, amo, cover, iceberg }

extension ExecutionTypeExtension on ExecutionType {
  String get name {
    switch (this) {
      case ExecutionType.regular:
        return 'Regular';
      case ExecutionType.amo:
        return 'AMO';
      case ExecutionType.cover:
        return "Cover";
      case ExecutionType.iceberg:
        return "Iceberg";
    }
  }
}

enum OrderType { market, limit, sltg }

extension OrderTypeExtension on OrderType {
  String get name {
    switch (this) {
      case OrderType.market:
        return 'Market';
      case OrderType.limit:
        return 'Limit';
      case OrderType.sltg:
        return 'SL/TG';
    }
  }
}

class TradeTypeModel {
  final TradeType tradeType;
  final bool isLocked;
  final List<ExecutionTypeModel> executionTypes;

  TradeTypeModel(
      {required this.tradeType,
      required this.isLocked,
      required this.executionTypes});

  factory TradeTypeModel.fromJson(Map<String, dynamic> json) {
    return TradeTypeModel(
      tradeType: TradeType.values
          .firstWhere((e) => e.toString() == 'TradeType.${json['tradeType']}'),
      isLocked: json['isLocked'] as bool,
      executionTypes: (json['executionTypes'] as List<dynamic>)
          .map((e) => ExecutionTypeModel.fromJson(e))
          .toList(),
    );
  }
}

class ExecutionTypeModel {
  final ExecutionType executionType;
  final bool isLocked;
  final List<OrderTypeModel> orderTypes;

  ExecutionTypeModel(
      {required this.executionType,
      required this.isLocked,
      required this.orderTypes});

  factory ExecutionTypeModel.fromJson(Map<String, dynamic> json) {
    return ExecutionTypeModel(
      executionType: ExecutionType.values.firstWhere(
          (e) => e.toString() == 'ExecutionType.${json['executionType']}'),
      isLocked: json['isLocked'] as bool,
      orderTypes: (json['orderTypes'] as List<dynamic>)
          .map((e) => OrderTypeModel.fromJson(e))
          .toList(),
    );
  }
}

class OrderTypeModel {
  final OrderType orderType;
  final bool isLocked;

  OrderTypeModel({required this.orderType, required this.isLocked});

  factory OrderTypeModel.fromJson(Map<String, dynamic> json) {
    return OrderTypeModel(
      orderType: OrderType.values
          .firstWhere((e) => e.toString() == 'OrderType.${json['orderType']}'),
      isLocked: json['isLocked'] as bool,
    );
  }
}

class TradeFormModel {
  String target;
  String stopLoss;
  int quantity;
  bool isNse;
  bool isSell;
  TradeType tradeType;
  String? avgPrice;
  String? ltp;
  OrderType orderType;
  bool isCallTrade;

  TradeFormModel(
      {required this.target,
      required this.stopLoss,
      required this.quantity,
      required this.isNse,
      required this.isSell,
      required this.tradeType,
      this.avgPrice,
      this.ltp,
      required this.orderType,
      required this.isCallTrade});
}

class TradeTakerWidget extends StatefulWidget {
  final RRModel model;
  final List<TradeTypeModel> tradeTypes;
  final Function(TradeFormModel) tradeForm;

  const TradeTakerWidget(
      {super.key,
      required this.tradeTypes,
      required this.model,
      required this.tradeForm});

  @override
  State<TradeTakerWidget> createState() => _TradeTakerWidgetState();
}

class _TradeTakerWidgetState extends State<TradeTakerWidget>
    with TickerProviderStateMixin {
  String instrument = "BANKNIFTY250123CE";
  bool isNSE = true;
  double nseValue = 0;
  double bseValue = 0;
  bool isSell = true;

  late final TabController _outerTabController;
  late final TabController _innerTabController;

  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stopLossController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  double quantity = 1;

  OrderType selectedOrderType = OrderType.sltg;
  String selectedValidity = 'Day';

  @override
  void initState() {
    super.initState();
    _outerTabController =
        TabController(length: widget.tradeTypes.length, vsync: this)
          ..addListener(() {
            if (widget.tradeTypes[_outerTabController.index].isLocked) {
              setState(() {
                _outerTabController.animateTo(0);
              });
            }
          });
    _innerTabController = TabController(length: 4, vsync: this)
      ..addListener(() {
        if (widget.tradeTypes[_outerTabController.index]
            .executionTypes[_innerTabController.index].isLocked) {
          setState(() {
            _innerTabController.animateTo(0);
          });
        }
      });

    _quantityController.text = '1';
    _priceController.text = 'At Market';
    _targetController.text = widget.model.rrLayer.target.toStringAsFixed(2);
    _stopLossController.text = widget.model.rrLayer.stoploss.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return Container(
      color: colors.cardBasicBackground,
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  topBar(),
                  TabBar(
                    padding: const EdgeInsets.all(1),
                    controller: _innerTabController,
                    labelPadding: const EdgeInsets.symmetric(vertical: 10),
                    indicatorColor: colors.sliderColor,
                    labelColor: colors.sliderColor,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      ...widget
                          .tradeTypes[_outerTabController.index].executionTypes
                          .map((element) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(element.executionType.name),
                            const SizedBox(width: 4),
                            element.isLocked
                                ? const Icon(Icons.lock, size: 16)
                                : Container()
                          ],
                        );
                      })
                    ],
                  ),
                  form()
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: ButtonWidget(
                color: colors.primary,
                btnContent: "Confirm",
                onTap: () {
                  setState(() {
                    TradeFormModel tradeFormModel = TradeFormModel(
                        target: _targetController.text,
                        stopLoss: _stopLossController.text,
                        quantity: quantity.toInt(),
                        isNse: isNSE,
                        isSell: isSell,
                        tradeType: TradeType.intraday,
                        orderType: selectedOrderType,
                        isCallTrade: true);
                    widget.tradeForm(tradeFormModel);
                  });
                  Navigator.of(context).pop();
                }),
          )
        ],
      ),
    );
  }

  Widget topBar() {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Strike', style: textStyles.smallNormal),
          Text('BANKNIFTY2500123CE', style: textStyles.mediumBold),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [marketToggle(), buySellToggle()],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4)),
            child: TabBar(
              padding: const EdgeInsets.all(1),
              controller: _outerTabController,
              dividerHeight: 0,
              indicator: BoxDecoration(
                  color: colors.sliderColor,
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  border: Border.all(color: colors.sliderColor)),
              labelPadding: const EdgeInsets.symmetric(vertical: 8),
              labelColor: Colors.white,
              unselectedLabelColor: colors.sliderColor,
              tabs: [
                ...widget.tradeTypes.map((element) {
                  return Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(element.tradeType.name),
                        const SizedBox(width: 4),
                        element.isLocked
                            ? const Icon(Icons.lock, size: 20)
                            : Container()
                      ],
                    ),
                  );
                })
                // Center(
                //   child: Text("INTRADAY"),
                // ),
                // Center(
                //   child: Text("DELIVERY"),
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget form() {
    final textStyles = Theme.of(context).customTextStyles;

    final colors = Theme.of(context).customColors;
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Order Type"),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...widget.tradeTypes[_outerTabController.index]
                    .executionTypes[_innerTabController.index].orderTypes
                    .map((orderTypeModel) {
                  return _buildOrderTypeTab(orderTypeModel);
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Quantity to trade', style: textStyles.smallNormal),
              SizedBox(
                width: 120,
                child: TextField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    final newValue = int.tryParse(value);
                    if (newValue != null && newValue >= 1 && newValue <= 100) {
                      setState(() => quantity = newValue.toDouble());
                    }
                  },
                ),
              ),
            ],
          ),
          Slider(
            value: quantity,
            min: 1,
            max: 100,
            divisions: 99,
            activeColor: colors.axisColor,
            onChanged: (value) {
              setState(() {
                quantity = value;
                _quantityController.text = value.toInt().toString();
              });
            },
          ),
          const SizedBox(height: 16),
          getTextFields(selectedOrderType.name),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Validity', style: textStyles.smallNormal),
              Row(
                children: [
                  _buildValidityOption('Day'),
                  const SizedBox(width: 8),
                  _buildValidityOption('IOC'),
                  const SizedBox(width: 8),
                  _buildValidityOption('Minutes'),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildOrderTypeTab(OrderTypeModel orderTypeModel) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    return GestureDetector(
      onTap: orderTypeModel.isLocked
          ? null
          : () => setState(() => selectedOrderType = orderTypeModel.orderType),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selectedOrderType == orderTypeModel.orderType
              ? colors.sliderColor
              : (orderTypeModel.isLocked
                  ? colors.buttonColor.withOpacity(0.5)
                  : colors.buttonColor),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: orderTypeModel.isLocked
                  ? colors.buttonBorderColor.withOpacity(0.5)
                  : colors.buttonBorderColor),
        ),
        child: Row(
          children: [
            Text(
              orderTypeModel.orderType.name,
              style: textStyles.smallNormal.copyWith(
                color: selectedOrderType == orderTypeModel.orderType
                    ? Colors.white
                    : (orderTypeModel.isLocked
                        ? colors.disabledContainer
                        : colors.axisColor),
              ),
            ),
            const SizedBox(width: 4),
            orderTypeModel.isLocked
                ? Icon(Icons.lock, size: 14, color: colors.disabledContainer)
                : Container()
          ],
        ),
      ),
    );
  }

  Widget _buildValidityOption(String text) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    final isSelected = selectedValidity == text;
    return GestureDetector(
      onTap: () => setState(() => selectedValidity = text),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
              color: isSelected ? colors.sliderColor : colors.buttonColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colors.borderColorSecondary)),
          child: Text(text,
              style: textStyles.smallNormal.copyWith(
                  color:
                      isSelected ? Colors.white : colors.textColorSecondary))),
    );
  }

  Widget marketToggle() {
    final colors = Theme.of(context).customColors;

    return Row(
      children: [
        Radio(
          value: true,
          groupValue: isNSE,
          onChanged: (value) {
            setState(() => isNSE = value as bool);
          },
          activeColor: colors.sliderColor,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        const Text('NSE'),
        Radio(
          value: false,
          groupValue: isNSE,
          onChanged: (value) {
            setState(() => isNSE = value as bool);
          },
          activeColor: colors.sliderColor,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        const Text('BSE'),
      ],
    );
  }

  Widget buySellToggle() {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    return Row(
      children: [
        Text('BUY',
            style: textStyles.smallBold.copyWith(
              color: !isSell ? colors.axisColor : colors.textColorSecondary,
              fontWeight: !isSell ? FontWeight.bold : FontWeight.normal,
            )),
        const SizedBox(width: 8),
        Container(
            width: 50,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Switch(
                value: isSell,
                activeTrackColor: colors.sliderColor,
                inactiveThumbColor: colors.cardBasicBackground,
                inactiveTrackColor: colors.bullishColor,
                onChanged: (value) {
                  setState(() {
                    isSell = value;
                  });
                })
            // Stack(
            //   children: [
            //     AnimatedPositioned(
            //       duration: const Duration(milliseconds: 200),
            //       curve: Curves.easeInOut,
            //       left: isSell ? 26 : 0,
            //       child: GestureDetector(
            //         onTap: () => setState(() => isSell = !isSell),
            //         child: Container(
            //           width: 24,
            //           height: 24,
            //           decoration: const BoxDecoration(
            //             shape: BoxShape.circle,
            //             color: Color(0xFFE41E26),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            ),
        const SizedBox(width: 8),
        Text('SELL',
            style: textStyles.smallBold.copyWith(
                color: isSell ? colors.axisColor : colors.textColorSecondary,
                fontWeight: isSell ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget getTextFields(String selectedOrderType) {
    if (selectedOrderType == 'SL/TG') {
      return Column(
        children: [
          Row(
            children: [
              const Text("Target"),
              const Spacer(),
              Container(
                width: 260,
                padding: const EdgeInsets.only(left: 80),
                child: TextField(
                  controller: _targetController,
                  decoration: const InputDecoration(
                    labelText: 'Target',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text("Stop loss"),
              const Spacer(),
              Container(
                width: 260,
                padding: const EdgeInsets.only(left: 80),
                child: TextField(
                  controller: _stopLossController,
                  decoration: const InputDecoration(
                    labelText: 'Stop Loss',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Row(
        children: [
          const Text("Market"),
          const Spacer(),
          Container(
            width: 260,
            padding: const EdgeInsets.only(left: 80),
            child: TextField(
              controller: _priceController,
              enabled: selectedOrderType != 'Market',
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
    }
  }
}
