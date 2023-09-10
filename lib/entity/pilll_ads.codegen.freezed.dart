// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pilll_ads.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PilllAds _$PilllAdsFromJson(Map<String, dynamic> json) {
  return _PilllAds.fromJson(json);
}

/// @nodoc
mixin _$PilllAds {
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get startDateTime => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get endDateTime => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get imageURL => throw _privateConstructorUsedError;
  String get destinationURL => throw _privateConstructorUsedError;
  String get hexColor =>
      throw _privateConstructorUsedError; // このフィールドの値より高い場合には、広告を表示しないので超すことは無い値をデフォルト値としている
  String get version => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PilllAdsCopyWith<PilllAds> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PilllAdsCopyWith<$Res> {
  factory $PilllAdsCopyWith(PilllAds value, $Res Function(PilllAds) then) =
      _$PilllAdsCopyWithImpl<$Res, PilllAds>;
  @useResult
  $Res call(
      {@JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      DateTime startDateTime,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      DateTime endDateTime,
      String description,
      String? imageURL,
      String destinationURL,
      String hexColor,
      String version});
}

/// @nodoc
class _$PilllAdsCopyWithImpl<$Res, $Val extends PilllAds>
    implements $PilllAdsCopyWith<$Res> {
  _$PilllAdsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDateTime = null,
    Object? endDateTime = null,
    Object? description = null,
    Object? imageURL = freezed,
    Object? destinationURL = null,
    Object? hexColor = null,
    Object? version = null,
  }) {
    return _then(_value.copyWith(
      startDateTime: null == startDateTime
          ? _value.startDateTime
          : startDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDateTime: null == endDateTime
          ? _value.endDateTime
          : endDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageURL: freezed == imageURL
          ? _value.imageURL
          : imageURL // ignore: cast_nullable_to_non_nullable
              as String?,
      destinationURL: null == destinationURL
          ? _value.destinationURL
          : destinationURL // ignore: cast_nullable_to_non_nullable
              as String,
      hexColor: null == hexColor
          ? _value.hexColor
          : hexColor // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PilllAdsCopyWith<$Res> implements $PilllAdsCopyWith<$Res> {
  factory _$$_PilllAdsCopyWith(
          _$_PilllAds value, $Res Function(_$_PilllAds) then) =
      __$$_PilllAdsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      DateTime startDateTime,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      DateTime endDateTime,
      String description,
      String? imageURL,
      String destinationURL,
      String hexColor,
      String version});
}

/// @nodoc
class __$$_PilllAdsCopyWithImpl<$Res>
    extends _$PilllAdsCopyWithImpl<$Res, _$_PilllAds>
    implements _$$_PilllAdsCopyWith<$Res> {
  __$$_PilllAdsCopyWithImpl(
      _$_PilllAds _value, $Res Function(_$_PilllAds) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDateTime = null,
    Object? endDateTime = null,
    Object? description = null,
    Object? imageURL = freezed,
    Object? destinationURL = null,
    Object? hexColor = null,
    Object? version = null,
  }) {
    return _then(_$_PilllAds(
      startDateTime: null == startDateTime
          ? _value.startDateTime
          : startDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDateTime: null == endDateTime
          ? _value.endDateTime
          : endDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageURL: freezed == imageURL
          ? _value.imageURL
          : imageURL // ignore: cast_nullable_to_non_nullable
              as String?,
      destinationURL: null == destinationURL
          ? _value.destinationURL
          : destinationURL // ignore: cast_nullable_to_non_nullable
              as String,
      hexColor: null == hexColor
          ? _value.hexColor
          : hexColor // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_PilllAds extends _PilllAds {
  _$_PilllAds(
      {@JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      required this.startDateTime,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      required this.endDateTime,
      required this.description,
      required this.imageURL,
      required this.destinationURL,
      required this.hexColor,
      this.version = "999.999.999"})
      : super._();

  factory _$_PilllAds.fromJson(Map<String, dynamic> json) =>
      _$$_PilllAdsFromJson(json);

  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime startDateTime;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime endDateTime;
  @override
  final String description;
  @override
  final String? imageURL;
  @override
  final String destinationURL;
  @override
  final String hexColor;
// このフィールドの値より高い場合には、広告を表示しないので超すことは無い値をデフォルト値としている
  @override
  @JsonKey()
  final String version;

  @override
  String toString() {
    return 'PilllAds(startDateTime: $startDateTime, endDateTime: $endDateTime, description: $description, imageURL: $imageURL, destinationURL: $destinationURL, hexColor: $hexColor, version: $version)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PilllAds &&
            (identical(other.startDateTime, startDateTime) ||
                other.startDateTime == startDateTime) &&
            (identical(other.endDateTime, endDateTime) ||
                other.endDateTime == endDateTime) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageURL, imageURL) ||
                other.imageURL == imageURL) &&
            (identical(other.destinationURL, destinationURL) ||
                other.destinationURL == destinationURL) &&
            (identical(other.hexColor, hexColor) ||
                other.hexColor == hexColor) &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, startDateTime, endDateTime,
      description, imageURL, destinationURL, hexColor, version);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PilllAdsCopyWith<_$_PilllAds> get copyWith =>
      __$$_PilllAdsCopyWithImpl<_$_PilllAds>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PilllAdsToJson(
      this,
    );
  }
}

abstract class _PilllAds extends PilllAds {
  factory _PilllAds(
      {@JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      required final DateTime startDateTime,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      required final DateTime endDateTime,
      required final String description,
      required final String? imageURL,
      required final String destinationURL,
      required final String hexColor,
      final String version}) = _$_PilllAds;
  _PilllAds._() : super._();

  factory _PilllAds.fromJson(Map<String, dynamic> json) = _$_PilllAds.fromJson;

  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get startDateTime;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get endDateTime;
  @override
  String get description;
  @override
  String? get imageURL;
  @override
  String get destinationURL;
  @override
  String get hexColor;
  @override // このフィールドの値より高い場合には、広告を表示しないので超すことは無い値をデフォルト値としている
  String get version;
  @override
  @JsonKey(ignore: true)
  _$$_PilllAdsCopyWith<_$_PilllAds> get copyWith =>
      throw _privateConstructorUsedError;
}
