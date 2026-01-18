// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'menstruation.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Menstruation _$MenstruationFromJson(Map<String, dynamic> json) {
  return _Menstruation.fromJson(json);
}

/// @nodoc
mixin _$Menstruation {
  /// FirestoreドキュメントのID
  /// 新規作成時はnullで、保存時に自動生成される
  @JsonKey(includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;

  /// 生理開始日
  /// 生理周期計算の基準となる重要な日付
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get beginDate => throw _privateConstructorUsedError;

  /// 生理終了日
  /// 生理期間の長さを決定する日付
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get endDate => throw _privateConstructorUsedError;

  /// 論理削除日時
  /// nullの場合は有効な記録、値がある場合は削除済み
  @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// 生理記録の作成日時
  /// データの作成順序や履歴管理に使用される
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// HealthKitサンプルデータのUUID
  /// HealthKitから取得したデータとの紐付けに使用
  String? get healthKitSampleDataUUID => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MenstruationCopyWith<Menstruation> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MenstruationCopyWith<$Res> {
  factory $MenstruationCopyWith(Menstruation value, $Res Function(Menstruation) then) = _$MenstruationCopyWithImpl<$Res, Menstruation>;
  @useResult
  $Res call({
    @JsonKey(includeIfNull: false) String? id,
    @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime beginDate,
    @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime endDate,
    @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? deletedAt,
    @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime createdAt,
    String? healthKitSampleDataUUID,
  });
}

/// @nodoc
class _$MenstruationCopyWithImpl<$Res, $Val extends Menstruation> implements $MenstruationCopyWith<$Res> {
  _$MenstruationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? beginDate = null,
    Object? endDate = null,
    Object? deletedAt = freezed,
    Object? createdAt = null,
    Object? healthKitSampleDataUUID = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            beginDate: null == beginDate
                ? _value.beginDate
                : beginDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            deletedAt: freezed == deletedAt
                ? _value.deletedAt
                : deletedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            healthKitSampleDataUUID: freezed == healthKitSampleDataUUID
                ? _value.healthKitSampleDataUUID
                : healthKitSampleDataUUID // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MenstruationImplCopyWith<$Res> implements $MenstruationCopyWith<$Res> {
  factory _$$MenstruationImplCopyWith(_$MenstruationImpl value, $Res Function(_$MenstruationImpl) then) = __$$MenstruationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(includeIfNull: false) String? id,
    @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime beginDate,
    @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime endDate,
    @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? deletedAt,
    @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime createdAt,
    String? healthKitSampleDataUUID,
  });
}

/// @nodoc
class __$$MenstruationImplCopyWithImpl<$Res> extends _$MenstruationCopyWithImpl<$Res, _$MenstruationImpl>
    implements _$$MenstruationImplCopyWith<$Res> {
  __$$MenstruationImplCopyWithImpl(_$MenstruationImpl _value, $Res Function(_$MenstruationImpl) _then) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? beginDate = null,
    Object? endDate = null,
    Object? deletedAt = freezed,
    Object? createdAt = null,
    Object? healthKitSampleDataUUID = freezed,
  }) {
    return _then(
      _$MenstruationImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        beginDate: null == beginDate
            ? _value.beginDate
            : beginDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        deletedAt: freezed == deletedAt
            ? _value.deletedAt
            : deletedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        healthKitSampleDataUUID: freezed == healthKitSampleDataUUID
            ? _value.healthKitSampleDataUUID
            : healthKitSampleDataUUID // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$MenstruationImpl extends _Menstruation {
  const _$MenstruationImpl({
    @JsonKey(includeIfNull: false) this.id,
    @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.beginDate,
    @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.endDate,
    @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) this.deletedAt,
    @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.createdAt,
    this.healthKitSampleDataUUID,
  }) : super._();

  factory _$MenstruationImpl.fromJson(Map<String, dynamic> json) => _$$MenstruationImplFromJson(json);

  /// FirestoreドキュメントのID
  /// 新規作成時はnullで、保存時に自動生成される
  @override
  @JsonKey(includeIfNull: false)
  final String? id;

  /// 生理開始日
  /// 生理周期計算の基準となる重要な日付
  @override
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime beginDate;

  /// 生理終了日
  /// 生理期間の長さを決定する日付
  @override
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime endDate;

  /// 論理削除日時
  /// nullの場合は有効な記録、値がある場合は削除済み
  @override
  @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
  final DateTime? deletedAt;

  /// 生理記録の作成日時
  /// データの作成順序や履歴管理に使用される
  @override
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime createdAt;

  /// HealthKitサンプルデータのUUID
  /// HealthKitから取得したデータとの紐付けに使用
  @override
  final String? healthKitSampleDataUUID;

  @override
  String toString() {
    return 'Menstruation(id: $id, beginDate: $beginDate, endDate: $endDate, deletedAt: $deletedAt, createdAt: $createdAt, healthKitSampleDataUUID: $healthKitSampleDataUUID)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MenstruationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.beginDate, beginDate) || other.beginDate == beginDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.healthKitSampleDataUUID, healthKitSampleDataUUID) || other.healthKitSampleDataUUID == healthKitSampleDataUUID));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, beginDate, endDate, deletedAt, createdAt, healthKitSampleDataUUID);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MenstruationImplCopyWith<_$MenstruationImpl> get copyWith => __$$MenstruationImplCopyWithImpl<_$MenstruationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MenstruationImplToJson(this);
  }
}

abstract class _Menstruation extends Menstruation {
  const factory _Menstruation({
    @JsonKey(includeIfNull: false) final String? id,
    @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
    required final DateTime beginDate,
    @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
    required final DateTime endDate,
    @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) final DateTime? deletedAt,
    @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
    required final DateTime createdAt,
    final String? healthKitSampleDataUUID,
  }) = _$MenstruationImpl;
  const _Menstruation._() : super._();

  factory _Menstruation.fromJson(Map<String, dynamic> json) = _$MenstruationImpl.fromJson;

  @override
  /// FirestoreドキュメントのID
  /// 新規作成時はnullで、保存時に自動生成される
  @JsonKey(includeIfNull: false)
  String? get id;
  @override
  /// 生理開始日
  /// 生理周期計算の基準となる重要な日付
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get beginDate;
  @override
  /// 生理終了日
  /// 生理期間の長さを決定する日付
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get endDate;
  @override
  /// 論理削除日時
  /// nullの場合は有効な記録、値がある場合は削除済み
  @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get deletedAt;
  @override
  /// 生理記録の作成日時
  /// データの作成順序や履歴管理に使用される
  @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdAt;
  @override
  /// HealthKitサンプルデータのUUID
  /// HealthKitから取得したデータとの紐付けに使用
  String? get healthKitSampleDataUUID;
  @override
  @JsonKey(ignore: true)
  _$$MenstruationImplCopyWith<_$MenstruationImpl> get copyWith => throw _privateConstructorUsedError;
}
