class StockBucketMap {
  final String imageUrl;
  final String bucketName;

  StockBucketMap({required this.imageUrl, required this.bucketName});

  factory StockBucketMap.fromJson(Map<String, dynamic> json) {
    return StockBucketMap(
      imageUrl: json['imageUrl'] ?? '',
      bucketName: json['bucketName'] ?? '',
    );
  }
}