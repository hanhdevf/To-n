// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CastModel _$CastModelFromJson(Map<String, dynamic> json) => _CastModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      originalName: json['original_name'] as String,
      profilePath: json['profile_path'] as String?,
      character: json['character'] as String?,
      order: (json['order'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CastModelToJson(_CastModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'original_name': instance.originalName,
      'profile_path': instance.profilePath,
      'character': instance.character,
      'order': instance.order,
    };

_CreditsResponseModel _$CreditsResponseModelFromJson(
        Map<String, dynamic> json) =>
    _CreditsResponseModel(
      id: (json['id'] as num).toInt(),
      cast: (json['cast'] as List<dynamic>)
          .map((e) => CastModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CreditsResponseModelToJson(
        _CreditsResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cast': instance.cast,
    };
