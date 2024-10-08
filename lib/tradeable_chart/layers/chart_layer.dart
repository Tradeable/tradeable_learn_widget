import 'dart:ui';

abstract class ChartLayer {
  const ChartLayer();

  static double cocaX(double v, double yw, Offset originOffset) {
    double cocaX = v + yw + originOffset.dx;
    return cocaX < yw ? yw : cocaX;
  }

  static double cocaY(double v, double h, double xh, double yh, double vMax,
      double vMin, Offset originOffset, Offset origin) {
    double cocaY =
        h - xh - ((v - vMin) * (h - xh - yh) / (vMax - vMin)) + originOffset.dy;
    return cocaY > origin.dy ? origin.dy : cocaY;
  }

  static double cacoX(double v, double yw, Offset originOffset) {
    return v - yw - originOffset.dx;
  }

  static double cacoY(double v, double xh, double yh, double yw, double h,
      double vMax, double vMin, Offset originOffset) {
    return (vMin + (h - xh - v) / (h - xh - yh) * (vMax - vMin)) +
        (originOffset.dy / (h - xh - yh) * (vMax - vMin));
  }
}
