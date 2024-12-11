import 'dart:math';

import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';

class BlackScholes {
  // Standard normal cumulative distribution function
  static double normCdf(double x) {
    return 0.5 * (1 + erf(x / sqrt(2)));
  }

  // Error function implementation
  static double erf(double x) {
    // Constants
    double a1 = 0.254829592;
    double a2 = -0.284496736;
    double a3 = 1.421413741;
    double a4 = -1.453152027;
    double a5 = 1.061405429;
    double p = 0.3275911;

    // Save the sign of x
    int sign = x < 0 ? -1 : 1;
    x = x.abs();

    // A&S formula 7.1.26
    double t = 1.0 / (1.0 + p * x);
    double y = 1.0 -
        (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * exp(-x * x);

    return sign * y;
  }

  // Calculate d1 and d2 for Black-Scholes formula
  static List<double> _d1d2(
      double S, double K, double t, double r, double sigma) {
    double d1 = (log(S / K) + (r + sigma * sigma / 2) * t) / (sigma * sqrt(t));
    double d2 = d1 - sigma * sqrt(t);
    return [d1, d2];
  }

  // Calculate option price using Black-Scholes formula
  static double optionPrice(double S, double K, double t, double r,
      double sigma, OptionType optionType) {
    List<double> d = _d1d2(S, K, t, r, sigma);
    double d1 = d[0];
    double d2 = d[1];

    if (optionType == OptionType.call) {
      return S * normCdf(d1) - K * exp(-r * t) * normCdf(d2);
    } else {
      return K * exp(-r * t) * normCdf(-d2) - S * normCdf(-d1);
    }
  }

  // Calculate implied volatility using Newton-Raphson method
  static double impliedVolatility(double price, double S, double K, double t,
      double r, OptionType optionType) {
    double sigma = 0.5; // Initial guess
    double tolerance = 0.0001;
    int maxIter = 100;
    print("s : $S");
    print("k : $K");
    print("t : $t");
    print("r : $r");
    print("signma : $sigma");
    for (int i = 0; i < maxIter; i++) {
      double price_estimate = optionPrice(S, K, t, r, sigma, optionType);
      print(price_estimate);
      double diff = price - price_estimate;

      if (diff.abs() < tolerance) {
        return sigma;
      }

      // Calculate vega
      List<double> d = _d1d2(S, K, t, r, sigma);
      print(d);
      double d1 = d[0];
      double vega = S * sqrt(t) * exp(-d1 * d1 / 2) / sqrt(2 * pi);
      print(vega);
      sigma = sigma + diff / vega;

      // Ensure sigma stays within reasonable bounds
      if (sigma <= 0.0001) sigma = 0.0001;
      if (sigma > 5) sigma = 5;
    }

    throw Exception('Implied volatility did not converge');
  }

  // Calculate delta
  static double delta(double S, double K, double t, double r, double sigma,
      OptionType optionType) {
    List<double> d = _d1d2(S, K, t, r, sigma);
    double d1 = d[0];

    if (optionType == OptionType.call) {
      return normCdf(d1);
    } else {
      return normCdf(d1) - 1;
    }
  }
}
