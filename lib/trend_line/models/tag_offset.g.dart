// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_offset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagOffset _$TagOffsetFromJson(Map<String, dynamic> json) => TagOffset(
      json['tag'] as String,
      (json['start'] as num).toDouble(),
      (json['end'] as num).toDouble(),
    );

Map<String, dynamic> _$TagOffsetToJson(TagOffset instance) => <String, dynamic>{
      'tag': instance.tag,
      'start': instance.start,
      'end': instance.end,
    };
