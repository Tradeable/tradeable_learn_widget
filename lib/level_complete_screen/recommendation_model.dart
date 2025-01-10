class Recommendations {
  final List<Recommendation> recommendations;

  Recommendations({required this.recommendations});

  factory Recommendations.fromJson(Map<String, dynamic> json) {
    final recommendations = json.entries
        .map(
          (entry) =>
              Recommendation.fromJson(entry.value as Map<String, dynamic>),
        )
        .toList();
    return Recommendations(recommendations: recommendations);
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    for (var i = 0; i < recommendations.length; i++) {
      json['recommendation_${i + 1}'] = recommendations[i].toJson();
    }
    return json;
  }
}

class Recommendation {
  final int levelId;
  final String title;
  final String? description;
  final String imageUrl;

  Recommendation({
    required this.levelId,
    required this.title,
    this.description,
    required this.imageUrl,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      levelId: json['level_id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level_id': levelId,
      'title': title,
      'description': description,
      'image_url': imageUrl,
    };
  }
}
