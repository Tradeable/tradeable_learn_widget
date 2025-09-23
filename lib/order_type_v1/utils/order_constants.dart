class OrderConstants {
  static const List<String> orderTypes = ['DELIVERY', 'INTRADAY', 'COVER'];
  static const List<String> priceTypes = ['MARKET', 'LIMIT'];
  static const List<String> validityTypes = ['DAY', 'IOC', 'GTD'];

  static const double defaultStopLossMultiplier = 0.9;
  static const double defaultTargetPriceMultiplier = 1.1;

  static const Map<String, String> orderTypeDescriptions = {
    'DELIVERY':
        'Delivery (Cash & Carry) allows you to buy stocks and hold them in your demat account. The full value of shares is required as margin.',
    'INTRADAY':
        'Intraday orders must be squared off on the same trading day. They require lower margin as positions are not carried overnight.',
    'COVER':
        'Cover orders come with a built-in stop loss. They offer higher leverage but require you to set both stop loss and target price.',
  };

  static const Map<String, String> priceTypeDescriptions = {
    'MARKET':
        'Market orders are executed immediately at the best available current market price.',
    'LIMIT': 'Limit orders are executed only at the specified price or better.',
  };
}
