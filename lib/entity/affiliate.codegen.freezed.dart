// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'affiliate.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Affiliate _$AffiliateFromJson(Map<String, dynamic> json) {
  return _Affiliate.fromJson(json);
}

/// @nodoc
mixin _$Affiliate {
  List<AffiliateContent> get contents =>
      throw _privateConstructorUsedError; // このフィールドの値よりパッケージバージョンが高い場合には、広告を表示する。
// なので最も低いバージョンをデフォルト値としている
  String get version => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AffiliateCopyWith<Affiliate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AffiliateCopyWith<$Res> {
  factory $AffiliateCopyWith(Affiliate value, $Res Function(Affiliate) then) =
      _$AffiliateCopyWithImpl<$Res, Affiliate>;
  @useResult
  $Res call({List<AffiliateContent> contents, String version});
}

/// @nodoc
class _$AffiliateCopyWithImpl<$Res, $Val extends Affiliate>
    implements $AffiliateCopyWith<$Res> {
  _$AffiliateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contents = null,
    Object? version = null,
  }) {
    return _then(_value.copyWith(
      contents: null == contents
          ? _value.contents
          : contents // ignore: cast_nullable_to_non_nullable
              as List<AffiliateContent>,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AffiliateCopyWith<$Res> implements $AffiliateCopyWith<$Res> {
  factory _$$_AffiliateCopyWith(
          _$_Affiliate value, $Res Function(_$_Affiliate) then) =
      __$$_AffiliateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<AffiliateContent> contents, String version});
}

/// @nodoc
class __$$_AffiliateCopyWithImpl<$Res>
    extends _$AffiliateCopyWithImpl<$Res, _$_Affiliate>
    implements _$$_AffiliateCopyWith<$Res> {
  __$$_AffiliateCopyWithImpl(
      _$_Affiliate _value, $Res Function(_$_Affiliate) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contents = null,
    Object? version = null,
  }) {
    return _then(_$_Affiliate(
      contents: null == contents
          ? _value._contents
          : contents // ignore: cast_nullable_to_non_nullable
              as List<AffiliateContent>,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_Affiliate extends _Affiliate {
  const _$_Affiliate(
      {required final List<AffiliateContent> contents, this.version = "0.0.0"})
      : _contents = contents,
        super._();

  factory _$_Affiliate.fromJson(Map<String, dynamic> json) =>
      _$$_AffiliateFromJson(json);

  final List<AffiliateContent> _contents;
  @override
  List<AffiliateContent> get contents {
    if (_contents is EqualUnmodifiableListView) return _contents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contents);
  }

// このフィールドの値よりパッケージバージョンが高い場合には、広告を表示する。
// なので最も低いバージョンをデフォルト値としている
  @override
  @JsonKey()
  final String version;

  @override
  String toString() {
    return 'Affiliate(contents: $contents, version: $version)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Affiliate &&
            const DeepCollectionEquality().equals(other._contents, _contents) &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_contents), version);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AffiliateCopyWith<_$_Affiliate> get copyWith =>
      __$$_AffiliateCopyWithImpl<_$_Affiliate>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AffiliateToJson(
      this,
    );
  }
}

abstract class _Affiliate extends Affiliate {
  const factory _Affiliate(
      {required final List<AffiliateContent> contents,
      final String version}) = _$_Affiliate;
  const _Affiliate._() : super._();

  factory _Affiliate.fromJson(Map<String, dynamic> json) =
      _$_Affiliate.fromJson;

  @override
  List<AffiliateContent> get contents;
  @override // このフィールドの値よりパッケージバージョンが高い場合には、広告を表示する。
// なので最も低いバージョンをデフォルト値としている
  String get version;
  @override
  @JsonKey(ignore: true)
  _$$_AffiliateCopyWith<_$_Affiliate> get copyWith =>
      throw _privateConstructorUsedError;
}

AffiliateContent _$AffiliateContentFromJson(Map<String, dynamic> json) {
  return _AffiliateContent.fromJson(json);
}

/// @nodoc
mixin _$AffiliateContent {
  String? get backgroundColorHex => throw _privateConstructorUsedError;
  String get html => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AffiliateContentCopyWith<AffiliateContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AffiliateContentCopyWith<$Res> {
  factory $AffiliateContentCopyWith(
          AffiliateContent value, $Res Function(AffiliateContent) then) =
      _$AffiliateContentCopyWithImpl<$Res, AffiliateContent>;
  @useResult
  $Res call({String? backgroundColorHex, String html});
}

/// @nodoc
class _$AffiliateContentCopyWithImpl<$Res, $Val extends AffiliateContent>
    implements $AffiliateContentCopyWith<$Res> {
  _$AffiliateContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? backgroundColorHex = freezed,
    Object? html = null,
  }) {
    return _then(_value.copyWith(
      backgroundColorHex: freezed == backgroundColorHex
          ? _value.backgroundColorHex
          : backgroundColorHex // ignore: cast_nullable_to_non_nullable
              as String?,
      html: null == html
          ? _value.html
          : html // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AffiliateContentCopyWith<$Res>
    implements $AffiliateContentCopyWith<$Res> {
  factory _$$_AffiliateContentCopyWith(
          _$_AffiliateContent value, $Res Function(_$_AffiliateContent) then) =
      __$$_AffiliateContentCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? backgroundColorHex, String html});
}

/// @nodoc
class __$$_AffiliateContentCopyWithImpl<$Res>
    extends _$AffiliateContentCopyWithImpl<$Res, _$_AffiliateContent>
    implements _$$_AffiliateContentCopyWith<$Res> {
  __$$_AffiliateContentCopyWithImpl(
      _$_AffiliateContent _value, $Res Function(_$_AffiliateContent) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? backgroundColorHex = freezed,
    Object? html = null,
  }) {
    return _then(_$_AffiliateContent(
      backgroundColorHex: freezed == backgroundColorHex
          ? _value.backgroundColorHex
          : backgroundColorHex // ignore: cast_nullable_to_non_nullable
              as String?,
      html: null == html
          ? _value.html
          : html // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_AffiliateContent extends _AffiliateContent {
  const _$_AffiliateContent({this.backgroundColorHex, required this.html})
      : super._();

  factory _$_AffiliateContent.fromJson(Map<String, dynamic> json) =>
      _$$_AffiliateContentFromJson(json);

  @override
  final String? backgroundColorHex;
  @override
  final String html;

  @override
  String toString() {
    return 'AffiliateContent(backgroundColorHex: $backgroundColorHex, html: $html)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AffiliateContent &&
            (identical(other.backgroundColorHex, backgroundColorHex) ||
                other.backgroundColorHex == backgroundColorHex) &&
            (identical(other.html, html) || other.html == html));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, backgroundColorHex, html);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AffiliateContentCopyWith<_$_AffiliateContent> get copyWith =>
      __$$_AffiliateContentCopyWithImpl<_$_AffiliateContent>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AffiliateContentToJson(
      this,
    );
  }
}

abstract class _AffiliateContent extends AffiliateContent {
  const factory _AffiliateContent(
      {final String? backgroundColorHex,
      required final String html}) = _$_AffiliateContent;
  const _AffiliateContent._() : super._();

  factory _AffiliateContent.fromJson(Map<String, dynamic> json) =
      _$_AffiliateContent.fromJson;

  @override
  String? get backgroundColorHex;
  @override
  String get html;
  @override
  @JsonKey(ignore: true)
  _$$_AffiliateContentCopyWith<_$_AffiliateContent> get copyWith =>
      throw _privateConstructorUsedError;
}
