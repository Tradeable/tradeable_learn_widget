import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tradeable_learn_widget/order_type_v1/widgets/custom_switch.dart';
import 'package:tradeable_learn_widget/order_type_v1/widgets/pillbox_selector.dart';
import 'package:tradeable_learn_widget/order_type_v1/widgets/text_field.dart';

class StockOrderWidget extends StatefulWidget {
  final String stockName;
  final double currentPrice;
  final Function? onTutorialStepCompleted;

  const StockOrderWidget({
    super.key,
    required this.stockName,
    required this.currentPrice,
    this.onTutorialStepCompleted,
  });

  @override
  StockOrderWidgetState createState() => StockOrderWidgetState();
}

class StockOrderWidgetState extends State<StockOrderWidget> {
  String selectedOrderType = 'DELIVERY';
  String priceType = 'MARKET';
  String validity = 'DAY';
  bool showAdvanced = false;
  TextEditingController stopLossController = TextEditingController();
  TextEditingController targetPriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController disclosedQuantityController = TextEditingController();

  bool tutorialMode = false;
  int currentTutorialStep = 0;
  List<Map<String, dynamic>> tutorialSteps = [];
  bool eMarginEnabled = false;
  bool stopLossEnabled = false;
  bool targetPercentEnabled = false;
  final NumberFormat numberFormatter = NumberFormat('#,##,##0.00', 'en_IN');

  @override
  void initState() {
    super.initState();
    quantityController.text = "1";
    disclosedQuantityController.text = "0";
    updateStopLossAndTarget();
  }

  Map<String, dynamic> getOrderData() {
    return {
      'stockName': widget.stockName,
      'currentPrice': widget.currentPrice,
      'orderType': selectedOrderType,
      'quantity': double.tryParse(quantityController.text),
      'eMarginEnabled': eMarginEnabled,
      'priceType': priceType,
      'validity': validity,
      'stopLoss': selectedOrderType == 'COVER' || stopLossEnabled
          ? double.tryParse(stopLossController.text)
          : null,
      'targetPrice': selectedOrderType == 'COVER'
          ? double.tryParse(targetPriceController.text)
          : null,
      'disclosedQuantity': double.tryParse(disclosedQuantityController.text),
    };
  }

  bool isElementEnabled(String elementId) {
    if (!tutorialMode) return true;

    // Check current step
    if (currentTutorialStep < tutorialSteps.length) {
      if (tutorialSteps[currentTutorialStep]['enabledElements']
          .contains(elementId)) {
        return true;
      }
    }

    // For completed steps, check if the element should remain locked
    for (int i = 0; i < currentTutorialStep; i++) {
      final step = tutorialSteps[i];
      if (step['enabledElements'].contains(elementId)) {
        // If this was a quantity/input step and it's completed, keep it DISABLED
        if (step['checkType'] == 'quantitySelection' &&
            elementId == 'quantity_controls') {
          return false; // Lock the field
        }
        // Add other input types that should lock after completion
        if (step['checkType'] == 'set_stop_loss' &&
            elementId == 'stop_loss_controls') {
          return false; // Lock the field
        }
        if (step['checkType'] == 'set_target_price' &&
            elementId == 'target_price_controls') {
          return false; // Lock the field
        }
        // Keep other elements enabled if they match expected value
        if (_isElementAtExpectedValue(step)) {
          return true;
        }
      }
    }

    return false;
  }

  bool _isElementAtExpectedValue(Map<String, dynamic> step) {
    switch (step['checkType']) {
      case 'productSelection':
        return step['expectedValue'] is List
            ? (step['expectedValue'] as List).contains(selectedOrderType)
            : selectedOrderType == step['expectedValue'];
      case 'quantitySelection':
        final currentQuantity = double.tryParse(quantityController.text) ?? 0;
        return currentQuantity == step['expectedValue'];
      case 'priceTypeSelection':
        return step['expectedValue'] is List
            ? (step['expectedValue'] as List).contains(priceType)
            : priceType == step['expectedValue'];
      case 'set_stop_loss':
        final stopLossValue = double.tryParse(stopLossController.text) ?? 0;
        return stopLossValue == step['expectedValue'];
      case 'set_target_price':
        final targetPriceValue =
            double.tryParse(targetPriceController.text) ?? 0;
        return targetPriceValue == step['expectedValue'];
      default:
        return false;
    }
  }

