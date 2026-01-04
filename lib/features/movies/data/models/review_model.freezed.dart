// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthorDetails {
  @JsonKey(name: 'name')
  String? get name;
  @JsonKey(name: 'username')
  String? get username;
  @JsonKey(name: 'avatar_path')
  String? get avatarPath;
  @JsonKey(name: 'rating')
  double? get rating;

  /// Create a copy of AuthorDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthorDetailsCopyWith<AuthorDetails> get copyWith =>
      _$AuthorDetailsCopyWithImpl<AuthorDetails>(
          this as AuthorDetails, _$identity);

  /// Serializes this AuthorDetails to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthorDetails &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.avatarPath, avatarPath) ||
                other.avatarPath == avatarPath) &&
            (identical(other.rating, rating) || other.rating == rating));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, username, avatarPath, rating);

  @override
  String toString() {
    return 'AuthorDetails(name: $name, username: $username, avatarPath: $avatarPath, rating: $rating)';
  }
}

/// @nodoc
abstract mixin class $AuthorDetailsCopyWith<$Res> {
  factory $AuthorDetailsCopyWith(
          AuthorDetails value, $Res Function(AuthorDetails) _then) =
      _$AuthorDetailsCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String? name,
      @JsonKey(name: 'username') String? username,
      @JsonKey(name: 'avatar_path') String? avatarPath,
      @JsonKey(name: 'rating') double? rating});
}

/// @nodoc
class _$AuthorDetailsCopyWithImpl<$Res>
    implements $AuthorDetailsCopyWith<$Res> {
  _$AuthorDetailsCopyWithImpl(this._self, this._then);

  final AuthorDetails _self;
  final $Res Function(AuthorDetails) _then;

  /// Create a copy of AuthorDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? username = freezed,
    Object? avatarPath = freezed,
    Object? rating = freezed,
  }) {
    return _then(_self.copyWith(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      username: freezed == username
          ? _self.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarPath: freezed == avatarPath
          ? _self.avatarPath
          : avatarPath // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// Adds pattern-matching-related methods to [AuthorDetails].
extension AuthorDetailsPatterns on AuthorDetails {
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
    TResult Function(_AuthorDetails value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthorDetails() when $default != null:
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
    TResult Function(_AuthorDetails value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthorDetails():
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
    TResult? Function(_AuthorDetails value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthorDetails() when $default != null:
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
            @JsonKey(name: 'name') String? name,
            @JsonKey(name: 'username') String? username,
            @JsonKey(name: 'avatar_path') String? avatarPath,
            @JsonKey(name: 'rating') double? rating)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthorDetails() when $default != null:
        return $default(
            _that.name, _that.username, _that.avatarPath, _that.rating);
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
            @JsonKey(name: 'name') String? name,
            @JsonKey(name: 'username') String? username,
            @JsonKey(name: 'avatar_path') String? avatarPath,
            @JsonKey(name: 'rating') double? rating)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthorDetails():
        return $default(
            _that.name, _that.username, _that.avatarPath, _that.rating);
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
            @JsonKey(name: 'name') String? name,
            @JsonKey(name: 'username') String? username,
            @JsonKey(name: 'avatar_path') String? avatarPath,
            @JsonKey(name: 'rating') double? rating)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthorDetails() when $default != null:
        return $default(
            _that.name, _that.username, _that.avatarPath, _that.rating);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AuthorDetails implements AuthorDetails {
  const _AuthorDetails(
      {@JsonKey(name: 'name') this.name,
      @JsonKey(name: 'username') this.username,
      @JsonKey(name: 'avatar_path') this.avatarPath,
      @JsonKey(name: 'rating') this.rating});
  factory _AuthorDetails.fromJson(Map<String, dynamic> json) =>
      _$AuthorDetailsFromJson(json);

  @override
  @JsonKey(name: 'name')
  final String? name;
  @override
  @JsonKey(name: 'username')
  final String? username;
  @override
  @JsonKey(name: 'avatar_path')
  final String? avatarPath;
  @override
  @JsonKey(name: 'rating')
  final double? rating;

  /// Create a copy of AuthorDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AuthorDetailsCopyWith<_AuthorDetails> get copyWith =>
      __$AuthorDetailsCopyWithImpl<_AuthorDetails>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AuthorDetailsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AuthorDetails &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.avatarPath, avatarPath) ||
                other.avatarPath == avatarPath) &&
            (identical(other.rating, rating) || other.rating == rating));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, username, avatarPath, rating);

  @override
  String toString() {
    return 'AuthorDetails(name: $name, username: $username, avatarPath: $avatarPath, rating: $rating)';
  }
}

