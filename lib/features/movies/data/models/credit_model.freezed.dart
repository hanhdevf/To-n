// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'credit_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CastModel {
  int get id;
  String get name;
  @JsonKey(name: 'original_name')
  String get originalName;
  @JsonKey(name: 'profile_path')
  String? get profilePath;
  String? get character;
  int? get order;

  /// Create a copy of CastModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CastModelCopyWith<CastModel> get copyWith =>
      _$CastModelCopyWithImpl<CastModel>(this as CastModel, _$identity);

  /// Serializes this CastModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CastModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.originalName, originalName) ||
                other.originalName == originalName) &&
            (identical(other.profilePath, profilePath) ||
                other.profilePath == profilePath) &&
            (identical(other.character, character) ||
                other.character == character) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, originalName, profilePath, character, order);

  @override
  String toString() {
    return 'CastModel(id: $id, name: $name, originalName: $originalName, profilePath: $profilePath, character: $character, order: $order)';
  }
}

/// @nodoc
abstract mixin class $CastModelCopyWith<$Res> {
  factory $CastModelCopyWith(CastModel value, $Res Function(CastModel) _then) =
      _$CastModelCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String name,
      @JsonKey(name: 'original_name') String originalName,
      @JsonKey(name: 'profile_path') String? profilePath,
      String? character,
      int? order});
}

/// @nodoc
class _$CastModelCopyWithImpl<$Res> implements $CastModelCopyWith<$Res> {
  _$CastModelCopyWithImpl(this._self, this._then);

  final CastModel _self;
  final $Res Function(CastModel) _then;

  /// Create a copy of CastModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? originalName = null,
    Object? profilePath = freezed,
    Object? character = freezed,
    Object? order = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      originalName: null == originalName
          ? _self.originalName
          : originalName // ignore: cast_nullable_to_non_nullable
              as String,
      profilePath: freezed == profilePath
          ? _self.profilePath
          : profilePath // ignore: cast_nullable_to_non_nullable
              as String?,
      character: freezed == character
          ? _self.character
          : character // ignore: cast_nullable_to_non_nullable
              as String?,
      order: freezed == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [CastModel].
extension CastModelPatterns on CastModel {
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
    TResult Function(_CastModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CastModel() when $default != null:
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
    TResult Function(_CastModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CastModel():
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
    TResult? Function(_CastModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CastModel() when $default != null:
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
    TResult Function(
            int id,
            String name,
            @JsonKey(name: 'original_name') String originalName,
            @JsonKey(name: 'profile_path') String? profilePath,
            String? character,
            int? order)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CastModel() when $default != null:
        return $default(_that.id, _that.name, _that.originalName,
            _that.profilePath, _that.character, _that.order);
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
    TResult Function(
            int id,
            String name,
            @JsonKey(name: 'original_name') String originalName,
            @JsonKey(name: 'profile_path') String? profilePath,
            String? character,
            int? order)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CastModel():
        return $default(_that.id, _that.name, _that.originalName,
            _that.profilePath, _that.character, _that.order);
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
    TResult? Function(
            int id,
            String name,
            @JsonKey(name: 'original_name') String originalName,
            @JsonKey(name: 'profile_path') String? profilePath,
            String? character,
            int? order)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CastModel() when $default != null:
        return $default(_that.id, _that.name, _that.originalName,
            _that.profilePath, _that.character, _that.order);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CastModel extends CastModel {
  const _CastModel(
      {required this.id,
      required this.name,
      @JsonKey(name: 'original_name') required this.originalName,
      @JsonKey(name: 'profile_path') this.profilePath,
      required this.character,
      required this.order})
      : super._();
  factory _CastModel.fromJson(Map<String, dynamic> json) =>
      _$CastModelFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  @JsonKey(name: 'original_name')
  final String originalName;
  @override
  @JsonKey(name: 'profile_path')
  final String? profilePath;
  @override
  final String? character;
  @override
  final int? order;

  /// Create a copy of CastModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CastModelCopyWith<_CastModel> get copyWith =>
      __$CastModelCopyWithImpl<_CastModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CastModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CastModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.originalName, originalName) ||
                other.originalName == originalName) &&
            (identical(other.profilePath, profilePath) ||
                other.profilePath == profilePath) &&
            (identical(other.character, character) ||
                other.character == character) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, originalName, profilePath, character, order);

  @override
  String toString() {
    return 'CastModel(id: $id, name: $name, originalName: $originalName, profilePath: $profilePath, character: $character, order: $order)';
  }
}

/// @nodoc
abstract mixin class _$CastModelCopyWith<$Res>
    implements $CastModelCopyWith<$Res> {
  factory _$CastModelCopyWith(
          _CastModel value, $Res Function(_CastModel) _then) =
      __$CastModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      @JsonKey(name: 'original_name') String originalName,
      @JsonKey(name: 'profile_path') String? profilePath,
      String? character,
      int? order});
}

