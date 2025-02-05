class OptionData {
  final Options options;

  OptionData({required this.options});

  Map<String, dynamic> toJson() => {
        'options': options.toJson(),
      };

  factory OptionData.fromJson(Map<String, dynamic> json) {
    return OptionData(
      options: Options.fromJson(json['options']),
    );
  }
}

class Options {
  final OptionType call;
  final OptionType put;

  Options({
    required this.call,
    required this.put,
  });

  Map<String, dynamic> toJson() => {
        'call': call.toJson(),
        'put': put.toJson(),
      };

  factory Options.fromJson(Map<String, dynamic> json) => Options(
        call: OptionType.fromJson(json['call']),
        put: OptionType.fromJson(json['put']),
      );
}

class OptionType {
  final List<OptionEntry> entries;

  OptionType({
    required this.entries,
  });

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

  OptionEntry({
    required this.premium,
    required this.value,
    required this.strike,
  });

  Map<String, dynamic> toJson() => {
        'premium': premium,
        'value': value,
        'strike': strike,
      };

  factory OptionEntry.fromJson(Map<String, dynamic> json) => OptionEntry(
        premium: json['premium'].toDouble(),
        value: json['value'].toDouble(),
        strike: json['strike'].toDouble(),
      );
}
