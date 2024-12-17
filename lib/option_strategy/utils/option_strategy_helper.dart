import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:tradeable_learn_widget/option_strategy/utils/black_scholes.dart';
import 'package:tradeable_learn_widget/option_strategy/models/option_strategy_leg.model.dart';

class OptionStrategyHelper {
  final List<OptionLeg> legs;
  late List<double> xValues;
  late List<FlSpot> expirationPnLvalues;
  late double xMin;
  late double xMax;
  late double yMin;
  late double yMax;

  OptionStrategyHelper({required this.legs}) {
    xValues = _generateXAxisValues();
    xMin = xValues.first;
    xMax = xValues.last;
    expirationPnLvalues = _calculateExpirationPnLFlSpots();
    yMin = expirationPnLvalues.map((e) => e.y).reduce(min);
    yMax = expirationPnLvalues.map((e) => e.y).reduce(max);
  }

  List<double> _generateXAxisValues() {
    double minStrike = double.infinity;
    double maxStrike = double.negativeInfinity;

    for (OptionLeg leg in legs) {
      if (leg.strike < minStrike) minStrike = leg.strike;
      if (leg.strike > maxStrike) maxStrike = leg.strike;
    }

    double rangeMin = (minStrike * 0.95);
    double rangeMax = (maxStrike * 1.05);

    rangeMin = (rangeMin / 50).floor() * 50;
    rangeMax = (rangeMax / 50).ceil() * 50;

    List<double> xAxisValues = [];
    for (double value = rangeMin; value <= rangeMax; value += 50) {
      xAxisValues.add(value);
    }

    return xAxisValues;
  }

  List<double> calculateSingleLegPnL({
    required OptionLeg leg,
  }) {
    List<double> pnl = [];
    int multiplier = leg.type == PositionType.buy ? 1 : -1;

    for (double price in xValues) {
      double legPnL;
      if (leg.optionType == OptionType.call) {
        legPnL = (max(price - leg.strike, 0) - leg.premium) *
            leg.quantity *
            multiplier;
      } else {
        legPnL = (max(leg.strike - price, 0) - leg.premium) *
            leg.quantity *
            multiplier;
      }
      pnl.add(legPnL);
    }
    return pnl;
  }

  List<FlSpot> _calculateExpirationPnLFlSpots() {
    List<double> xAxisValues = xValues;
    List<double> totalPnL = List<double>.filled(xAxisValues.length, 0);
    List<FlSpot> flSpots = [];

    for (OptionLeg leg in legs) {
      List<double> legPnL = calculateSingleLegPnL(
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

  double _timeToExpiry(DateTime currentDate, DateTime expirationDate) {
    Duration delta = expirationDate.difference(currentDate);
    return delta.inMinutes / 60 / 24 / 365.0;
  }

  List<double> calculateSingleTheoreticalPnL({
    required double spotPrice,
    required OptionLeg leg,
  }) {
    List<double> theoreticalPnL = [];
    int multiplier = leg.type == PositionType.buy ? 1 : -1;

    for (double S in xValues) {
      double optionValue = BlackScholes.optionPrice(
        S,
        leg.strike,
        _timeToExpiry(DateTime.now(), leg.expiry),
        0.1,
        BlackScholes.impliedVolatility(leg.premium, spotPrice, leg.strike,
            _timeToExpiry(DateTime.now(), leg.expiry), 0.1, leg.optionType),
        leg.optionType,
      );

      // Calculate P&L
      double pnl = (optionValue - leg.premium) * leg.quantity * multiplier;

      theoreticalPnL.add(pnl);
    }

    return theoreticalPnL;
  }

  List<FlSpot> calculateTheoroticalFlSpots({required double spotPrice}) {
    List<double> xAxisValues = xValues;
    List<double> totalPnL = List<double>.filled(xAxisValues.length, 0);
    List<FlSpot> flSpots = [];

    for (OptionLeg leg in legs) {
      List<double> legPnL =
          calculateSingleTheoreticalPnL(leg: leg, spotPrice: spotPrice);

      for (int i = 0; i < legPnL.length; i++) {
        totalPnL[i] += legPnL[i];
      }
    }

    for (int i = 0; i < xAxisValues.length; i++) {
      flSpots.add(FlSpot(xAxisValues[i], totalPnL[i]));
    }

    return flSpots;
  }
}
