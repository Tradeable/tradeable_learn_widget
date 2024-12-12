import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/option_strategy/black_scholes.dart';
import 'package:tradeable_learn_widget/option_strategy/option_strategy_helper.dart';
import 'package:tradeable_learn_widget/option_strategy/option_strategy_leg.model.dart';
import 'package:tradeable_learn_widget/option_strategy/payoff_graph_widget.dart';
import 'package:tradeable_learn_widget/option_strategy/payoff_table_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class OptionStrategyContainer extends StatefulWidget {
  final List<OptionLeg> legs;
  final double spotPrice;
  const OptionStrategyContainer(
      {super.key, required this.legs, required this.spotPrice});

  @override
  State<OptionStrategyContainer> createState() =>
      _OptionStrategyContainerState();
}

class _OptionStrategyContainerState extends State<OptionStrategyContainer>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageViewController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageViewController = PageController();

    // List<double> pnl = calculateExpirationPnL(
    //     underlyingPrices: generateRange(widget.spotPrice, 100),
    //     strikePrice: widget.legs.first.strike,
    //     optionType: widget.legs.first.optionType,
    //     premium: widget.legs.first.premium,
    //     quanity: widget.legs.first.quantity);

    // List<double> tpnl = calculateTheoreticalPnL(
    //     underlyingPrices: generateRange(widget.spotPrice, 100),
    //     strikePrice: widget.legs.first.strike,
    //     timeToExpiry: timeToExpiry(DateTime.now(), widget.legs.first.expiry),
    //     riskFreeRate: 0.1,
    //     sigma: BlackScholes.impliedVolatility(
    //         widget.legs.first.premium,
    //         widget.spotPrice,
    //         widget.legs.first.strike,
    //         timeToExpiry(DateTime.now(), widget.legs.first.expiry),
    //         0.1,
    //         widget.legs.first.optionType),
    //     optionType: widget.legs.first.optionType,
    //     premium: widget.legs.first.premium,
    //     quanity: widget.legs.first.quantity);
    // print(generateRange(widget.spotPrice, 100));
    // print(generateXAxisValues(widget.legs));
    // print(calculateStatistics(widget.legs));

    OptionStrategyHelper helper = OptionStrategyHelper(legs: widget.legs);

    print(helper.calculateStatistics());
    // print(pnl);
    // print(tpnl);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _pageViewController.dispose();
  }

  void _handlePageViewChanged(int currentPageIndex) {
    _tabController.index = currentPageIndex;
  }

  void _updateCurrentPageIndex(int index) {
    _tabController.index = index;
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  List<double> generateRange(double value, double interval) {
    // Round value to nearest multiple of 100
    double roundedValue = (value / 100).round() * 100;

    List<double> result = [];

    // Calculate start and end points from rounded value
    double start = roundedValue - 1000;
    double end = roundedValue + 1000;

    // Generate numbers from start to end with given interval
    for (double i = start; i <= end; i += interval) {
      result
          .add(double.parse(i.toStringAsFixed(2))); // Round to 2 decimal places
    }

    return result;
  }

  double timeToExpiry(DateTime currentDate, DateTime expirationDate) {
    //print("cu : $currentDate");
    //print("ex : $expirationDate");
    Duration delta = expirationDate.difference(currentDate);
    //print("delta : $delta");
    //print("delta in days : ${delta.inMinutes / (60 * 24 * 365)}");
    return delta.inMinutes / 60 / 24 / 365.0;
  }

  List<double> calculateTheoreticalPnL({
    required List<double> underlyingPrices,
    required double strikePrice,
    required double timeToExpiry,
    required double riskFreeRate,
    required double sigma,
    required OptionType optionType,
    required double premium,
    required int quanity,
  }) {
    List<double> theoreticalPnL = [];

    for (double S in underlyingPrices) {
      // Calculate option value using Black-Scholes
      double optionValue = BlackScholes.optionPrice(
        S,
        strikePrice,
        timeToExpiry,
        riskFreeRate,
        sigma,
        optionType,
      );

      // Calculate P&L
      double pnl = (optionValue - premium) * quanity;
      theoreticalPnL.add(pnl);
    }

    return theoreticalPnL;
  }

  List<double> calculateExpirationPnL({
    required List<double> underlyingPrices,
    required double strikePrice,
    required OptionType optionType,
    required double premium,
    required int quanity,
  }) {
    List<double> expirationPnL = [];

    for (double price in underlyingPrices) {
      double pnl;
      if (optionType == OptionType.call) {
        // For calls: max(S - K, 0) - premium
        pnl = (max(price - strikePrice, 0) - premium) * quanity;
      } else if (optionType == OptionType.put) {
        // For puts: max(K - S, 0) - premium
        pnl = (max(strikePrice - price, 0) - premium) * quanity;
      } else {
        throw ArgumentError('Option type must be "call" or "put"');
      }
      expirationPnL.add(pnl);
    }

    return expirationPnL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Analyse Your Order",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
        bottom: TabBar(
            controller: _tabController,
            onTap: _updateCurrentPageIndex,
            indicatorColor: Theme.of(context).customColors.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(text: "Payoff Graph"),
              Tab(
                text: "Payoff Table",
              )
            ]),
      ),
      body: SafeArea(
          child: PageView(
        controller: _pageViewController,
        onPageChanged: _handlePageViewChanged,
        children: const [PayoffGraphWidget(), PayoffTableWidget()],
      )),
    );
  }
}
