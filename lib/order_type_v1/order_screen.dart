import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/order_type_v1/order_type_v1.model.dart';
import 'package:tradeable_learn_widget/order_type_v1/order_type_widget.dart';
import 'package:tradeable_learn_widget/order_type_v1/tutorial_manager.dart';

class OrderScreen extends StatefulWidget {
  final OrderTypeV1 model;
  final VoidCallback onNextClick;

  const OrderScreen({
    super.key,
    required this.model,
    required this.onNextClick,
  });

  @override
  OrderScreenState createState() => OrderScreenState();
}

class OrderScreenState extends State<OrderScreen> {
  final GlobalKey<StockOrderWidgetState> orderWidgetKey =
      GlobalKey<StockOrderWidgetState>();
  String tutorialPrompt = 'Loading tutorial...';
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();

    // Setup tutorial with a longer delay to ensure widget is fully built
    if (widget.model.tutorialMode) {
      // Use a slightly longer delay to make sure everything is initialized
      Future.delayed(const Duration(milliseconds: 100), () {
        _initializeTutorial();
      });
    }
  }

  void _initializeTutorial() {
    final currentState = orderWidgetKey.currentState;
    if (currentState != null) {
      if (widget.model.tutorialType != null) {
        final tutorialSteps =
            TutorialManager.getTutorialByType(widget.model.tutorialType!);
        if (tutorialSteps != null) {
          currentState.setupTutorialWithSteps(tutorialSteps);
        }
      }

      setState(() {
        isInitialized = true;
        tutorialPrompt = currentState.getCurrentTutorialPrompt();
      });
    } else {
      Future.delayed(const Duration(milliseconds: 100), _initializeTutorial);
    }
  }

  void updateTutorialPrompt() {
    final currentState = orderWidgetKey.currentState;
    if (currentState != null) {
      setState(() {
        tutorialPrompt = currentState.getCurrentTutorialPrompt();
      });
    }
  }

  void onTutorialStepCompleted() {
    updateTutorialPrompt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Tutorial prompt box - only visible in tutorial mode
            if (widget.model.tutorialMode)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.blue.shade300),
                ),
                child: Text(
                  orderWidgetKey.currentState?.getCurrentTutorialPrompt() ??
                      'Loading tutorial...',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            // Main content in an Expanded widget to take available space
            Expanded(
              child: SingleChildScrollView(
                child: StockOrderWidget(
                  key: orderWidgetKey,
                  stockName: widget.model.stockName,
                  currentPrice: widget.model.currentPrice,
                  onTutorialStepCompleted: onTutorialStepCompleted,
                ),
              ),
            ),

            // Fixed buy button at bottom of screen
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  bottom: 30, left: 30, right: 30, top: 10),
              child: SizedBox(
                height: 60,
                child: Opacity(
                  opacity: !widget.model.tutorialMode ||
                          orderWidgetKey.currentState
                                  ?.isElementEnabled('buy_button') ==
                              true
                      ? 1.0
                      : 0.5,
                  child: ElevatedButton(
                    onPressed: !widget.model.tutorialMode ||
                            orderWidgetKey.currentState
                                    ?.isElementEnabled('buy_button') ==
                                true
                        ? () {
                            widget.onNextClick;
                            final orderData =
                                orderWidgetKey.currentState?.getOrderData();
                            //print('Order Data: $orderData');

                            if (widget.model.tutorialMode) {
                              // Handle tutorial completion
                              final isLastStep =
                                  orderWidgetKey.currentState != null &&
                                      orderWidgetKey.currentState!
                                              .currentTutorialStep ==
                                          orderWidgetKey.currentState!
                                                  .tutorialSteps.length -
                                              1;

                              if (isLastStep) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Tutorial completed successfully!')),
                                );
                              }
                            } else {
                              // Regular order flow
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Order placed successfully!')),
                              );
                            }
                          }
                        : () {
                            widget.onNextClick;
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      'BUY',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
