// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diary.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Diary _$DiaryFromJson(Map<String, dynamic> json) {
  return _Diary.fromJson(json);
}

/// @nodoc
mixin _$Diary {
  /// 日記の対象日付
  ///
  /// 日記エントリが作成された日付を表す
  /// Firestoreとの変換時にTimestampConverterを使用
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get date => throw _privateConstructorUsedError;

  /// 日記の作成日時
  ///
  /// 日記が実際に作成された日時を記録
  /// 古いデータでは存在しない可能性があるためnullable
  // NOTE: OLD data does't have createdAt
  @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// 体調状態の総合評価
  ///
  /// fine（良好）またはbad（不調）の2段階評価
  /// 未選択の場合はnull
  PhysicalConditionStatus? get physicalConditionStatus => throw _privateConstructorUsedError;

  /// 詳細な体調状態のリスト
  ///
  /// ユーザーが選択した具体的な体調症状を文字列で保存
  /// 空のリストも許可される
  List<String> get physicalConditions => throw _privateConstructorUsedError;

  /// 性行為の有無
  ///
  /// 妊娠リスクの管理のために記録される
  /// trueの場合は性行為あり、falseの場合はなし
  bool get hasSex => throw _privateConstructorUsedError;

  /// 自由記述のメモ
  ///
  /// ユーザーが自由にテキストを入力できるフィールド
  /// 空文字列も許可される
  String get memo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DiaryCopyWith<Diary> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiaryCopyWith<$Res> {
  factory $DiaryCopyWith(Diary value, $Res Function(Diary) then) = _$DiaryCopyWithImpl<$Res, Diary>;
  @useResult
  $Res call({
    @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime date,
    @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? createdAt,
    PhysicalConditionStatus? physicalConditionStatus,
    List<String> physicalConditions,
    bool hasSex,
    String memo,
  });
}

/// @nodoc
class _$DiaryCopyWithImpl<$Res, $Val extends Diary> implements $DiaryCopyWith<$Res> {
  _$DiaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? createdAt = freezed,
    Object? physicalConditionStatus = freezed,
    Object? physicalConditions = null,
    Object? hasSex = null,
    Object? memo = null,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            physicalConditionStatus: freezed == physicalConditionStatus
                ? _value.physicalConditionStatus
                : physicalConditionStatus // ignore: cast_nullable_to_non_nullable
                      as PhysicalConditionStatus?,
            physicalConditions: null == physicalConditions
                ? _value.physicalConditions
                : physicalConditions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            hasSex: null == hasSex
                ? _value.hasSex
                : hasSex // ignore: cast_nullable_to_non_nullable
                      as bool,
            memo: null == memo
                ? _value.memo
                : memo // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DiaryImplCopyWith<$Res> implements $DiaryCopyWith<$Res> {
  factory _$$DiaryImplCopyWith(_$DiaryImpl value, $Res Function(_$DiaryImpl) then) = __$$DiaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime date,
    @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? createdAt,
    PhysicalConditionStatus? physicalConditionStatus,
    List<String> physicalConditions,
    bool hasSex,
    String memo,
  });
}

