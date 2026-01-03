import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:galaxymob/features/movies/data/models/movie_model.dart';

part 'movie_response_model.freezed.dart';
part 'movie_response_model.g.dart';

@freezed
abstract class MovieResponseModel with _$MovieResponseModel {
  const factory MovieResponseModel({
    required int page,
    required List<MovieModel> results,
    @JsonKey(name: 'total_pages') required int totalPages,
    @JsonKey(name: 'total_results') required int totalResults,
  }) = _MovieResponseModel;

  factory MovieResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseModelFromJson(json);
}
