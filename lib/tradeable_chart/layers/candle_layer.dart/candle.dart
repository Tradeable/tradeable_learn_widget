class Candle {
  final int candleId;
  final double open;
  final double high;
  final double low;
  final double close;
  final DateTime dateTime;
  final int volume;
  bool isSelected;
  bool selectedByModel;

  Candle(
      {this.isSelected = false,
      this.selectedByModel = false,
      required this.candleId,
      required this.open,
      required this.high,
      required this.low,
      required this.close,
      required this.dateTime,
      required this.volume});
}