/// @nodoc
abstract mixin class _$AuthorDetailsCopyWith<$Res>
    implements $AuthorDetailsCopyWith<$Res> {
  factory _$AuthorDetailsCopyWith(
          _AuthorDetails value, $Res Function(_AuthorDetails) _then) =
      __$AuthorDetailsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String? name,
      @JsonKey(name: 'username') String? username,
      @JsonKey(name: 'avatar_path') String? avatarPath,
      @JsonKey(name: 'rating') double? rating});
}

/// @nodoc
class __$AuthorDetailsCopyWithImpl<$Res>
    implements _$AuthorDetailsCopyWith<$Res> {
  __$AuthorDetailsCopyWithImpl(this._self, this._then);

  final _AuthorDetails _self;
  final $Res Function(_AuthorDetails) _then;

  /// Create a copy of AuthorDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = freezed,
    Object? username = freezed,
    Object? avatarPath = freezed,
    Object? rating = freezed,
  }) {
    return _then(_AuthorDetails(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      username: freezed == username
          ? _self.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarPath: freezed == avatarPath
          ? _self.avatarPath
          : avatarPath // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
mixin _$ReviewModel {
  String get id;
  String get author;
  @JsonKey(name: 'author_details')
  AuthorDetails? get authorDetails;
  String get content;
  @JsonKey(name: 'created_at')
  String get createdAt;
  String get url;

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReviewModelCopyWith<ReviewModel> get copyWith =>
      _$ReviewModelCopyWithImpl<ReviewModel>(this as ReviewModel, _$identity);

  /// Serializes this ReviewModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReviewModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.authorDetails, authorDetails) ||
                other.authorDetails == authorDetails) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, author, authorDetails, content, createdAt, url);

  @override
  String toString() {
    return 'ReviewModel(id: $id, author: $author, authorDetails: $authorDetails, content: $content, createdAt: $createdAt, url: $url)';
  }
}

/// @nodoc
abstract mixin class $ReviewModelCopyWith<$Res> {
  factory $ReviewModelCopyWith(
          ReviewModel value, $Res Function(ReviewModel) _then) =
      _$ReviewModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String author,
      @JsonKey(name: 'author_details') AuthorDetails? authorDetails,
      String content,
      @JsonKey(name: 'created_at') String createdAt,
      String url});

  $AuthorDetailsCopyWith<$Res>? get authorDetails;
}

/// @nodoc
class _$ReviewModelCopyWithImpl<$Res> implements $ReviewModelCopyWith<$Res> {
  _$ReviewModelCopyWithImpl(this._self, this._then);

  final ReviewModel _self;
  final $Res Function(ReviewModel) _then;

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? author = null,
    Object? authorDetails = freezed,
    Object? content = null,
    Object? createdAt = null,
    Object? url = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _self.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      authorDetails: freezed == authorDetails
          ? _self.authorDetails
          : authorDetails // ignore: cast_nullable_to_non_nullable
              as AuthorDetails?,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthorDetailsCopyWith<$Res>? get authorDetails {
    if (_self.authorDetails == null) {
      return null;
    }

    return $AuthorDetailsCopyWith<$Res>(_self.authorDetails!, (value) {
      return _then(_self.copyWith(authorDetails: value));
    });
  }
}

