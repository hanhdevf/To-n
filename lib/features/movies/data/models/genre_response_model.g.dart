// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GenreResponseModel _$GenreResponseModelFromJson(Map<String, dynamic> json) =>
    _GenreResponseModel(
      genres: (json['genres'] as List<dynamic>)
          .map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GenreResponseModelToJson(_GenreResponseModel instance) =>
    <String, dynamic>{
      'genres': instance.genres,
    };