/// @nodoc
class __$CastModelCopyWithImpl<$Res> implements _$CastModelCopyWith<$Res> {
  __$CastModelCopyWithImpl(this._self, this._then);

  final _CastModel _self;
  final $Res Function(_CastModel) _then;

  /// Create a copy of CastModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? originalName = null,
    Object? profilePath = freezed,
    Object? character = freezed,
    Object? order = freezed,
  }) {
    return _then(_CastModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      originalName: null == originalName
          ? _self.originalName
          : originalName // ignore: cast_nullable_to_non_nullable
              as String,
      profilePath: freezed == profilePath
          ? _self.profilePath
          : profilePath // ignore: cast_nullable_to_non_nullable
              as String?,
      character: freezed == character
          ? _self.character
          : character // ignore: cast_nullable_to_non_nullable
              as String?,
      order: freezed == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
mixin _$CreditsResponseModel {
  int get id;
  List<CastModel> get cast;

  /// Create a copy of CreditsResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreditsResponseModelCopyWith<CreditsResponseModel> get copyWith =>
      _$CreditsResponseModelCopyWithImpl<CreditsResponseModel>(
          this as CreditsResponseModel, _$identity);

  /// Serializes this CreditsResponseModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreditsResponseModel &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other.cast, cast));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, const DeepCollectionEquality().hash(cast));

  @override
  String toString() {
    return 'CreditsResponseModel(id: $id, cast: $cast)';
  }
}

/// @nodoc
abstract mixin class $CreditsResponseModelCopyWith<$Res> {
  factory $CreditsResponseModelCopyWith(CreditsResponseModel value,
          $Res Function(CreditsResponseModel) _then) =
      _$CreditsResponseModelCopyWithImpl;
  @useResult
  $Res call({int id, List<CastModel> cast});
}

/// @nodoc
class _$CreditsResponseModelCopyWithImpl<$Res>
    implements $CreditsResponseModelCopyWith<$Res> {
  _$CreditsResponseModelCopyWithImpl(this._self, this._then);

  final CreditsResponseModel _self;
  final $Res Function(CreditsResponseModel) _then;

  /// Create a copy of CreditsResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cast = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      cast: null == cast
          ? _self.cast
          : cast // ignore: cast_nullable_to_non_nullable
              as List<CastModel>,
    ));
  }
}

/// Adds pattern-matching-related methods to [CreditsResponseModel].
extension CreditsResponseModelPatterns on CreditsResponseModel {
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
    TResult Function(_CreditsResponseModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreditsResponseModel() when $default != null:
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
    TResult Function(_CreditsResponseModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreditsResponseModel():
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
    TResult? Function(_CreditsResponseModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreditsResponseModel() when $default != null:
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
    TResult Function(int id, List<CastModel> cast)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreditsResponseModel() when $default != null:
        return $default(_that.id, _that.cast);
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
    TResult Function(int id, List<CastModel> cast) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreditsResponseModel():
        return $default(_that.id, _that.cast);
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
    TResult? Function(int id, List<CastModel> cast)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreditsResponseModel() when $default != null:
        return $default(_that.id, _that.cast);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CreditsResponseModel implements CreditsResponseModel {
  const _CreditsResponseModel(
      {required this.id, required final List<CastModel> cast})
      : _cast = cast;
  factory _CreditsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CreditsResponseModelFromJson(json);

  @override
  final int id;
  final List<CastModel> _cast;
  @override
  List<CastModel> get cast {
    if (_cast is EqualUnmodifiableListView) return _cast;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cast);
  }

  /// Create a copy of CreditsResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CreditsResponseModelCopyWith<_CreditsResponseModel> get copyWith =>
      __$CreditsResponseModelCopyWithImpl<_CreditsResponseModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CreditsResponseModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CreditsResponseModel &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._cast, _cast));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, const DeepCollectionEquality().hash(_cast));

  @override
  String toString() {
    return 'CreditsResponseModel(id: $id, cast: $cast)';
  }
}

/// @nodoc
abstract mixin class _$CreditsResponseModelCopyWith<$Res>
    implements $CreditsResponseModelCopyWith<$Res> {
  factory _$CreditsResponseModelCopyWith(_CreditsResponseModel value,
          $Res Function(_CreditsResponseModel) _then) =
      __$CreditsResponseModelCopyWithImpl;
  @override
  @useResult
  $Res call({int id, List<CastModel> cast});
}

/// @nodoc
class __$CreditsResponseModelCopyWithImpl<$Res>
    implements _$CreditsResponseModelCopyWith<$Res> {
  __$CreditsResponseModelCopyWithImpl(this._self, this._then);

  final _CreditsResponseModel _self;
  final $Res Function(_CreditsResponseModel) _then;

  /// Create a copy of CreditsResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? cast = null,
  }) {
    return _then(_CreditsResponseModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      cast: null == cast
          ? _self._cast
          : cast // ignore: cast_nullable_to_non_nullable
              as List<CastModel>,
    ));
  }
}

// dart format on
