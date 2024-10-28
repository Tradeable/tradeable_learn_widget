import 'package:tradeable_learn_widget/bucket_widgetv1/models/stock_bucket_map.dart';

enum BucketContainerState { loadUi, submitResponse }

class BucketContainerModel {
  late String question;
  late List<String> bucketValues;
  late List<StockBucketMap> stockBucketMap;
  late List<StockBucketMap> acceptedValues = [];

  BucketContainerModel.fromJson(dynamic data) {
    question = data["question"];
    bucketValues = List<String>.from(data["buckets"]);
    stockBucketMap = List<StockBucketMap>.from(
        data["draggableValues"].map((x) => StockBucketMap.fromJson(x)));
    stockBucketMap.shuffle();
  }
}
