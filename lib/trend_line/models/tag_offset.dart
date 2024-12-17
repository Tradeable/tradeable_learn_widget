import 'package:json_annotation/json_annotation.dart';

part 'tag_offset.g.dart';

@JsonSerializable()
class TagOffset {
  String tag;
  double start;
  double end;

  TagOffset(this.tag, this.start, this.end);

  factory TagOffset.fromJson(Map<String, dynamic> json) =>
      _$TagOffsetFromJson(json);

  Map<String, dynamic> toJson() => _$TagOffsetToJson(this);
}
