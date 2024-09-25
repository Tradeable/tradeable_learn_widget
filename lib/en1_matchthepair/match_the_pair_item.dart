class MatchThePairItem {
  final String imgSrc;
  final List<String> tags;

  MatchThePairItem(this.imgSrc, this.tags);

  factory MatchThePairItem.fromJson(Map<String, dynamic> json) {
    return MatchThePairItem(
      json['imgSrc'] as String,
      (json['tags'] as List<dynamic>).map((tag) => tag as String).toList(),
    );
  }
}