  String getCurrentTutorialPrompt() {
    if (!tutorialMode || currentTutorialStep >= tutorialSteps.length) {
      return '';
    }
    return tutorialSteps[currentTutorialStep]['prompt'];
  }

  void notifyParent() {
    if (widget.onTutorialStepCompleted != null) {
      widget.onTutorialStepCompleted!();
    }
  }

  bool checkStepCompletion([String? action]) {
    if (!tutorialMode || currentTutorialStep >= tutorialSteps.length) {
      return false;
    }

    Map<String, dynamic> step = tutorialSteps[currentTutorialStep];
    bool completed = false;

    // If an action is provided, only check that specific action
    if (action != null && step['checkType'] != action) {
      return false;
    }

    switch (step['checkType']) {
      case 'productSelection':
        if (step['expectedValue'] is List) {
          completed =
              (step['expectedValue'] as List).contains(selectedOrderType);
        } else {
          completed = selectedOrderType == step['expectedValue'];
        }
        break;
      case 'quantitySelection':
        final currentQuantity = double.tryParse(quantityController.text) ?? 0;
        completed = currentQuantity == step['expectedValue'];
        break;
      case 'e_margin_toggle':
        completed = eMarginEnabled == step['expectedValue'];
        break;
      case 'stop_loss_toggle':
        completed = stopLossEnabled == step['expectedValue'];
        break;
      case 'set_stop_loss':
        final stopLossValue = double.tryParse(stopLossController.text) ?? 0;
        completed = stopLossValue == step['expectedValue'];
        break;
      case 'set_target_price':
        final targetPriceValue =
            double.tryParse(targetPriceController.text) ?? 0;
        completed = targetPriceValue == step['expectedValue'];
        break;
      case 'priceTypeSelection':
        if (step['expectedValue'] is List) {
          completed = (step['expectedValue'] as List).contains(priceType);
        } else {
          completed = priceType == step['expectedValue'];
        }
        break;
      case 'validitySelection':
        if (step['expectedValue'] is List) {
          completed = true;
        } else {
          completed = validity == step['expectedValue'];
        }
        break;
      case 'buyButtonPressed':
        completed =
            action == 'buyButtonPressed'; // Complete only if button was pressed
        break;
      case 'stopLossSet':
        completed = true; // Just acknowledge the stop loss field is visible
        break;
      case 'targetPriceSet':
        completed = true; // Just acknowledge the target price field is visible
        break;
      case 'advancedToggle':
        completed = showAdvanced == step['expectedValue'];
        break;
    }

    if (completed && currentTutorialStep < tutorialSteps.length - 1) {
      setState(() {
        currentTutorialStep++;
      });
      notifyParent();
      return true;
    }

    return completed;
  }

  void setupTutorialWithSteps(List<Map<String, dynamic>> steps) {
    setState(() {
      selectedOrderType = '';
      // quantity = 0;
      priceType = '';

      tutorialSteps = steps;
      tutorialMode = true;
      currentTutorialStep = 0;
    });
  }

  void updateStopLossAndTarget() {
    stopLossController.text = (widget.currentPrice * 0.9).toStringAsFixed(2);
    targetPriceController.text = (widget.currentPrice * 1.1).toStringAsFixed(2);
  }

  String getMarginRequirementText() {
    final quantity = double.tryParse(quantityController.text);
    if (quantity == null || quantity == 0) {
      return "0.00";
    }
    return numberFormatter.format(quantity * widget.currentPrice);
  }

  String getOrderTypeDescription() {
    switch (selectedOrderType) {
      case 'DELIVERY':
        return 'Delivery (Cash & Carry) allows you to buy stocks and hold them in your demat account. The full value of shares is required as margin.';
      case 'INTRADAY':
        return 'Intraday orders must be squared off on the same trading day. They require lower margin as positions are not carried overnight.';
      case 'COVER':
        return 'Cover orders come with a built-in stop loss. They offer higher leverage but require you to set both stop loss and target price.';
      default:
        return '';
    }
  }

