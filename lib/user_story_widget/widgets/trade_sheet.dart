import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tradeable_learn_widget/user_story_widget/user_story_data_model.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class TradeSheet extends StatefulWidget {
  final Map<int, List<RowData>> tableRowDataMap;
  final Function(RowData)? onRowDataSelected;

  const TradeSheet({
    super.key,
    required this.tableRowDataMap,
    this.onRowDataSelected,
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
  }

  void handleBidPriceSelection(BidPriceItem selectedItem) {
    setState(() {
      selectedBidPrice = selectedItem.bidPrice;
      selectedTableIndex = selectedItem.tableIndex;
      setQuantityForSelectedBidPrice();
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              Text("Quantity to Trade", style: textStyles.mediumBold),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "Enter quantity",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d{1,2}$')),
                  ],
                  enabled: selectedBidPrice != null,
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
            onChangeStart: selectedBidPrice == null ? null : (value) {},
            onChangeEnd: selectedBidPrice == null ? null : (value) {},
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              DropdownButton<BidPriceItem>(
                value: selectedBidPrice != null && selectedTableIndex != null
                    ? bidPriceItems.firstWhere((item) =>
                        item.bidPrice == selectedBidPrice &&
                        item.tableIndex == selectedTableIndex)
                    : null,
                hint: const Text("Select Bid Price"),
                onChanged: (BidPriceItem? newValue) {
                  if (newValue != null) {
                    handleBidPriceSelection(newValue);
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
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        activeColor: colors.borderColorPrimary,
                        value: isNotificationChecked,
                        onChanged: (bool? newValue) {
                          setState(() {
                            isNotificationChecked = newValue!;
                          });
                        },
                      ),
                      Text("Trigger Notification",
                          style: textStyles.smallNormal),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        activeColor: colors.borderColorPrimary,
                        value: isAutoExecutionChecked,
                        onChanged: (bool? newValue) {
                          setState(() {
                            isAutoExecutionChecked = newValue!;
                          });
                        },
                      ),
                      Text("Auto Execution", style: textStyles.smallNormal),
                    ],
                  ),
                ],
              ),
            ],
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
