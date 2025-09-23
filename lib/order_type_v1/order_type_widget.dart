import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/order_type_v1/sections/advanced_options.dart';
import 'package:tradeable_learn_widget/order_type_v1/sections/cover_order_fields';
import 'package:tradeable_learn_widget/order_type_v1/sections/margin_section.dart';
import 'package:tradeable_learn_widget/order_type_v1/sections/price_type_section.dart';
import 'package:tradeable_learn_widget/order_type_v1/sections/product_section.dart';
import 'package:tradeable_learn_widget/order_type_v1/sections/quantity_section.dart';
import 'package:tradeable_learn_widget/order_type_v1/services/order_service.dart';

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

  @override
  void initState() {
    super.initState();
    quantityController.text = "1";
    disclosedQuantityController.text = "0";
    updateStopLossAndTarget();
  }

  Map<String, dynamic> getOrderData() {
    return OrderService.createOrderData(
      stockName: widget.stockName,
      currentPrice: widget.currentPrice,
      orderType: selectedOrderType,
      quantityText: quantityController.text,
      eMarginEnabled: eMarginEnabled,
      priceType: priceType,
      validity: validity,
      stopLossText: stopLossController.text,
      targetPriceText: targetPriceController.text,
      disclosedQuantityText: disclosedQuantityController.text,
      stopLossEnabled: stopLossEnabled,
    );
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
    OrderService.updateStopLossAndTarget(
      currentPrice: widget.currentPrice,
      stopLossController: stopLossController,
      targetPriceController: targetPriceController,
    );
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
    return // Remove the override entirely, or make it conditional
        MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: Platform.isIOS
            ? MediaQuery.of(context).textScaler // Respect iOS settings
            : const TextScaler.linear(1.0), // Override only on Android
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProductSelector(
              selectedOrderType: selectedOrderType,
              onOrderTypeChanged: (value) {
                setState(() {
                  selectedOrderType = value;
                  if (value == 'COVER') {
                    priceType = 'MARKET';
                    validity = 'DAY';
                  }
                  OrderService.updateStopLossAndTarget(
                    currentPrice: widget.currentPrice,
                    stopLossController: stopLossController,
                    targetPriceController: targetPriceController,
                  );
                  checkStepCompletion();
                });
              },
              isEnabled: isElementEnabled,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text(OrderService.getOrderTypeDescription(selectedOrderType)),
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.02),
            Row(
              children: [
                // Quantity section (left side)
                Expanded(
                  flex: 3,
                  child: QuantitySection(
                    quantityController: quantityController,
                    isEnabled: isElementEnabled,
                    onIncrement: () => _incrementValue(
                      quantityController,
                      minValue: 1,
                      triggerStepCompletion: true,
                    ),
                    onDecrement: () => _decrementValue(
                      quantityController,
                      minValue: 1,
                      triggerStepCompletion: true,
                    ),
                    onChanged: (value) {
                      setState(() {});
                      checkStepCompletion();
                    },
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                // Price Type section (right side)
                Expanded(
                  flex: 4,
                  child: PriceTypeSection(
                    priceType: priceType,
                    selectedOrderType: selectedOrderType,
                    validity: validity,
                    currentPrice: widget.currentPrice,
                    targetPriceController: targetPriceController,
                    onPriceTypeChanged: (value) => setState(() {
                      priceType = value;
                      checkStepCompletion();
                    }),
                    isEnabled: isElementEnabled,
                    onTargetIncrement: () => _incrementValue(
                      targetPriceController,
                      decimalPlaces: 2,
                      triggerStepCompletion: true,
                    ),
                    onTargetDecrement: () => _decrementValue(
                      targetPriceController,
                      decimalPlaces: 2,
                      triggerStepCompletion: true,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                OrderService.getPriceTypeDescription(priceType),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            if (selectedOrderType == 'COVER') ...[
              SizedBox(height: MediaQuery.of(context).size.width * 0.02),
              CoverOrderFields(
                stopLossController: stopLossController,
                targetPriceController: targetPriceController,
                isEnabled: isElementEnabled,
                onStopLossIncrement: () => _incrementValue(
                  stopLossController,
                  decimalPlaces: 2,
                  triggerStepCompletion: true,
                ),
                onStopLossDecrement: () => _decrementValue(
                  stopLossController,
                  decimalPlaces: 2,
                  triggerStepCompletion: true,
                ),
                onTargetIncrement: () => _incrementValue(
                  targetPriceController,
                  decimalPlaces: 2,
                  triggerStepCompletion: true,
                ),
                onTargetDecrement: () => _decrementValue(
                  targetPriceController,
                  decimalPlaces: 2,
                  triggerStepCompletion: true,
                ),
                onStopLossChanged: (value) => checkStepCompletion(),
                onTargetChanged: (value) => checkStepCompletion(),
              ),
            ],
            SizedBox(height: MediaQuery.of(context).size.width * 0.02),
            MarginSection(
              selectedOrderType: selectedOrderType,
              eMarginEnabled: eMarginEnabled,
              marginRequirementText: OrderService.calculateMarginRequirement(
                double.tryParse(quantityController.text) ?? 0,
                widget.currentPrice,
              ),
              isEnabled: isElementEnabled,
              onEMarginChanged: (value) {
                setState(() {
                  eMarginEnabled = value;
                });
              },
            ),
            if (eMarginEnabled == true) ...[
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'E-Margin allows you to pledge your existing holdings as collateral to get additional buying power without selling your shares.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ] else
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            SizedBox(height: MediaQuery.of(context).size.height * 0.020),
            AdvancedOptions(
              showAdvanced: showAdvanced,
              validity: validity,
              selectedOrderType: selectedOrderType,
              disclosedQuantityController: disclosedQuantityController,
              isEnabled: isElementEnabled,
              onToggleAdvanced: () {
                setState(() {
                  showAdvanced = !showAdvanced;
                });
                checkStepCompletion();
              },
              onValidityChanged: (value) => setState(() {
                validity = value;
                if (value == 'GTD') {
                  priceType = 'LIMIT';
                }
                checkStepCompletion();
              }),
              onDisclosedIncrement: () => _incrementValue(
                disclosedQuantityController,
                minValue: 0,
                triggerStepCompletion: true,
              ),
              onDisclosedDecrement: () => _decrementValue(
                disclosedQuantityController,
                minValue: 0,
                triggerStepCompletion: true,
              ),
            ),
            if (showAdvanced)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  OrderService.getValidityDescription(validity),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
