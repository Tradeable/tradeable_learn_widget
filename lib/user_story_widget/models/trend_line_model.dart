import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';

class TrendLineModelV1 {
  final String id;
  final int qqid;
  final String level;
  final String ticker;
  final String timeframe;
  final int startTime;
  final int atTime;
  final int endTime;
  final String type;
  final String question;
  final List<RangeResponse> rangeResponses;
  final bool isLineChart;
  final List<dynamic> pointLabel;
  final List<List<LineOffset>> lineOffsets;
  final List<Candle> candles;
  final bool notifyAnswered;
  final String helperText;

  TrendLineModelV1({
    required this.id,
    required this.qqid,
    required this.level,
    required this.ticker,
    required this.timeframe,
    required this.startTime,
    required this.atTime,
    required this.endTime,
    required this.type,
    required this.question,
    required this.rangeResponses,
    required this.isLineChart,
    required this.pointLabel,
    required this.lineOffsets,
    required this.candles,
    required this.notifyAnswered,
    required this.helperText,
  });

  factory TrendLineModelV1.fromJson(Map<String, dynamic> json) {
    return TrendLineModelV1(
      id: json['_id'],
      qqid: json['qqid'],
      level: json['level'],
      ticker: json['ticker'],
      timeframe: json['timeframe'],
      startTime: json['startTime'],
      atTime: json['atTime'],
      endTime: json['endTime'],
      type: json['type'],
      question: json['question'],
      rangeResponses: (json['rangeResponses'] as List)
          .map((e) => RangeResponse.fromJson(e))
          .toList(),
      isLineChart: json['isLineChart'],
      pointLabel: json['point_label'],
      lineOffsets: (json['line_offsets'] as List)
          .map((e) => (e as List).map((i) => LineOffset.fromJson(i)).toList())
          .toList(),
      candles:
          (json['candles'] as List).map((e) => Candle.fromJson(e)).toList(),
      notifyAnswered: json['notifyAnswered'],
      helperText: json['helperText'],
    );
  }
}

class RangeResponse {
  final double min;
  final double max;

  RangeResponse({required this.min, required this.max});

  factory RangeResponse.fromJson(Map<String, dynamic> json) {
    return RangeResponse(min: json['min'], max: json['max']);
  }
}

class LineOffset {
  final double start;
  final double end;

  LineOffset({required this.start, required this.end});

  factory LineOffset.fromJson(Map<String, dynamic> json) {
    return LineOffset(start: json['start'], end: json['end']);
  }
}