/// Adds pattern-matching-related methods to [ReviewModel].
extension ReviewModelPatterns on ReviewModel {
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
    TResult Function(_ReviewModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReviewModel() when $default != null:
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
    TResult Function(_ReviewModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReviewModel():
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
    TResult? Function(_ReviewModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReviewModel() when $default != null:
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
            String id,
            String author,
            @JsonKey(name: 'author_details') AuthorDetails? authorDetails,
            String content,
            @JsonKey(name: 'created_at') String createdAt,
            String url)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReviewModel() when $default != null:
        return $default(_that.id, _that.author, _that.authorDetails,
            _that.content, _that.createdAt, _that.url);
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
            String id,
            String author,
            @JsonKey(name: 'author_details') AuthorDetails? authorDetails,
            String content,
            @JsonKey(name: 'created_at') String createdAt,
            String url)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReviewModel():
        return $default(_that.id, _that.author, _that.authorDetails,
            _that.content, _that.createdAt, _that.url);
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
            String id,
            String author,
            @JsonKey(name: 'author_details') AuthorDetails? authorDetails,
            String content,
            @JsonKey(name: 'created_at') String createdAt,
            String url)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReviewModel() when $default != null:
        return $default(_that.id, _that.author, _that.authorDetails,
            _that.content, _that.createdAt, _that.url);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ReviewModel extends ReviewModel {
  const _ReviewModel(
      {required this.id,
      required this.author,
      @JsonKey(name: 'author_details') this.authorDetails,
      required this.content,
      @JsonKey(name: 'created_at') required this.createdAt,
      required this.url})
      : super._();
  factory _ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  @override
  final String id;
  @override
  final String author;
  @override
  @JsonKey(name: 'author_details')
  final AuthorDetails? authorDetails;
  @override
  final String content;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  final String url;

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ReviewModelCopyWith<_ReviewModel> get copyWith =>
      __$ReviewModelCopyWithImpl<_ReviewModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ReviewModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReviewModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.authorDetails, authorDetails) ||
                other.authorDetails == authorDetails) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, author, authorDetails, content, createdAt, url);

  @override
  String toString() {
    return 'ReviewModel(id: $id, author: $author, authorDetails: $authorDetails, content: $content, createdAt: $createdAt, url: $url)';
  }
}

/// @nodoc
abstract mixin class _$ReviewModelCopyWith<$Res>
    implements $ReviewModelCopyWith<$Res> {
  factory _$ReviewModelCopyWith(
          _ReviewModel value, $Res Function(_ReviewModel) _then) =
      __$ReviewModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String author,
      @JsonKey(name: 'author_details') AuthorDetails? authorDetails,
      String content,
      @JsonKey(name: 'created_at') String createdAt,
      String url});

  @override
  $AuthorDetailsCopyWith<$Res>? get authorDetails;
}

/// @nodoc
class __$ReviewModelCopyWithImpl<$Res> implements _$ReviewModelCopyWith<$Res> {
  __$ReviewModelCopyWithImpl(this._self, this._then);

  final _ReviewModel _self;
  final $Res Function(_ReviewModel) _then;

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? author = null,
    Object? authorDetails = freezed,
    Object? content = null,
    Object? createdAt = null,
    Object? url = null,
  }) {
    return _then(_ReviewModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _self.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      authorDetails: freezed == authorDetails
          ? _self.authorDetails
          : authorDetails // ignore: cast_nullable_to_non_nullable
              as AuthorDetails?,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthorDetailsCopyWith<$Res>? get authorDetails {
    if (_self.authorDetails == null) {
      return null;
    }

    return $AuthorDetailsCopyWith<$Res>(_self.authorDetails!, (value) {
      return _then(_self.copyWith(authorDetails: value));
    });
  }
}

/// @nodoc
mixin _$ReviewsResponseModel {
  int get id;
  int get page;
  List<ReviewModel> get results;
  @JsonKey(name: 'total_pages')
  int get totalPages;
  @JsonKey(name: 'total_results')
  int get totalResults;

  /// Create a copy of ReviewsResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReviewsResponseModelCopyWith<ReviewsResponseModel> get copyWith =>
      _$ReviewsResponseModelCopyWithImpl<ReviewsResponseModel>(
          this as ReviewsResponseModel, _$identity);

  /// Serializes this ReviewsResponseModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReviewsResponseModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.page, page) || other.page == page) &&
            const DeepCollectionEquality().equals(other.results, results) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.totalResults, totalResults) ||
                other.totalResults == totalResults));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, page,
      const DeepCollectionEquality().hash(results), totalPages, totalResults);

  @override
  String toString() {
    return 'ReviewsResponseModel(id: $id, page: $page, results: $results, totalPages: $totalPages, totalResults: $totalResults)';
  }
}

/// @nodoc
abstract mixin class $ReviewsResponseModelCopyWith<$Res> {
  factory $ReviewsResponseModelCopyWith(ReviewsResponseModel value,
          $Res Function(ReviewsResponseModel) _then) =
      _$ReviewsResponseModelCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      int page,
      List<ReviewModel> results,
      @JsonKey(name: 'total_pages') int totalPages,
      @JsonKey(name: 'total_results') int totalResults});
}

