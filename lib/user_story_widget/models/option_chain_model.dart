import 'package:tradeable_learn_widget/utils/trade_taker_widget.dart';

class OptionData {
  final Options options;
  late List<TradeTypeModel>? tradeTypeModel;

  OptionData({required this.options, this.tradeTypeModel});

  Map<String, dynamic> toJson() => {
        'options': options.toJson(),
      };

  factory OptionData.fromJson(Map<String, dynamic> json) {
    return OptionData(
        options: Options.fromJson(json['options']),
        tradeTypeModel: json["tradeTypeModel"] != null
            ? (json["tradeTypeModel"] as List<dynamic>?)
                ?.map((e) => TradeTypeModel.fromJson(e))
                .toList()
            : []);
  }
}

class Options {
  final OptionType call;
  final OptionType put;
  final bool showValues;

  Options({
    required this.call,
    required this.put,
    required this.showValues,
  });

  Map<String, dynamic> toJson() => {
        'call': call.toJson(),
        'put': put.toJson(),
        'showValues': showValues,
      };

  factory Options.fromJson(Map<String, dynamic> json) => Options(
        call: OptionType.fromJson(json['call']),
        put: OptionType.fromJson(json['put']),
        showValues: json['showValues'] ?? true,
      );
}

class OptionType {
  final List<OptionEntry> entries;

  OptionType({required this.entries});

  Map<String, dynamic> toJson() => {
        'entries': entries.map((entry) => entry.toJson()).toList(),
      };

  factory OptionType.fromJson(Map<String, dynamic> json) => OptionType(
        entries: (json['entries'] as List)
            .map((entry) => OptionEntry.fromJson(entry))
            .toList(),
      );
}

class OptionEntry {
  final double premium;
  final double value;
  final double strike;
  bool isBuyEnabled;
  bool isSellEnabled;
  bool isBuy;
  bool isCallTrade;

  OptionEntry(
      {required this.premium,
      required this.value,
      required this.strike,
      required this.isBuyEnabled,
      required this.isSellEnabled,
      required this.isBuy,
      required this.isCallTrade});

  Map<String, dynamic> toJson() => {
        'premium': premium,
        'value': value,
        'strike': strike,
        'isBuyEnabled': isBuyEnabled,
        'isSellEnabled': isSellEnabled,
        'isBuy': isBuy,
        'isCallTrade': isCallTrade
      };

  factory OptionEntry.fromJson(Map<String, dynamic> json) => OptionEntry(
      premium: json['premium'].toDouble(),
      value: json['value'].toDouble(),
      strike: json['strike'].toDouble(),
      isBuyEnabled: json['isBuyEnabled'] ?? true,
      isSellEnabled: json['isSellEnabled'] ?? true,
      isBuy: json['isBuy'] ?? true,
      isCallTrade: json['isCallTrade'] ?? true);
}
