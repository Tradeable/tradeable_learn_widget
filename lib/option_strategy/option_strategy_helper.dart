import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:tradeable_learn_widget/option_strategy/option_strategy_leg.model.dart';

class OptionStrategyHelper {
  final List<OptionLeg> legs;

  OptionStrategyHelper({required this.legs});

  List<double> generateXAxisValues() {
    // Find the lowest and highest strikes
    double minStrike = double.infinity;
    double maxStrike = double.negativeInfinity;

    for (var leg in legs) {
      if (leg.strike < minStrike) minStrike = leg.strike;
      if (leg.strike > maxStrike) maxStrike = leg.strike;
    }

    // Calculate range: 5% below lowest strike to 5% above highest strike
    double rangeMin = (minStrike * 0.95);
    double rangeMax = (maxStrike * 1.05);

    // double rangeMin = (minStrike - 100);
    // double rangeMax = (maxStrike + 100);

    // Round to nearest 50 below and above
    rangeMin = (rangeMin / 50).floor() * 50;
    rangeMax = (rangeMax / 50).ceil() * 50;

    // Generate list of values at 50-point intervals
    List<double> xAxisValues = [];
    for (double value = rangeMin; value <= rangeMax; value += 50) {
      xAxisValues.add(value);
    }

    return xAxisValues;
  }

  List<double> _calculateSingleLegPnL({
    required List<double> underlyingPrices,
    required OptionLeg leg,
  }) {
    List<double> pnl = [];
    int multiplier = leg.type == PositionType.buy ? 1 : -1;

    for (double price in underlyingPrices) {
      double legPnL;
      if (leg.optionType == OptionType.call) {
        // For calls: max(S - K, 0) - premium
        legPnL = (max(price - leg.strike, 0) - leg.premium) *
            leg.quantity *
            multiplier;
      } else {
        // For puts: max(K - S, 0) - premium
        legPnL = (max(leg.strike - price, 0) - leg.premium) *
            leg.quantity *
            multiplier;
      }
      pnl.add(legPnL);
    }
    return pnl;
  }

  Map<String, List<double>> calculateExpirationPnL() {
    // Generate x-axis values
    List<double> xAxisValues = generateXAxisValues();

    // Calculate P&L for each leg
    Map<String, List<double>> legPnLs = {};
    List<double> totalPnL = List.filled(xAxisValues.length, 0);

    // Calculate individual leg P&Ls
    for (var leg in legs) {
      String legName =
          '${leg.symbol} ${leg.strike} ${leg.optionType.toString().split('.').last.toUpperCase()}';
      List<double> legPnL = _calculateSingleLegPnL(
        underlyingPrices: xAxisValues,
        leg: leg,
      );

      // Add to individual leg P&Ls
      legPnLs[legName] = legPnL;

      // Add to total P&L
      for (int i = 0; i < legPnL.length; i++) {
        totalPnL[i] += legPnL[i];
      }
    }

    // Add total P&L to the results
    legPnLs['Total'] = totalPnL;

    return legPnLs;
  }

  List<FlSpot> calculateFlSPots() {
    List<double> xAxisValues = generateXAxisValues();
    List<double> totalPnL = List<double>.filled(xAxisValues.length, 0);
    List<FlSpot> flSpots = [];

    for (OptionLeg leg in legs) {
      List<double> legPnL = _calculateSingleLegPnL(
        underlyingPrices: xAxisValues,
        leg: leg,
      );

      for (int i = 0; i < legPnL.length; i++) {
        totalPnL[i] += legPnL[i];
      }
    }

    for (int i = 0; i < xAxisValues.length; i++) {
      flSpots.add(FlSpot(xAxisValues[i], totalPnL[i]));
    }

    return flSpots;
  }

  ChartStats calculateStatistics() {
    final pnlResults = calculateExpirationPnL();
    print(pnlResults);
    pnlResults.forEach((legName, pnl) {
      print('$legName P&L at different price points:');
      for (int i = 0; i < pnl.length; i++) {
        print(
            'Price: ${generateXAxisValues()[i]}, P&L: ${pnl[i].toStringAsFixed(2)}');
      }
      print('---');
    });

    List<double> totalPnL = pnlResults['Total']!;

    double maxProfit = totalPnL.reduce(max);
    double maxLoss = totalPnL.reduce(min);
    double totalInvestment = legs.fold(
        0.0,
        (sum, leg) =>
            sum +
            (leg.type == PositionType.buy ? leg.premium * leg.quantity : 0));

    return ChartStats(
        xMin: generateXAxisValues().first,
        xMax: generateXAxisValues().last,
        yMin: maxLoss,
        yMax: maxProfit,
        spots: calculateFlSPots());

    // return {
    //   'maxProfit': maxProfit,
    //   'maxLoss': maxLoss,
    //   'totalInvestment': totalInvestment,
    //   'riskRewardRatio': maxProfit.abs() / maxLoss.abs(),
    // };
  }
}

class ChartStats {
  final double xMin;
  final double xMax;
  final double yMin;
  final double yMax;
  final List<FlSpot> spots;

  ChartStats({
    required this.xMin,
    required this.xMax,
    required this.yMin,
    required this.yMax,
    required this.spots,
  });
}