/// @nodoc
class _$ReviewsResponseModelCopyWithImpl<$Res>
    implements $ReviewsResponseModelCopyWith<$Res> {
  _$ReviewsResponseModelCopyWithImpl(this._self, this._then);

  final ReviewsResponseModel _self;
  final $Res Function(ReviewsResponseModel) _then;

  /// Create a copy of ReviewsResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? page = null,
    Object? results = null,
    Object? totalPages = null,
    Object? totalResults = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      results: null == results
          ? _self.results
          : results // ignore: cast_nullable_to_non_nullable
              as List<ReviewModel>,
      totalPages: null == totalPages
          ? _self.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      totalResults: null == totalResults
          ? _self.totalResults
          : totalResults // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [ReviewsResponseModel].
extension ReviewsResponseModelPatterns on ReviewsResponseModel {
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
    TResult Function(_ReviewsResponseModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReviewsResponseModel() when $default != null:
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
    TResult Function(_ReviewsResponseModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReviewsResponseModel():
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
    TResult? Function(_ReviewsResponseModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReviewsResponseModel() when $default != null:
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
            int page,
            List<ReviewModel> results,
            @JsonKey(name: 'total_pages') int totalPages,
            @JsonKey(name: 'total_results') int totalResults)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReviewsResponseModel() when $default != null:
        return $default(_that.id, _that.page, _that.results, _that.totalPages,
            _that.totalResults);
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
            int page,
            List<ReviewModel> results,
            @JsonKey(name: 'total_pages') int totalPages,
            @JsonKey(name: 'total_results') int totalResults)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReviewsResponseModel():
        return $default(_that.id, _that.page, _that.results, _that.totalPages,
            _that.totalResults);
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
            int page,
            List<ReviewModel> results,
            @JsonKey(name: 'total_pages') int totalPages,
            @JsonKey(name: 'total_results') int totalResults)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReviewsResponseModel() when $default != null:
        return $default(_that.id, _that.page, _that.results, _that.totalPages,
            _that.totalResults);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ReviewsResponseModel implements ReviewsResponseModel {
  const _ReviewsResponseModel(
      {required this.id,
      required this.page,
      required final List<ReviewModel> results,
      @JsonKey(name: 'total_pages') required this.totalPages,
      @JsonKey(name: 'total_results') required this.totalResults})
      : _results = results;
  factory _ReviewsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewsResponseModelFromJson(json);

  @override
  final int id;
  @override
  final int page;
  final List<ReviewModel> _results;
  @override
  List<ReviewModel> get results {
    if (_results is EqualUnmodifiableListView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_results);
  }

  @override
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @override
  @JsonKey(name: 'total_results')
  final int totalResults;

  /// Create a copy of ReviewsResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ReviewsResponseModelCopyWith<_ReviewsResponseModel> get copyWith =>
      __$ReviewsResponseModelCopyWithImpl<_ReviewsResponseModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ReviewsResponseModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReviewsResponseModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.page, page) || other.page == page) &&
            const DeepCollectionEquality().equals(other._results, _results) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.totalResults, totalResults) ||
                other.totalResults == totalResults));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, page,
      const DeepCollectionEquality().hash(_results), totalPages, totalResults);

  @override
  String toString() {
    return 'ReviewsResponseModel(id: $id, page: $page, results: $results, totalPages: $totalPages, totalResults: $totalResults)';
  }
}

/// @nodoc
abstract mixin class _$ReviewsResponseModelCopyWith<$Res>
    implements $ReviewsResponseModelCopyWith<$Res> {
  factory _$ReviewsResponseModelCopyWith(_ReviewsResponseModel value,
          $Res Function(_ReviewsResponseModel) _then) =
      __$ReviewsResponseModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      int page,
      List<ReviewModel> results,
      @JsonKey(name: 'total_pages') int totalPages,
      @JsonKey(name: 'total_results') int totalResults});
}

/// @nodoc
class __$ReviewsResponseModelCopyWithImpl<$Res>
    implements _$ReviewsResponseModelCopyWith<$Res> {
  __$ReviewsResponseModelCopyWithImpl(this._self, this._then);

  final _ReviewsResponseModel _self;
  final $Res Function(_ReviewsResponseModel) _then;

  /// Create a copy of ReviewsResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? page = null,
    Object? results = null,
    Object? totalPages = null,
    Object? totalResults = null,
  }) {
    return _then(_ReviewsResponseModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      results: null == results
          ? _self._results
          : results // ignore: cast_nullable_to_non_nullable
              as List<ReviewModel>,
      totalPages: null == totalPages
          ? _self.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      totalResults: null == totalResults
          ? _self.totalResults
          : totalResults // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
