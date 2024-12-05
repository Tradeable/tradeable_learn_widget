import 'package:json_annotation/json_annotation.dart';

part 'line_offset.g.dart';

@JsonSerializable()
class LineOffset {
  double start;
  double end;

  LineOffset(this.start, this.end);

  factory LineOffset.fromJson(Map<String, dynamic> json) =>
      _$LineOffsetFromJson(json);

  Map<String, dynamic> toJson() => _$LineOffsetToJson(this);
}