  String getPriceTypeDescription() {
    switch (priceType) {
      case 'MARKET':
        return 'Market orders are executed immediately at the best available current market price.';
      case 'LIMIT':
        return 'Limit orders are executed only at the specified price or better.';
      default:
        return '';
    }
  }

  String getValidityDescription() {
    switch (validity) {
      case 'DAY':
        return 'Order valid for the current trading day only. It gets canceled automatically at the end of the trading day if not executed.';
      case 'IOC':
        return 'Immediate or Cancel - Order is executed immediately (fully or partially). Any portion that cannot be executed immediately is canceled.';
      case 'GTD':
        return 'Good Till Date - Order remains active in the market until executed or until the specified date.';
      default:
        return '';
    }
  }

  void _incrementValue(
    TextEditingController controller, {
    int decimalPlaces = 0,
    double step = 1.0,
    double? minValue,
    double? maxValue,
    bool triggerStepCompletion = false,
    bool isPercentage = false,
  }) {
    // Extract numeric value (remove % if present)
    final text = controller.text.replaceAll('%', '');
    final currentValue = double.tryParse(text) ?? 0;
    final newValue = currentValue + step;

    if (maxValue == null || newValue <= maxValue) {
      setState(() {
        controller.text =
            '${newValue.toStringAsFixed(decimalPlaces)}${isPercentage ? '%' : ''}';
        if (triggerStepCompletion) checkStepCompletion();
      });
    }
  }

