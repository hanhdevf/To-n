// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cinema_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CinemaModel _$CinemaModelFromJson(Map<String, dynamic> json) => CinemaModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      logoUrl: json['logo_url'] as String?,
      facilities: (json['facilities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CinemaModelToJson(CinemaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'logo_url': instance.logoUrl,
      'facilities': instance.facilities,
    };
