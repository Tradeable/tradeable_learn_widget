import 'package:flutter/material.dart';

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

class TradeTypeModel {
  final TradeType tradeType;
  final bool isLocked;
  final List<ExecutionTypeModel> executionTypes;

  TradeTypeModel(
      {required this.tradeType,
      required this.isLocked,
      required this.executionTypes});
}

class ExecutionTypeModel {
  final ExecutionType executionType;
  final bool isLocked;

  ExecutionTypeModel({required this.executionType, required this.isLocked});
}

class TradeTakerWidget extends StatefulWidget {
  final List<TradeTypeModel> tradeTypes;
  const TradeTakerWidget({super.key, required this.tradeTypes});

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
  double quantity = 1;

  String selectedOrderType = 'Market';
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        topBar(),
        TabBar(
          padding: const EdgeInsets.all(1),
          controller: _innerTabController,
          labelPadding: const EdgeInsets.symmetric(vertical: 10),
          indicatorColor: const Color(0xFFE41E26),
          labelColor: const Color(0xFFE41E26),
          unselectedLabelColor: Colors.grey,
          tabs: [
            ...widget.tradeTypes[_outerTabController.index].executionTypes
                .map((element) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(element.executionType.name),
                  element.isLocked ? const Icon(Icons.lock) : Container()
                ],
              );
            })
          ],
        ),
        form()
      ],
    );
  }

  Widget topBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Strike',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          Text(
            instrument,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
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
                  color: const Color(0xFFE41E26),
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  border: Border.all(color: const Color(0xFFE41E26))),
              labelPadding: const EdgeInsets.symmetric(vertical: 8),
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFFE41E26),
              tabs: [
                ...widget.tradeTypes.map((element) {
                  return Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(element.tradeType.name),
                        element.isLocked ? const Icon(Icons.lock) : Container()
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
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Order Type"),
          const SizedBox(
            height: 16,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildOrderTypeTab('Market'),
                _buildOrderTypeTab('Limit'),
                _buildOrderTypeTab('SL/TG'),
                _buildOrderTypeTab('SL Limit'),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quantity to trade',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              SizedBox(
                width: 80,
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
                    if (newValue != null && newValue >= 1 && newValue <= 10) {
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
            activeColor: const Color(0xFFE41E26),
            onChanged: (value) {
              setState(() {
                quantity = value;
                _quantityController.text = value.toInt().toString();
              });
            },
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Market Price',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 180,
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
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Validity',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Row(
                children: [
                  _buildValidityOption('Day'),
                  const SizedBox(width: 8),
                  _buildValidityOption('IOC'),
                  // const SizedBox(width: 8),
                  // _buildValidityOption('Mis'),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildOrderTypeTab(String text) {
    final isSelected = selectedOrderType == text;
    return GestureDetector(
      onTap: () => setState(() => selectedOrderType = text),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE41E26) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildValidityOption(String text) {
    final isSelected = selectedValidity == text;
    return GestureDetector(
      onTap: () => setState(() => selectedValidity = text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE41E26) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget marketToggle() {
    return Row(
      children: [
        Radio(
          value: true,
          groupValue: isNSE,
          onChanged: (value) {
            setState(() => isNSE = value as bool);
          },
          activeColor: const Color(0xFFE41E26),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        const Text('NSE'),
        Radio(
          value: false,
          groupValue: isNSE,
          onChanged: (value) {
            setState(() => isNSE = value as bool);
          },
          activeColor: const Color(0xFFE41E26),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        const Text('BSE'),
      ],
    );
  }

  Widget buySellToggle() {
    return Row(
      children: [
        Text(
          'BUY',
          style: TextStyle(
            color: !isSell ? const Color(0xFFE41E26) : Colors.grey,
            fontWeight: !isSell ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(width: 8),
        Container(
            width: 50,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Switch(
                inactiveThumbColor: Colors.white,
                value: isSell,
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
        Text(
          'SELL',
          style: TextStyle(
            color: isSell ? const Color(0xFFE41E26) : Colors.grey,
            fontWeight: isSell ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
