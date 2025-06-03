import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/dynamic_chart/widgets/feedback_widget.dart';
import 'package:tradeable_learn_widget/order_type_v1/order_type_v1.model.dart';
import 'package:tradeable_learn_widget/order_type_v1/order_type_widget.dart';
import 'package:tradeable_learn_widget/order_type_v1/tutorial_manager.dart';
import 'package:tradeable_learn_widget/order_type_v1/utils/ui_constants.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/app_theme.dart';
import 'dart:math' as math;

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
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (widget.model.tutorialMode)
              if (widget.model.tutorialMode)
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colors.cardColorSecondary,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) => SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                    child: Container(
                      key: ValueKey(tutorialPrompt),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: colors.buttonColor,
                        border: Border.all(color: colors.cardColorSecondary),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Instruction",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF6E6E6E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tutorialPrompt,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Row(
                            children: [
                              Spacer(),
                              SizedBox(width: 8),
                              FeedbackWidget(), // You'll need to import this widget
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

            Expanded(
              child: Container(
                margin:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.025),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: UIConstants.secondaryCardColor,
                    width: MediaQuery.of(context).size.width * 0.025,
                  ),
                  borderRadius:
                      BorderRadius.circular(UIConstants.defaultBorderRadius),
                ),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.04,
                      decoration: const BoxDecoration(
                        color: UIConstants.primaryCardColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25)),
                      ),
                      child: Center(
                        child: Text(widget.model.stockName,
                            style: UIConstants.stockNameStyle),
                      ),
                    ),
                    // Scrollable content
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
                  ],
                ),
              ),
            ),
            // Fixed buy button at bottom of screen
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.010,
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
                top: MediaQuery.of(context).size.height * 0.010,
              ),
              child: SizedBox(
                height:
                    math.max(50, MediaQuery.of(context).size.height * 0.055),
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
                            print('Order Data: $orderData');

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
                                    content: Text(
                                        "Don't worry, it's just a simulation!")),
                              );
                            }
                          }
                        : () {
                            widget.onNextClick;
                          },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: UIConstants.textFieldAccentColor),
                    child: const Text('BUY', style: UIConstants.buyButtonStyle),
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
