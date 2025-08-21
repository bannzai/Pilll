// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diary_setting.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DiarySetting _$DiarySettingFromJson(Map<String, dynamic> json) {
  return _DiarySetting.fromJson(json);
}

/// @nodoc
mixin _$DiarySetting {
  /// 日記機能で選択可能な体調項目のリスト
  /// デフォルトでは事前定義された14種類の体調項目が設定される
  /// ユーザーによる項目のカスタマイズが可能
  List<String> get physicalConditions => throw _privateConstructorUsedError;

  /// 設定が作成された日時
  /// Firestoreのタイムスタンプ形式で保存され、読み書き時に自動変換される
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this DiarySetting to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiarySetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiarySettingCopyWith<DiarySetting> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiarySettingCopyWith<$Res> {
  factory $DiarySettingCopyWith(DiarySetting value, $Res Function(DiarySetting) then) = _$DiarySettingCopyWithImpl<$Res, DiarySetting>;
  @useResult
  $Res call(
      {List<String> physicalConditions,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime createdAt});
}

/// @nodoc
class _$DiarySettingCopyWithImpl<$Res, $Val extends DiarySetting> implements $DiarySettingCopyWith<$Res> {
  _$DiarySettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiarySetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? physicalConditions = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      physicalConditions: null == physicalConditions
          ? _value.physicalConditions
          : physicalConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DiarySettingImplCopyWith<$Res> implements $DiarySettingCopyWith<$Res> {
  factory _$$DiarySettingImplCopyWith(_$DiarySettingImpl value, $Res Function(_$DiarySettingImpl) then) = __$$DiarySettingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> physicalConditions,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime createdAt});
}

/// @nodoc
class __$$DiarySettingImplCopyWithImpl<$Res> extends _$DiarySettingCopyWithImpl<$Res, _$DiarySettingImpl>
    implements _$$DiarySettingImplCopyWith<$Res> {
  __$$DiarySettingImplCopyWithImpl(_$DiarySettingImpl _value, $Res Function(_$DiarySettingImpl) _then) : super(_value, _then);

  /// Create a copy of DiarySetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? physicalConditions = null,
    Object? createdAt = null,
  }) {
    return _then(_$DiarySettingImpl(
      physicalConditions: null == physicalConditions
          ? _value._physicalConditions
          : physicalConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$DiarySettingImpl extends _DiarySetting with DiagnosticableTreeMixin {
  const _$DiarySettingImpl(
      {final List<String> physicalConditions = defaultPhysicalConditions,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      required this.createdAt})
      : _physicalConditions = physicalConditions,
        super._();

  factory _$DiarySettingImpl.fromJson(Map<String, dynamic> json) => _$$DiarySettingImplFromJson(json);

  /// 日記機能で選択可能な体調項目のリスト
  /// デフォルトでは事前定義された14種類の体調項目が設定される
  /// ユーザーによる項目のカスタマイズが可能
  final List<String> _physicalConditions;

  /// 日記機能で選択可能な体調項目のリスト
  /// デフォルトでは事前定義された14種類の体調項目が設定される
  /// ユーザーによる項目のカスタマイズが可能
  @override
  @JsonKey()
  List<String> get physicalConditions {
    if (_physicalConditions is EqualUnmodifiableListView) return _physicalConditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_physicalConditions);
  }

  /// 設定が作成された日時
  /// Firestoreのタイムスタンプ形式で保存され、読み書き時に自動変換される
  @override
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime createdAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DiarySetting(physicalConditions: $physicalConditions, createdAt: $createdAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DiarySetting'))
      ..add(DiagnosticsProperty('physicalConditions', physicalConditions))
      ..add(DiagnosticsProperty('createdAt', createdAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiarySettingImpl &&
            const DeepCollectionEquality().equals(other._physicalConditions, _physicalConditions) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, const DeepCollectionEquality().hash(_physicalConditions), createdAt);

  /// Create a copy of DiarySetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiarySettingImplCopyWith<_$DiarySettingImpl> get copyWith => __$$DiarySettingImplCopyWithImpl<_$DiarySettingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DiarySettingImplToJson(
      this,
    );
  }
}

abstract class _DiarySetting extends DiarySetting {
  const factory _DiarySetting(
      {final List<String> physicalConditions,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      required final DateTime createdAt}) = _$DiarySettingImpl;
  const _DiarySetting._() : super._();

  factory _DiarySetting.fromJson(Map<String, dynamic> json) = _$DiarySettingImpl.fromJson;

  /// 日記機能で選択可能な体調項目のリスト
  /// デフォルトでは事前定義された14種類の体調項目が設定される
  /// ユーザーによる項目のカスタマイズが可能
  @override
  List<String> get physicalConditions;

  /// 設定が作成された日時
  /// Firestoreのタイムスタンプ形式で保存され、読み書き時に自動変換される
  @override
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdAt;

  /// Create a copy of DiarySetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiarySettingImplCopyWith<_$DiarySettingImpl> get copyWith => throw _privateConstructorUsedError;
}
