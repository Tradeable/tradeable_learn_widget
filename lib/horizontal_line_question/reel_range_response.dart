class ReelRangeResponse {
  double min;
  double max;

  ReelRangeResponse(this.min, this.max);

  factory ReelRangeResponse.fromJson(Map<String, dynamic> json) {
    return ReelRangeResponse(
      json['min']?.toDouble() ?? 0.0,
      json['max']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
    };
  }
}
