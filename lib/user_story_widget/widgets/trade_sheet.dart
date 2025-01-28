import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tradeable_learn_widget/user_story_widget/user_story_data_model.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class TradeSheet extends StatefulWidget {
  final Map<int, List<RowData>> tableRowDataMap;
  final Function(RowData)? onRowDataSelected;
  final VoidCallback moveNext;

  const TradeSheet({
    super.key,
    required this.tableRowDataMap,
    this.onRowDataSelected,
    required this.moveNext,
  });

  @override
  State<TradeSheet> createState() => _TradeSheetState();
}

class _TradeSheetState extends State<TradeSheet> {
  bool isNotificationChecked = false;
  bool isAutoExecutionChecked = false;
  String? selectedBidPrice;
  int? selectedTableIndex;
  TextEditingController controller = TextEditingController();
  double sliderMaxValue = 100;
  bool showBottomSheet = false;

  List<BidPriceItem> getBidPrices() {
    List<BidPriceItem> bidPriceItems = [];
    for (var entry in widget.tableRowDataMap.entries) {
      int tableIndex = entry.key;
      for (var rowData in entry.value) {
        if (rowData.price.isNotEmpty) {
          bidPriceItems.add(
              BidPriceItem(tableIndex: tableIndex, bidPrice: rowData.price));
        }
      }
    }
    return bidPriceItems;
  }

  void setQuantityForSelectedBidPrice() {
    setState(() {
      if (selectedTableIndex != null && selectedBidPrice != null) {
        var rows = widget.tableRowDataMap[selectedTableIndex!];
        if (rows != null) {
          for (var row in rows) {
            if (row.price == selectedBidPrice) {
              controller.text = row.quantity;
              setState(() {
                sliderMaxValue = double.parse(row.quantity);
              });
              if (widget.onRowDataSelected != null) {
                widget.onRowDataSelected!(row);
              }
              break;
            }
          }
        }
      }
    });
  }

  void handleBidPriceSelection(BidPriceItem selectedItem) {
    setState(() {
      selectedBidPrice = selectedItem.bidPrice;
      selectedTableIndex = selectedItem.tableIndex;
      setQuantityForSelectedBidPrice();
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeDefaults();
    });
    super.initState();
  }

  void initializeDefaults() {
    setState(() {
      final bidPriceItems = getBidPrices();
      if (bidPriceItems.isNotEmpty) {
        selectedBidPrice = bidPriceItems.first.bidPrice;
        selectedTableIndex = bidPriceItems.first.tableIndex;
        setQuantityForSelectedBidPrice();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;
    final bidPriceItems = getBidPrices();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
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
                  enabled: selectedBidPrice != null,
                  onChanged: (value) {
                    setState(() {
                      double newValue = double.tryParse(value) ?? 0;
                      controller.text = newValue.toStringAsFixed(0);
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Slider(
            value:
                double.parse(controller.text.isEmpty ? '0' : controller.text),
            min: 0,
            max: sliderMaxValue,
            thumbColor: colors.axisColor,
            activeColor: colors.axisColor,
            inactiveColor: colors.borderColorSecondary,
            divisions: 100,
            onChanged: (value) {
              setState(() {
                controller.text = value.toStringAsFixed(0);
              });
            },
          ),
          const SizedBox(height: 20),
          const Text("Select limit order price"),
          DropdownButton<BidPriceItem>(
            value: selectedBidPrice != null && selectedTableIndex != null
                ? bidPriceItems.firstWhere(
                    (item) =>
                        item.bidPrice == selectedBidPrice &&
                        item.tableIndex == selectedTableIndex,
                    orElse: () => bidPriceItems.first,
                  )
                : null,
            isExpanded: true,
            hint: const Text("Select Bid Price"),
            onChanged: (BidPriceItem? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedBidPrice = newValue.bidPrice;
                  selectedTableIndex = newValue.tableIndex;
                  setQuantityForSelectedBidPrice();
                });
              }
            },
            items: bidPriceItems
                .map<DropdownMenuItem<BidPriceItem>>((BidPriceItem item) {
              return DropdownMenuItem<BidPriceItem>(
                value: item,
                child: Text(item.bidPrice),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          ButtonWidget(
            color: colors.primary,
            btnContent: "Confirm Order",
            onTap: () {
              Navigator.of(context).pop();
              widget.moveNext();
            },
          ),
        ],
      ),
    );
  }
}

class BidPriceItem {
  final int tableIndex;
  final String bidPrice;

  BidPriceItem({required this.tableIndex, required this.bidPrice});
}
