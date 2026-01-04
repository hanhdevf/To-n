import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:galaxymob/features/movies/domain/entities/cast.dart';

part 'credit_model.freezed.dart';
part 'credit_model.g.dart';

@freezed
abstract class CastModel with _$CastModel {
  const CastModel._();

  const factory CastModel({
    required int id,
    required String name,
    @JsonKey(name: 'original_name') required String originalName,
    @JsonKey(name: 'profile_path') String? profilePath,
    required String? character,
    required int? order,
  }) = _CastModel;

  factory CastModel.fromJson(Map<String, dynamic> json) =>
      _$CastModelFromJson(json);

  Cast toEntity() => Cast(
        id: id,
        name: name,
        originalName: originalName,
        profilePath: profilePath,
        character: character,
      );
}

@freezed
abstract class CreditsResponseModel with _$CreditsResponseModel {
  const factory CreditsResponseModel({
    required int id,
    required List<CastModel> cast,
  }) = _CreditsResponseModel;

  factory CreditsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CreditsResponseModelFromJson(json);
}
