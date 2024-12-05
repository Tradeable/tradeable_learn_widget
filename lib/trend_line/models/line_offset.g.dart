// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'line_offset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LineOffset _$LineOffsetFromJson(Map<String, dynamic> json) => LineOffset(
      (json['start'] as num).toDouble(),
      (json['end'] as num).toDouble(),
    );

Map<String, dynamic> _$LineOffsetToJson(LineOffset instance) =>
    <String, dynamic>{
      'start': instance.start,
      'end': instance.end,
    };
