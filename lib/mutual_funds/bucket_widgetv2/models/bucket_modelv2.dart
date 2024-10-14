import 'package:tradeable_learn_widget/mutual_funds/bucket_widgetv2/models/stock_bucket_map.dart';

enum BucketContainerV2State { loadUi, submitResponse }

class BucketContainerV2Model {
  final dynamic data;
  late String question;
  late List<String> bucketValues;
  late List<StockBucketMapV2> stockBucketMap;
  late List<StockBucketMapV2> acceptedValues = [];

  BucketContainerV2Model(this.data) {
    question = data["question"];
    bucketValues = List<String>.from(data["buckets"]);
    stockBucketMap = List<StockBucketMapV2>.from(
        data["draggableValues"].map((x) => StockBucketMapV2.fromJson(x)));
    stockBucketMap.shuffle();
  }
}
