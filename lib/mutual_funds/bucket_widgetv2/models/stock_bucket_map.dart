class StockBucketMapV2 {
  final String imageUrl;
  final String bucketName;

  StockBucketMapV2({required this.imageUrl, required this.bucketName});

  factory StockBucketMapV2.fromJson(Map<String, dynamic> json) {
    return StockBucketMapV2(
      imageUrl: json['imageUrl'] ?? '',
      bucketName: json['bucketName'] ?? '',
    );
  }
}