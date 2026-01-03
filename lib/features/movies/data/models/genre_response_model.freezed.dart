// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'genre_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GenreResponseModel {
  List<GenreModel> get genres;

  /// Create a copy of GenreResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GenreResponseModelCopyWith<GenreResponseModel> get copyWith =>
      _$GenreResponseModelCopyWithImpl<GenreResponseModel>(
          this as GenreResponseModel, _$identity);

  /// Serializes this GenreResponseModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GenreResponseModel &&
            const DeepCollectionEquality().equals(other.genres, genres));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(genres));

  @override
  String toString() {
    return 'GenreResponseModel(genres: $genres)';
  }
}

/// @nodoc
abstract mixin class $GenreResponseModelCopyWith<$Res> {
  factory $GenreResponseModelCopyWith(
          GenreResponseModel value, $Res Function(GenreResponseModel) _then) =
      _$GenreResponseModelCopyWithImpl;
  @useResult
  $Res call({List<GenreModel> genres});
}

/// @nodoc
class _$GenreResponseModelCopyWithImpl<$Res>
    implements $GenreResponseModelCopyWith<$Res> {
  _$GenreResponseModelCopyWithImpl(this._self, this._then);

  final GenreResponseModel _self;
  final $Res Function(GenreResponseModel) _then;

  /// Create a copy of GenreResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? genres = null,
  }) {
    return _then(_self.copyWith(
      genres: null == genres
          ? _self.genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<GenreModel>,
    ));
  }
}

/// Adds pattern-matching-related methods to [GenreResponseModel].
extension GenreResponseModelPatterns on GenreResponseModel {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_GenreResponseModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GenreResponseModel() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_GenreResponseModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GenreResponseModel():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_GenreResponseModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GenreResponseModel() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(List<GenreModel> genres)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GenreResponseModel() when $default != null:
        return $default(_that.genres);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(List<GenreModel> genres) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GenreResponseModel():
        return $default(_that.genres);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(List<GenreModel> genres)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GenreResponseModel() when $default != null:
        return $default(_that.genres);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GenreResponseModel implements GenreResponseModel {
  const _GenreResponseModel({required final List<GenreModel> genres})
      : _genres = genres;
  factory _GenreResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GenreResponseModelFromJson(json);

  final List<GenreModel> _genres;
  @override
  List<GenreModel> get genres {
    if (_genres is EqualUnmodifiableListView) return _genres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_genres);
  }

  /// Create a copy of GenreResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GenreResponseModelCopyWith<_GenreResponseModel> get copyWith =>
      __$GenreResponseModelCopyWithImpl<_GenreResponseModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GenreResponseModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GenreResponseModel &&
            const DeepCollectionEquality().equals(other._genres, _genres));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_genres));

  @override
  String toString() {
    return 'GenreResponseModel(genres: $genres)';
  }
}

/// @nodoc
abstract mixin class _$GenreResponseModelCopyWith<$Res>
    implements $GenreResponseModelCopyWith<$Res> {
  factory _$GenreResponseModelCopyWith(
          _GenreResponseModel value, $Res Function(_GenreResponseModel) _then) =
      __$GenreResponseModelCopyWithImpl;
  @override
  @useResult
  $Res call({List<GenreModel> genres});
}

/// @nodoc
class __$GenreResponseModelCopyWithImpl<$Res>
    implements _$GenreResponseModelCopyWith<$Res> {
  __$GenreResponseModelCopyWithImpl(this._self, this._then);

  final _GenreResponseModel _self;
  final $Res Function(_GenreResponseModel) _then;

  /// Create a copy of GenreResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? genres = null,
  }) {
    return _then(_GenreResponseModel(
      genres: null == genres
          ? _self._genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<GenreModel>,
    ));
  }
}

// dart format on
