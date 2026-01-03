import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:galaxymob/features/movies/data/models/genre_model.dart';

part 'genre_response_model.freezed.dart';
part 'genre_response_model.g.dart';

@freezed
abstract class GenreResponseModel with _$GenreResponseModel {
  const factory GenreResponseModel({
    required List<GenreModel> genres,
  }) = _GenreResponseModel;

  factory GenreResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GenreResponseModelFromJson(json);
}
