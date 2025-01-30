class ReelRangeResponseV1 {
  String title;
  double min;
  double max;
  bool? isCorrect;

  ReelRangeResponseV1(this.title, this.min, this.max, {this.isCorrect});

  factory ReelRangeResponseV1.fromJson(Map<String, dynamic> json) {
    return ReelRangeResponseV1(
      json["title"] ?? "",
      json['min']?.toDouble() ?? 0.0,
      json['max']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      'min': min,
      'max': max,
      'isCorrect': isCorrect,
    };
  }
}
