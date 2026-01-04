import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:galaxymob/features/movies/domain/entities/review.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';

@freezed
abstract class AuthorDetails with _$AuthorDetails {
  const factory AuthorDetails({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'username') String? username,
    @JsonKey(name: 'avatar_path') String? avatarPath,
    @JsonKey(name: 'rating') double? rating,
  }) = _AuthorDetails;

  factory AuthorDetails.fromJson(Map<String, dynamic> json) =>
      _$AuthorDetailsFromJson(json);
}

@freezed
abstract class ReviewModel with _$ReviewModel {
  const ReviewModel._();

  const factory ReviewModel({
    required String id,
    required String author,
    @JsonKey(name: 'author_details') AuthorDetails? authorDetails,
    required String content,
    @JsonKey(name: 'created_at') required String createdAt,
    required String url,
  }) = _ReviewModel;

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  Review toEntity() => Review(
        id: id,
        author: author,
        avatarPath: authorDetails?.avatarPath,
        rating: authorDetails?.rating,
        content: content,
        createdAt: createdAt,
      );
}

@freezed
abstract class ReviewsResponseModel with _$ReviewsResponseModel {
  const factory ReviewsResponseModel({
    required int id,
    required int page,
    required List<ReviewModel> results,
    @JsonKey(name: 'total_pages') required int totalPages,
    @JsonKey(name: 'total_results') required int totalResults,
  }) = _ReviewsResponseModel;

  factory ReviewsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewsResponseModelFromJson(json);
}