  void _decrementValue(
    TextEditingController controller, {
    int decimalPlaces = 0,
    double step = 1.0,
    double? minValue,
    bool triggerStepCompletion = false,
    bool isPercentage = false,
  }) {
    // Extract numeric value (remove % if present)
    final text = controller.text.replaceAll('%', '');
    final currentValue = double.tryParse(text) ?? 0;
    final newValue = currentValue - step;

    if (minValue == null || newValue >= minValue) {
      setState(() {
        controller.text =
            '${newValue.toStringAsFixed(decimalPlaces)}${isPercentage ? '%' : ''}';
        if (triggerStepCompletion) checkStepCompletion();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.translate(
            offset: Offset(0, -15),
            child: Container(
              width: 300,
              height: 40, // Adjust height as needed
              margin: const EdgeInsets.only(bottom: 8),
              // padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xFFEBF0F9), // Customize color
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25)),
              ),
              child: Center(
                child: Text(
                  widget.stockName,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF6E6E6E)),
                ),
              ),
            ),
          ),
          Stack(clipBehavior: Clip.none, children: [
            Container(
              margin: const EdgeInsets.only(top: 18),
              padding: const EdgeInsets.only(top: 24),
              decoration: BoxDecoration(
                color: Color(0xFFEBF0F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFFE2E2E2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: PillboxSelector(
                        options: ['DELIVERY', 'INTRADAY', 'COVER'],
                        selectedValue: selectedOrderType,
                        fontSize: 16,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        onSelected: (value) {
                          setState(() {
                            selectedOrderType = value;
                            if (value == 'COVER') {
                              priceType = 'MARKET';
                            }
                            updateStopLossAndTarget();

                            checkStepCompletion();
                          });
                        },
                        isEnabled: (option) =>
                            isElementEnabled('product_$option'),
                      )),
                ],
              ),
            ),
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Color(0xFFF9F6EB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'PRODUCT',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF6E6E6E)),
                ),
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              getOrderTypeDescription(),
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              // Quantity section (left side)
              Expanded(
                flex: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 18),
                          padding: const EdgeInsets.only(top: 24),
                          decoration: BoxDecoration(
                            color: Color(0xFFEBF0F9),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                child: CustomTextField(
                                  controller: quantityController,
                                  label: 'QUANTITY',
                                  enabled:
                                      isElementEnabled('quantity_controls'),
                                  onChanged: (value) {
                                    setState(() {});
                                    checkStepCompletion();
                                  },
                                  onIncrement: () => _incrementValue(
                                      quantityController,
                                      minValue: 1,
                                      triggerStepCompletion: true),
                                  onDecrement: () => _decrementValue(
                                      quantityController,
                                      minValue: 1,
                                      triggerStepCompletion: true),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Color(0xFFF9F6EB),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'QUANTITY',
                              textScaler: TextScaler.linear(1),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xFF6E6E6E)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Flexible(
                flex: 1,
                child: Container(),
              ),

              // Order Type section (right side)
              Expanded(
                flex: 30,
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.only(top: 25),
                          decoration: BoxDecoration(
                            color: Color(0xFFEBF0F9),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: priceType == 'LIMIT'
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  child: CustomTextField(
                                    controller: targetPriceController,
                                    label: 'Limit Price',
                                    onIncrement: () => _incrementValue(
                                        targetPriceController,
                                        decimalPlaces: 2,
                                        triggerStepCompletion: true),
                                    onDecrement: () => _decrementValue(
                                        targetPriceController,
                                        decimalPlaces: 2,
                                        triggerStepCompletion: true),
                                  ),
                                )
                              : SizedBox(
                                  height: 75,
                                  child: Center(
                                    child: Text(
                                      widget.currentPrice.toStringAsFixed(2),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.only(
                                left: 8, top: 1, bottom: 1),
                            decoration: BoxDecoration(
                              color: Color(0xFFF9F6EB),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: AutoSizeText(
                                    'ORDER TYPE',
                                    maxLines: 1,
                                    minFontSize: 8,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Color(0xFF6E6E6E)),
                                  ),
                                ),
                                IntrinsicWidth(
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: PillboxSelector(
                                        useFlexibleWidth: true,
                                        fontSize: 14,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 7, horizontal: 8),
                                        options: ['MARKET', 'LIMIT'],
                                        selectedValue: priceType,
                                        onSelected: (value) => setState(() {
                                          priceType = value;
                                          checkStepCompletion();
                                        }),
                                        isEnabled: (option) {
                                          // Disable MARKET when GTD is selected
                                          if (validity == 'GTD' &&
                                              option == 'MARKET') {
                                            return false;
                                          }
                                          if (selectedOrderType == 'COVER' &&
                                              option == 'LIMIT') {
                                            return false;
                                          }
                                          return isElementEnabled(
                                              'price_type_$option');
                                        },
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              getPriceTypeDescription(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),

          if (selectedOrderType == 'COVER') ...[
            const SizedBox(height: 8),
            Row(
              children: [
                // Stop Loss section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 18),
                            padding: const EdgeInsets.only(top: 24),
                            decoration: BoxDecoration(
                              color: Color(0xFFEBF0F9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  child: CustomTextField(
                                    controller: stopLossController,
                                    label: 'Stop Loss',
                                    enabled:
                                        isElementEnabled('stop_loss_controls'),
                                    onChanged: (value) => checkStepCompletion(),
                                    onIncrement: () => _incrementValue(
                                        stopLossController,
                                        decimalPlaces: 2,
                                        triggerStepCompletion: true),
                                    onDecrement: () => _decrementValue(
                                        stopLossController,
                                        decimalPlaces: 2,
                                        triggerStepCompletion: true),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Color(0xFFF9F6EB),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'Sell Stop Loss',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color(0xFF6E6E6E)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Target Price section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 18),
                            padding: const EdgeInsets.only(top: 24),
                            decoration: BoxDecoration(
                              color: Color(0xFFEBF0F9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  child: CustomTextField(
                                    controller: targetPriceController,
                                    label: 'Target Price',
                                    enabled: isElementEnabled(
                                        'target_price_controls'),
                                    onChanged: (value) => checkStepCompletion(),
                                    onIncrement: () => _incrementValue(
                                        targetPriceController,
                                        decimalPlaces: 2,
                                        triggerStepCompletion: true),
                                    onDecrement: () => _decrementValue(
                                        targetPriceController,
                                        decimalPlaces: 2,
                                        triggerStepCompletion: true),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Color(0xFFF9F6EB),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'Sell Price',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color(0xFF6E6E6E)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(
            height: 16,
          ),

          if (selectedOrderType == 'DELIVERY') ...[
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    // margin: const EdgeInsets.only(top: 18),
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFFEBF0F9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9F6EB),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'E-Margin',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Color(0xFF6E6E6E)),
                          ),
                        ),
                        CustomSwitch(
                          value: eMarginEnabled,
                          onChanged: isElementEnabled('e_margin_toggle')
                              ? (value) {
                                  setState(() {
                                    eMarginEnabled = value;
                                  });
                                }
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                //Flexible(flex: 1, child: Container()),
                Flexible(
                  flex: 1,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFFEBF0F9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Color(0xFFF9F6EB),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'Reqd Margin',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Color(0xFF6E6E6E)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 80),
                            child: AutoSizeText(
                              '₹${getMarginRequirementText()}',
                              minFontSize: 8,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6E6E6E)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFFEBF0F9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Color(0xFFF9F6EB),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'Reqd Margin',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6E6E6E)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 80),
                            child: AutoSizeText(
                              '₹${getMarginRequirementText()}',
                              minFontSize: 8,
                              maxLines: 1,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6E6E6E)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(flex: 1, child: Container())
              ],
            ),
          ],

          if (eMarginEnabled == true) ...[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'E-Margin allows you to pledge your existing holdings as collateral to get additional buying power without selling your shares.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ] else
            SizedBox(height: 8),

          // Advanced section
          const SizedBox(height: 24),
          InkWell(
            onTap: isElementEnabled('advanced_toggle')
                ? () {
                    setState(() {
                      showAdvanced = !showAdvanced;
                    });
                    checkStepCompletion();
                  }
                : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Advanced Options',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Color(0xFF6E6E6E)),
                ),
                Icon(showAdvanced ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),

          const SizedBox(height: 24),

          if (showAdvanced) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(clipBehavior: Clip.none, children: [
                          Container(
                            margin: const EdgeInsets.only(top: 18),
                            padding: const EdgeInsets.only(top: 24),
                            decoration: BoxDecoration(
                              color: Color(0xFFEBF0F9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFE2E2E2),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: PillboxSelector(
                                      fontSize: 14,
                                      options: ['DAY', 'IOC', 'GTD'],
                                      selectedValue: validity,
                                      onSelected: (value) => setState(() {
                                        validity = value;
                                        // Auto-set price type to LIMIT when GTD is selected
                                        if (value == 'GTD') {
                                          priceType = 'LIMIT';
                                        }
                                        checkStepCompletion();
                                      }),
                                      isEnabled: (option) {
                                        if (selectedOrderType == 'COVER' &&
                                            (option == 'IOC' ||
                                                option == 'GTD')) {
                                          return false;
                                        }
                                        return true;
                                      },
                                    )),
                              ],
                            ),
                          ),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Color(0xFFF9F6EB),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'VALIDITY',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color(0xFF6E6E6E)),
                              ),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (validity == 'DAY') ...[
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(children: [
                          Container(
                            margin: const EdgeInsets.only(top: 18),
                            padding: const EdgeInsets.only(top: 24),
                            decoration: BoxDecoration(
                              color: Color(0xFFEBF0F9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  child: CustomTextField(
                                    controller: disclosedQuantityController,
                                    label: 'DISCLOSED QUANTITY',
                                    enabled:
                                        isElementEnabled('quantity_controls'),
                                    onIncrement: () => _incrementValue(
                                        disclosedQuantityController,
                                        minValue: 0,
                                        triggerStepCompletion: true),
                                    onDecrement: () => _decrementValue(
                                        disclosedQuantityController,
                                        minValue: 0,
                                        triggerStepCompletion: true),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9F6EB),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Text(
                                'DISC. QUANTITY',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color(0xFF6E6E6E)),
                              ),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ] else ...[
                  Flexible(flex: 2, child: Container())
                ]
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                getValidityDescription(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