/// @nodoc
class __$$DiaryImplCopyWithImpl<$Res> extends _$DiaryCopyWithImpl<$Res, _$DiaryImpl> implements _$$DiaryImplCopyWith<$Res> {
  __$$DiaryImplCopyWithImpl(_$DiaryImpl _value, $Res Function(_$DiaryImpl) _then) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? createdAt = freezed,
    Object? physicalConditionStatus = freezed,
    Object? physicalConditions = null,
    Object? hasSex = null,
    Object? memo = null,
  }) {
    return _then(
      _$DiaryImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        physicalConditionStatus: freezed == physicalConditionStatus
            ? _value.physicalConditionStatus
            : physicalConditionStatus // ignore: cast_nullable_to_non_nullable
                  as PhysicalConditionStatus?,
        physicalConditions: null == physicalConditions
            ? _value._physicalConditions
            : physicalConditions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        hasSex: null == hasSex
            ? _value.hasSex
            : hasSex // ignore: cast_nullable_to_non_nullable
                  as bool,
        memo: null == memo
            ? _value.memo
            : memo // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$DiaryImpl extends _Diary {
  const _$DiaryImpl({
    @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.date,
    @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) required this.createdAt,
    this.physicalConditionStatus,
    required final List<String> physicalConditions,
    required this.hasSex,
    required this.memo,
  }) : _physicalConditions = physicalConditions,
       super._();

  factory _$DiaryImpl.fromJson(Map<String, dynamic> json) => _$$DiaryImplFromJson(json);

  /// 日記の対象日付
  ///
  /// 日記エントリが作成された日付を表す
  /// Firestoreとの変換時にTimestampConverterを使用
  @override
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime date;

  /// 日記の作成日時
  ///
  /// 日記が実際に作成された日時を記録
  /// 古いデータでは存在しない可能性があるためnullable
  // NOTE: OLD data does't have createdAt
  @override
  @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
  final DateTime? createdAt;

  /// 体調状態の総合評価
  ///
  /// fine（良好）またはbad（不調）の2段階評価
  /// 未選択の場合はnull
  @override
  final PhysicalConditionStatus? physicalConditionStatus;

  /// 詳細な体調状態のリスト
  ///
  /// ユーザーが選択した具体的な体調症状を文字列で保存
  /// 空のリストも許可される
  final List<String> _physicalConditions;

  /// 詳細な体調状態のリスト
  ///
  /// ユーザーが選択した具体的な体調症状を文字列で保存
  /// 空のリストも許可される
  @override
  List<String> get physicalConditions {
    if (_physicalConditions is EqualUnmodifiableListView) return _physicalConditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_physicalConditions);
  }

  /// 性行為の有無
  ///
  /// 妊娠リスクの管理のために記録される
  /// trueの場合は性行為あり、falseの場合はなし
  @override
  final bool hasSex;

  /// 自由記述のメモ
  ///
  /// ユーザーが自由にテキストを入力できるフィールド
  /// 空文字列も許可される
  @override
  final String memo;

  @override
  String toString() {
    return 'Diary(date: $date, createdAt: $createdAt, physicalConditionStatus: $physicalConditionStatus, physicalConditions: $physicalConditions, hasSex: $hasSex, memo: $memo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiaryImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.physicalConditionStatus, physicalConditionStatus) || other.physicalConditionStatus == physicalConditionStatus) &&
            const DeepCollectionEquality().equals(other._physicalConditions, _physicalConditions) &&
            (identical(other.hasSex, hasSex) || other.hasSex == hasSex) &&
            (identical(other.memo, memo) || other.memo == memo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, date, createdAt, physicalConditionStatus, const DeepCollectionEquality().hash(_physicalConditions), hasSex, memo);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DiaryImplCopyWith<_$DiaryImpl> get copyWith => __$$DiaryImplCopyWithImpl<_$DiaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DiaryImplToJson(this);
  }
}

abstract class _Diary extends Diary {
  const factory _Diary({
    @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
    required final DateTime date,
    @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) required final DateTime? createdAt,
    final PhysicalConditionStatus? physicalConditionStatus,
    required final List<String> physicalConditions,
    required final bool hasSex,
    required final String memo,
  }) = _$DiaryImpl;
  const _Diary._() : super._();

  factory _Diary.fromJson(Map<String, dynamic> json) = _$DiaryImpl.fromJson;

  @override
  /// 日記の対象日付
  ///
  /// 日記エントリが作成された日付を表す
  /// Firestoreとの変換時にTimestampConverterを使用
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get date;
  @override
  /// 日記の作成日時
  ///
  /// 日記が実際に作成された日時を記録
  /// 古いデータでは存在しない可能性があるためnullable
  // NOTE: OLD data does't have createdAt
  @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get createdAt;
  @override
  /// 体調状態の総合評価
  ///
  /// fine（良好）またはbad（不調）の2段階評価
  /// 未選択の場合はnull
  PhysicalConditionStatus? get physicalConditionStatus;
  @override
  /// 詳細な体調状態のリスト
  ///
  /// ユーザーが選択した具体的な体調症状を文字列で保存
  /// 空のリストも許可される
  List<String> get physicalConditions;
  @override
  /// 性行為の有無
  ///
  /// 妊娠リスクの管理のために記録される
  /// trueの場合は性行為あり、falseの場合はなし
  bool get hasSex;
  @override
  /// 自由記述のメモ
  ///
  /// ユーザーが自由にテキストを入力できるフィールド
  /// 空文字列も許可される
  String get memo;
  @override
  @JsonKey(ignore: true)
  _$$DiaryImplCopyWith<_$DiaryImpl> get copyWith => throw _privateConstructorUsedError;
}
