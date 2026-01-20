// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pill_sheet.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PillSheetTypeInfo _$PillSheetTypeInfoFromJson(Map<String, dynamic> json) {
  return _PillSheetTypeInfo.fromJson(json);
}

/// @nodoc
mixin _$PillSheetTypeInfo {
  /// ピルシート種類の参照パス（Firestore参照）
  /// 具体的なピルシート設定情報への参照を保持
  String get pillSheetTypeReferencePath => throw _privateConstructorUsedError;

  /// ピルシート名（例：「マーベロン28」）
  /// ユーザーに表示される商品名
  String get name => throw _privateConstructorUsedError;

  /// ピルシート内の総ピル数
  /// 21錠、28錠など、シートに含まれる全てのピル数
  int get totalCount => throw _privateConstructorUsedError;

  /// 服用期間（実薬期間）の日数
  /// 偽薬を除いた実際に効果のあるピルの服用日数
  int get dosingPeriod => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PillSheetTypeInfoCopyWith<PillSheetTypeInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PillSheetTypeInfoCopyWith<$Res> {
  factory $PillSheetTypeInfoCopyWith(
    PillSheetTypeInfo value,
    $Res Function(PillSheetTypeInfo) then,
  ) = _$PillSheetTypeInfoCopyWithImpl<$Res, PillSheetTypeInfo>;
  @useResult
  $Res call({
    String pillSheetTypeReferencePath,
    String name,
    int totalCount,
    int dosingPeriod,
  });
}

/// @nodoc
class _$PillSheetTypeInfoCopyWithImpl<$Res, $Val extends PillSheetTypeInfo>
    implements $PillSheetTypeInfoCopyWith<$Res> {
  _$PillSheetTypeInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pillSheetTypeReferencePath = null,
    Object? name = null,
    Object? totalCount = null,
    Object? dosingPeriod = null,
  }) {
    return _then(
      _value.copyWith(
            pillSheetTypeReferencePath: null == pillSheetTypeReferencePath
                ? _value.pillSheetTypeReferencePath
                : pillSheetTypeReferencePath // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            totalCount: null == totalCount
                ? _value.totalCount
                : totalCount // ignore: cast_nullable_to_non_nullable
                      as int,
            dosingPeriod: null == dosingPeriod
                ? _value.dosingPeriod
                : dosingPeriod // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PillSheetTypeInfoImplCopyWith<$Res>
    implements $PillSheetTypeInfoCopyWith<$Res> {
  factory _$$PillSheetTypeInfoImplCopyWith(
    _$PillSheetTypeInfoImpl value,
    $Res Function(_$PillSheetTypeInfoImpl) then,
  ) = __$$PillSheetTypeInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String pillSheetTypeReferencePath,
    String name,
    int totalCount,
    int dosingPeriod,
  });
}

/// @nodoc
class __$$PillSheetTypeInfoImplCopyWithImpl<$Res>
    extends _$PillSheetTypeInfoCopyWithImpl<$Res, _$PillSheetTypeInfoImpl>
    implements _$$PillSheetTypeInfoImplCopyWith<$Res> {
  __$$PillSheetTypeInfoImplCopyWithImpl(
    _$PillSheetTypeInfoImpl _value,
    $Res Function(_$PillSheetTypeInfoImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pillSheetTypeReferencePath = null,
    Object? name = null,
    Object? totalCount = null,
    Object? dosingPeriod = null,
  }) {
    return _then(
      _$PillSheetTypeInfoImpl(
        pillSheetTypeReferencePath: null == pillSheetTypeReferencePath
            ? _value.pillSheetTypeReferencePath
            : pillSheetTypeReferencePath // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        totalCount: null == totalCount
            ? _value.totalCount
            : totalCount // ignore: cast_nullable_to_non_nullable
                  as int,
        dosingPeriod: null == dosingPeriod
            ? _value.dosingPeriod
            : dosingPeriod // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$PillSheetTypeInfoImpl implements _PillSheetTypeInfo {
  const _$PillSheetTypeInfoImpl({
    required this.pillSheetTypeReferencePath,
    required this.name,
    required this.totalCount,
    required this.dosingPeriod,
  });

  factory _$PillSheetTypeInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PillSheetTypeInfoImplFromJson(json);

  /// ピルシート種類の参照パス（Firestore参照）
  /// 具体的なピルシート設定情報への参照を保持
  @override
  final String pillSheetTypeReferencePath;

  /// ピルシート名（例：「マーベロン28」）
  /// ユーザーに表示される商品名
  @override
  final String name;

  /// ピルシート内の総ピル数
  /// 21錠、28錠など、シートに含まれる全てのピル数
  @override
  final int totalCount;

  /// 服用期間（実薬期間）の日数
  /// 偽薬を除いた実際に効果のあるピルの服用日数
  @override
  final int dosingPeriod;

  @override
  String toString() {
    return 'PillSheetTypeInfo(pillSheetTypeReferencePath: $pillSheetTypeReferencePath, name: $name, totalCount: $totalCount, dosingPeriod: $dosingPeriod)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PillSheetTypeInfoImpl &&
            (identical(
                  other.pillSheetTypeReferencePath,
                  pillSheetTypeReferencePath,
                ) ||
                other.pillSheetTypeReferencePath ==
                    pillSheetTypeReferencePath) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.dosingPeriod, dosingPeriod) ||
                other.dosingPeriod == dosingPeriod));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    pillSheetTypeReferencePath,
    name,
    totalCount,
    dosingPeriod,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PillSheetTypeInfoImplCopyWith<_$PillSheetTypeInfoImpl> get copyWith =>
      __$$PillSheetTypeInfoImplCopyWithImpl<_$PillSheetTypeInfoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PillSheetTypeInfoImplToJson(this);
  }
}

abstract class _PillSheetTypeInfo implements PillSheetTypeInfo {
  const factory _PillSheetTypeInfo({
    required final String pillSheetTypeReferencePath,
    required final String name,
    required final int totalCount,
    required final int dosingPeriod,
  }) = _$PillSheetTypeInfoImpl;

  factory _PillSheetTypeInfo.fromJson(Map<String, dynamic> json) =
      _$PillSheetTypeInfoImpl.fromJson;

  @override
  /// ピルシート種類の参照パス（Firestore参照）
  /// 具体的なピルシート設定情報への参照を保持
  String get pillSheetTypeReferencePath;
  @override
  /// ピルシート名（例：「マーベロン28」）
  /// ユーザーに表示される商品名
  String get name;
  @override
  /// ピルシート内の総ピル数
  /// 21錠、28錠など、シートに含まれる全てのピル数
  int get totalCount;
  @override
  /// 服用期間（実薬期間）の日数
  /// 偽薬を除いた実際に効果のあるピルの服用日数
  int get dosingPeriod;
  @override
  @JsonKey(ignore: true)
  _$$PillSheetTypeInfoImplCopyWith<_$PillSheetTypeInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RestDuration _$RestDurationFromJson(Map<String, dynamic> json) {
  return _RestDuration.fromJson(json);
}

/// @nodoc
mixin _$RestDuration {
  // from: 2024-03-28の実装時に追加。調査しやすいようにuuidを入れておく
  /// 休薬期間の一意識別子
  /// デバッグや調査時の追跡のためのUUID
  String? get id => throw _privateConstructorUsedError;

  /// 休薬開始日
  /// ユーザーがピル服用を停止した日付
  @JsonKey(
    fromJson: NonNullTimestampConverter.timestampToDateTime,
    toJson: NonNullTimestampConverter.dateTimeToTimestamp,
  )
  DateTime get beginDate => throw _privateConstructorUsedError;
  @JsonKey(
    fromJson: TimestampConverter.timestampToDateTime,
    toJson: TimestampConverter.dateTimeToTimestamp,
  )
  DateTime? get endDate => throw _privateConstructorUsedError;
  @JsonKey(
    fromJson: NonNullTimestampConverter.timestampToDateTime,
    toJson: NonNullTimestampConverter.dateTimeToTimestamp,
  )
  DateTime get createdDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RestDurationCopyWith<RestDuration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RestDurationCopyWith<$Res> {
  factory $RestDurationCopyWith(
    RestDuration value,
    $Res Function(RestDuration) then,
  ) = _$RestDurationCopyWithImpl<$Res, RestDuration>;
  @useResult
  $Res call({
    String? id,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    DateTime beginDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    DateTime? endDate,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    DateTime createdDate,
  });
}

/// @nodoc
class _$RestDurationCopyWithImpl<$Res, $Val extends RestDuration>
    implements $RestDurationCopyWith<$Res> {
  _$RestDurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? beginDate = null,
    Object? endDate = freezed,
    Object? createdDate = null,
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
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdDate: null == createdDate
                ? _value.createdDate
                : createdDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RestDurationImplCopyWith<$Res>
    implements $RestDurationCopyWith<$Res> {
  factory _$$RestDurationImplCopyWith(
    _$RestDurationImpl value,
    $Res Function(_$RestDurationImpl) then,
  ) = __$$RestDurationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    DateTime beginDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    DateTime? endDate,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    DateTime createdDate,
  });
}

/// @nodoc
class __$$RestDurationImplCopyWithImpl<$Res>
    extends _$RestDurationCopyWithImpl<$Res, _$RestDurationImpl>
    implements _$$RestDurationImplCopyWith<$Res> {
  __$$RestDurationImplCopyWithImpl(
    _$RestDurationImpl _value,
    $Res Function(_$RestDurationImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? beginDate = null,
    Object? endDate = freezed,
    Object? createdDate = null,
  }) {
    return _then(
      _$RestDurationImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        beginDate: null == beginDate
            ? _value.beginDate
            : beginDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdDate: null == createdDate
            ? _value.createdDate
            : createdDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$RestDurationImpl extends _RestDuration {
  const _$RestDurationImpl({
    required this.id,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required this.beginDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    this.endDate,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required this.createdDate,
  }) : super._();

  factory _$RestDurationImpl.fromJson(Map<String, dynamic> json) =>
      _$$RestDurationImplFromJson(json);

  // from: 2024-03-28の実装時に追加。調査しやすいようにuuidを入れておく
  /// 休薬期間の一意識別子
  /// デバッグや調査時の追跡のためのUUID
  @override
  final String? id;

  /// 休薬開始日
  /// ユーザーがピル服用を停止した日付
  @override
  @JsonKey(
    fromJson: NonNullTimestampConverter.timestampToDateTime,
    toJson: NonNullTimestampConverter.dateTimeToTimestamp,
  )
  final DateTime beginDate;
  @override
  @JsonKey(
    fromJson: TimestampConverter.timestampToDateTime,
    toJson: TimestampConverter.dateTimeToTimestamp,
  )
  final DateTime? endDate;
  @override
  @JsonKey(
    fromJson: NonNullTimestampConverter.timestampToDateTime,
    toJson: NonNullTimestampConverter.dateTimeToTimestamp,
  )
  final DateTime createdDate;

  @override
  String toString() {
    return 'RestDuration(id: $id, beginDate: $beginDate, endDate: $endDate, createdDate: $createdDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RestDurationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.beginDate, beginDate) ||
                other.beginDate == beginDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.createdDate, createdDate) ||
                other.createdDate == createdDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, beginDate, endDate, createdDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RestDurationImplCopyWith<_$RestDurationImpl> get copyWith =>
      __$$RestDurationImplCopyWithImpl<_$RestDurationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RestDurationImplToJson(this);
  }
}

abstract class _RestDuration extends RestDuration {
  const factory _RestDuration({
    required final String? id,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required final DateTime beginDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    final DateTime? endDate,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required final DateTime createdDate,
  }) = _$RestDurationImpl;
  const _RestDuration._() : super._();

  factory _RestDuration.fromJson(Map<String, dynamic> json) =
      _$RestDurationImpl.fromJson;

  @override // from: 2024-03-28の実装時に追加。調査しやすいようにuuidを入れておく
  /// 休薬期間の一意識別子
  /// デバッグや調査時の追跡のためのUUID
  String? get id;
  @override
  /// 休薬開始日
  /// ユーザーがピル服用を停止した日付
  @JsonKey(
    fromJson: NonNullTimestampConverter.timestampToDateTime,
    toJson: NonNullTimestampConverter.dateTimeToTimestamp,
  )
  DateTime get beginDate;
  @override
  @JsonKey(
    fromJson: TimestampConverter.timestampToDateTime,
    toJson: TimestampConverter.dateTimeToTimestamp,
  )
  DateTime? get endDate;
  @override
  @JsonKey(
    fromJson: NonNullTimestampConverter.timestampToDateTime,
    toJson: NonNullTimestampConverter.dateTimeToTimestamp,
  )
  DateTime get createdDate;
  @override
  @JsonKey(ignore: true)
  _$$RestDurationImplCopyWith<_$RestDurationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PillSheet {
  /// FirestoreドキュメントID
  /// データベース保存時に自動生成される一意識別子
  @JsonKey(includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;

  /// ピルシートの種類情報
  /// シート名、総数、服用期間などの基本設定
  @JsonKey()
  PillSheetTypeInfo get typeInfo => throw _privateConstructorUsedError;

  /// ピルシート開始日
  /// このシートでピル服用を開始した日付
  @JsonKey(
    name: 'beginingDate',
    fromJson: NonNullTimestampConverter.timestampToDateTime,
    toJson: NonNullTimestampConverter.dateTimeToTimestamp,
  )
  DateTime get beginDate => throw _privateConstructorUsedError;
  @JsonKey(
    fromJson: TimestampConverter.timestampToDateTime,
    toJson: TimestampConverter.dateTimeToTimestamp,
  )
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(
    fromJson: TimestampConverter.timestampToDateTime,
    toJson: TimestampConverter.dateTimeToTimestamp,
  )
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// グループインデックス
  /// 複数のピルシートをグループ化する際の順序番号
  int get groupIndex => throw _privateConstructorUsedError;

  /// 休薬期間のリスト
  /// このピルシート期間中の全ての休薬期間記録
  List<RestDuration> get restDurations => throw _privateConstructorUsedError;

  /// バージョン識別子
  String get version => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      @JsonKey(includeIfNull: false) String? id,
      @JsonKey() PillSheetTypeInfo typeInfo,
      @JsonKey(
        name: 'beginingDate',
        fromJson: NonNullTimestampConverter.timestampToDateTime,
        toJson: NonNullTimestampConverter.dateTimeToTimestamp,
      )
      DateTime beginDate,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? lastTakenDate,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? createdAt,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? deletedAt,
      int groupIndex,
      List<RestDuration> restDurations,
      String version,
    )
    v1,
    required TResult Function(
      String id,
      @JsonKey() PillSheetTypeInfo typeInfo,
      @JsonKey(
        fromJson: NonNullTimestampConverter.timestampToDateTime,
        toJson: NonNullTimestampConverter.dateTimeToTimestamp,
      )
      DateTime beginDate,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? createdAt,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? deletedAt,
      int groupIndex,
      List<RestDuration> restDurations,
      List<Pill> pills,
      String version,
    )
    v2,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      @JsonKey(includeIfNull: false) String? id,
      @JsonKey() PillSheetTypeInfo typeInfo,
      @JsonKey(
        name: 'beginingDate',
        fromJson: NonNullTimestampConverter.timestampToDateTime,
        toJson: NonNullTimestampConverter.dateTimeToTimestamp,
      )
      DateTime beginDate,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? lastTakenDate,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? createdAt,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? deletedAt,
      int groupIndex,
      List<RestDuration> restDurations,
      String version,
    )?
    v1,
    TResult? Function(
      String id,
      @JsonKey() PillSheetTypeInfo typeInfo,
      @JsonKey(
        fromJson: NonNullTimestampConverter.timestampToDateTime,
        toJson: NonNullTimestampConverter.dateTimeToTimestamp,
      )
      DateTime beginDate,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? createdAt,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? deletedAt,
      int groupIndex,
      List<RestDuration> restDurations,
      List<Pill> pills,
      String version,
    )?
    v2,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      @JsonKey(includeIfNull: false) String? id,
      @JsonKey() PillSheetTypeInfo typeInfo,
      @JsonKey(
        name: 'beginingDate',
        fromJson: NonNullTimestampConverter.timestampToDateTime,
        toJson: NonNullTimestampConverter.dateTimeToTimestamp,
      )
      DateTime beginDate,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? lastTakenDate,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? createdAt,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? deletedAt,
      int groupIndex,
      List<RestDuration> restDurations,
      String version,
    )?
    v1,
    TResult Function(
      String id,
      @JsonKey() PillSheetTypeInfo typeInfo,
      @JsonKey(
        fromJson: NonNullTimestampConverter.timestampToDateTime,
        toJson: NonNullTimestampConverter.dateTimeToTimestamp,
      )
      DateTime beginDate,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? createdAt,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? deletedAt,
      int groupIndex,
      List<RestDuration> restDurations,
      List<Pill> pills,
      String version,
    )?
    v2,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PillSheetV1 value) v1,
    required TResult Function(PillSheetV2 value) v2,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PillSheetV1 value)? v1,
    TResult? Function(PillSheetV2 value)? v2,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PillSheetV1 value)? v1,
    TResult Function(PillSheetV2 value)? v2,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PillSheetCopyWith<PillSheet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PillSheetCopyWith<$Res> {
  factory $PillSheetCopyWith(PillSheet value, $Res Function(PillSheet) then) =
      _$PillSheetCopyWithImpl<$Res, PillSheet>;
  @useResult
  $Res call({
    @JsonKey(includeIfNull: false) String id,
    @JsonKey() PillSheetTypeInfo typeInfo,
    @JsonKey(
      name: 'beginingDate',
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    DateTime beginDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    DateTime? createdAt,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    DateTime? deletedAt,
    int groupIndex,
    List<RestDuration> restDurations,
    String version,
  });

  $PillSheetTypeInfoCopyWith<$Res> get typeInfo;
}

/// @nodoc
class _$PillSheetCopyWithImpl<$Res, $Val extends PillSheet>
    implements $PillSheetCopyWith<$Res> {
  _$PillSheetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? typeInfo = null,
    Object? beginDate = null,
    Object? createdAt = freezed,
    Object? deletedAt = freezed,
    Object? groupIndex = null,
    Object? restDurations = null,
    Object? version = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id!
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            typeInfo: null == typeInfo
                ? _value.typeInfo
                : typeInfo // ignore: cast_nullable_to_non_nullable
                      as PillSheetTypeInfo,
            beginDate: null == beginDate
                ? _value.beginDate
                : beginDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            deletedAt: freezed == deletedAt
                ? _value.deletedAt
                : deletedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            groupIndex: null == groupIndex
                ? _value.groupIndex
                : groupIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            restDurations: null == restDurations
                ? _value.restDurations
                : restDurations // ignore: cast_nullable_to_non_nullable
                      as List<RestDuration>,
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }

  @override
  @pragma('vm:prefer-inline')
  $PillSheetTypeInfoCopyWith<$Res> get typeInfo {
    return $PillSheetTypeInfoCopyWith<$Res>(_value.typeInfo, (value) {
      return _then(_value.copyWith(typeInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PillSheetV1ImplCopyWith<$Res>
    implements $PillSheetCopyWith<$Res> {
  factory _$$PillSheetV1ImplCopyWith(
    _$PillSheetV1Impl value,
    $Res Function(_$PillSheetV1Impl) then,
  ) = __$$PillSheetV1ImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(includeIfNull: false) String? id,
    @JsonKey() PillSheetTypeInfo typeInfo,
    @JsonKey(
      name: 'beginingDate',
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    DateTime beginDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    DateTime? lastTakenDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    DateTime? createdAt,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    DateTime? deletedAt,
    int groupIndex,
    List<RestDuration> restDurations,
    String version,
  });

  @override
  $PillSheetTypeInfoCopyWith<$Res> get typeInfo;
}

/// @nodoc
class __$$PillSheetV1ImplCopyWithImpl<$Res>
    extends _$PillSheetCopyWithImpl<$Res, _$PillSheetV1Impl>
    implements _$$PillSheetV1ImplCopyWith<$Res> {
  __$$PillSheetV1ImplCopyWithImpl(
    _$PillSheetV1Impl _value,
    $Res Function(_$PillSheetV1Impl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? typeInfo = null,
    Object? beginDate = null,
    Object? lastTakenDate = freezed,
    Object? createdAt = freezed,
    Object? deletedAt = freezed,
    Object? groupIndex = null,
    Object? restDurations = null,
    Object? version = null,
  }) {
    return _then(
      _$PillSheetV1Impl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        typeInfo: null == typeInfo
            ? _value.typeInfo
            : typeInfo // ignore: cast_nullable_to_non_nullable
                  as PillSheetTypeInfo,
        beginDate: null == beginDate
            ? _value.beginDate
            : beginDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastTakenDate: freezed == lastTakenDate
            ? _value.lastTakenDate
            : lastTakenDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        deletedAt: freezed == deletedAt
            ? _value.deletedAt
            : deletedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        groupIndex: null == groupIndex
            ? _value.groupIndex
            : groupIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        restDurations: null == restDurations
            ? _value._restDurations
            : restDurations // ignore: cast_nullable_to_non_nullable
                  as List<RestDuration>,
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$PillSheetV1Impl extends PillSheetV1 {
  _$PillSheetV1Impl({
    @JsonKey(includeIfNull: false) required this.id,
    @JsonKey() required this.typeInfo,
    @JsonKey(
      name: 'beginingDate',
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required this.beginDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    required this.lastTakenDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    required this.createdAt,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    this.deletedAt,
    this.groupIndex = 0,
    final List<RestDuration> restDurations = const [],
    this.version = 'v1',
  }) : _restDurations = restDurations,
       super._();

  /// FirestoreドキュメントID
  /// データベース保存時に自動生成される一意識別子
  @override
  @JsonKey(includeIfNull: false)
  final String? id;

  /// ピルシートの種類情報
  /// シート名、総数、服用期間などの基本設定
  @override
  @JsonKey()
  final PillSheetTypeInfo typeInfo;

  /// ピルシート開始日
  /// このシートでピル服用を開始した日付
  @override
  @JsonKey(
    name: 'beginingDate',
    fromJson: NonNullTimestampConverter.timestampToDateTime,
    toJson: NonNullTimestampConverter.dateTimeToTimestamp,
  )
  final DateTime beginDate;
  // NOTE: [SyncData:Widget] このプロパティはWidgetに同期されてる
  @override
  @JsonKey(
    fromJson: TimestampConverter.timestampToDateTime,
    toJson: TimestampConverter.dateTimeToTimestamp,
  )
  final DateTime? lastTakenDate;
  @override
  @JsonKey(
    fromJson: TimestampConverter.timestampToDateTime,
    toJson: TimestampConverter.dateTimeToTimestamp,
  )
  final DateTime? createdAt;
  @override
  @JsonKey(
    fromJson: TimestampConverter.timestampToDateTime,
    toJson: TimestampConverter.dateTimeToTimestamp,
  )
  final DateTime? deletedAt;

  /// グループインデックス
  /// 複数のピルシートをグループ化する際の順序番号
  @override
  @JsonKey()
  final int groupIndex;

  /// 休薬期間のリスト
  /// このピルシート期間中の全ての休薬期間記録
  final List<RestDuration> _restDurations;

  /// 休薬期間のリスト
  /// このピルシート期間中の全ての休薬期間記録
  @override
  @JsonKey()
  List<RestDuration> get restDurations {
    if (_restDurations is EqualUnmodifiableListView) return _restDurations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_restDurations);
  }

  /// バージョン識別子
  @override
  @JsonKey()
  final String version;

  @override
  String toString() {
    return 'PillSheet.v1(id: $id, typeInfo: $typeInfo, beginDate: $beginDate, lastTakenDate: $lastTakenDate, createdAt: $createdAt, deletedAt: $deletedAt, groupIndex: $groupIndex, restDurations: $restDurations, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PillSheetV1Impl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.typeInfo, typeInfo) ||
                other.typeInfo == typeInfo) &&
            (identical(other.beginDate, beginDate) ||
                other.beginDate == beginDate) &&
            (identical(other.lastTakenDate, lastTakenDate) ||
                other.lastTakenDate == lastTakenDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.groupIndex, groupIndex) ||
                other.groupIndex == groupIndex) &&
            const DeepCollectionEquality().equals(
              other._restDurations,
              _restDurations,
            ) &&
            (identical(other.version, version) || other.version == version));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    typeInfo,
    beginDate,
    lastTakenDate,
    createdAt,
    deletedAt,
    groupIndex,
    const DeepCollectionEquality().hash(_restDurations),
    version,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PillSheetV1ImplCopyWith<_$PillSheetV1Impl> get copyWith =>
      __$$PillSheetV1ImplCopyWithImpl<_$PillSheetV1Impl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      @JsonKey(includeIfNull: false) String? id,
      @JsonKey() PillSheetTypeInfo typeInfo,
      @JsonKey(
        name: 'beginingDate',
        fromJson: NonNullTimestampConverter.timestampToDateTime,
        toJson: NonNullTimestampConverter.dateTimeToTimestamp,
      )
      DateTime beginDate,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? lastTakenDate,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? createdAt,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? deletedAt,
      int groupIndex,
      List<RestDuration> restDurations,
      String version,
    )
    v1,
    required TResult Function(
      String id,
      @JsonKey() PillSheetTypeInfo typeInfo,
      @JsonKey(
        fromJson: NonNullTimestampConverter.timestampToDateTime,
        toJson: NonNullTimestampConverter.dateTimeToTimestamp,
      )
      DateTime beginDate,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? createdAt,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? deletedAt,
      int groupIndex,
      List<RestDuration> restDurations,
      List<Pill> pills,
      String version,
    )
    v2,
  }) {
    return v1(
      id,
      typeInfo,
      beginDate,
      lastTakenDate,
      createdAt,
      deletedAt,
      groupIndex,
      restDurations,
      version,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      @JsonKey(includeIfNull: false) String? id,
      @JsonKey() PillSheetTypeInfo typeInfo,
      @JsonKey(
        name: 'beginingDate',
        fromJson: NonNullTimestampConverter.timestampToDateTime,
        toJson: NonNullTimestampConverter.dateTimeToTimestamp,
      )
      DateTime beginDate,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? lastTakenDate,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? createdAt,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? deletedAt,
      int groupIndex,
      List<RestDuration> restDurations,
      String version,
    )?
    v1,
    TResult? Function(
      String id,
      @JsonKey() PillSheetTypeInfo typeInfo,
      @JsonKey(
        fromJson: NonNullTimestampConverter.timestampToDateTime,
        toJson: NonNullTimestampConverter.dateTimeToTimestamp,
      )
      DateTime beginDate,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? createdAt,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? deletedAt,
      int groupIndex,
      List<RestDuration> restDurations,
      List<Pill> pills,
      String version,
    )?
    v2,
  }) {
    return v1?.call(
      id,
      typeInfo,
      beginDate,
      lastTakenDate,
      createdAt,
      deletedAt,
      groupIndex,
      restDurations,
      version,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      @JsonKey(includeIfNull: false) String? id,
      @JsonKey() PillSheetTypeInfo typeInfo,
      @JsonKey(
        name: 'beginingDate',
        fromJson: NonNullTimestampConverter.timestampToDateTime,
        toJson: NonNullTimestampConverter.dateTimeToTimestamp,
      )
      DateTime beginDate,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? lastTakenDate,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? createdAt,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? deletedAt,
      int groupIndex,
      List<RestDuration> restDurations,
      String version,
    )?
    v1,
    TResult Function(
      String id,
      @JsonKey() PillSheetTypeInfo typeInfo,
      @JsonKey(
        fromJson: NonNullTimestampConverter.timestampToDateTime,
        toJson: NonNullTimestampConverter.dateTimeToTimestamp,
      )
      DateTime beginDate,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? createdAt,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? deletedAt,
      int groupIndex,
      List<RestDuration> restDurations,
      List<Pill> pills,
      String version,
    )?
    v2,
    required TResult orElse(),
  }) {
    if (v1 != null) {
      return v1(
        id,
        typeInfo,
        beginDate,
        lastTakenDate,
        createdAt,
        deletedAt,
        groupIndex,
        restDurations,
        version,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PillSheetV1 value) v1,
    required TResult Function(PillSheetV2 value) v2,
  }) {
    return v1(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PillSheetV1 value)? v1,
    TResult? Function(PillSheetV2 value)? v2,
  }) {
    return v1?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PillSheetV1 value)? v1,
    TResult Function(PillSheetV2 value)? v2,
    required TResult orElse(),
  }) {
    if (v1 != null) {
      return v1(this);
    }
    return orElse();
  }
}

abstract class PillSheetV1 extends PillSheet {
  factory PillSheetV1({
    @JsonKey(includeIfNull: false) required final String? id,
    @JsonKey() required final PillSheetTypeInfo typeInfo,
    @JsonKey(
      name: 'beginingDate',
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required final DateTime beginDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    required final DateTime? lastTakenDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    required final DateTime? createdAt,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    final DateTime? deletedAt,
    final int groupIndex,
    final List<RestDuration> restDurations,
    final String version,
  }) = _$PillSheetV1Impl;
  PillSheetV1._() : super._();

  @override
  /// FirestoreドキュメントID
  /// データベース保存時に自動生成される一意識別子
  @JsonKey(includeIfNull: false)
  String? get id;
  @override
  /// ピルシートの種類情報
  /// シート名、総数、服用期間などの基本設定
  @JsonKey()
  PillSheetTypeInfo get typeInfo;
  @override
  /// ピルシート開始日
  /// このシートでピル服用を開始した日付
  @JsonKey(
    name: 'beginingDate',
    fromJson: NonNullTimestampConverter.timestampToDateTime,
    toJson: NonNullTimestampConverter.dateTimeToTimestamp,
  )
  DateTime get beginDate; // NOTE: [SyncData:Widget] このプロパティはWidgetに同期されてる
  @JsonKey(
    fromJson: TimestampConverter.timestampToDateTime,
    toJson: TimestampConverter.dateTimeToTimestamp,
  )
  DateTime? get lastTakenDate;
  @override
  @JsonKey(
    fromJson: TimestampConverter.timestampToDateTime,
    toJson: TimestampConverter.dateTimeToTimestamp,
  )
  DateTime? get createdAt;
  @override
  @JsonKey(
    fromJson: TimestampConverter.timestampToDateTime,
    toJson: TimestampConverter.dateTimeToTimestamp,
  )
  DateTime? get deletedAt;
  @override
  /// グループインデックス
  /// 複数のピルシートをグループ化する際の順序番号
  int get groupIndex;
  @override
  /// 休薬期間のリスト
  /// このピルシート期間中の全ての休薬期間記録
  List<RestDuration> get restDurations;
  @override
  /// バージョン識別子
  String get version;
  @override
  @JsonKey(ignore: true)
  _$$PillSheetV1ImplCopyWith<_$PillSheetV1Impl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PillSheetV2ImplCopyWith<$Res>
    implements $PillSheetCopyWith<$Res> {
  factory _$$PillSheetV2ImplCopyWith(
    _$PillSheetV2Impl value,
    $Res Function(_$PillSheetV2Impl) then,
  ) = __$$PillSheetV2ImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey() PillSheetTypeInfo typeInfo,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    DateTime beginDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    DateTime? createdAt,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    DateTime? deletedAt,
    int groupIndex,
    List<RestDuration> restDurations,
    List<Pill> pills,
    String version,
  });

  @override
  $PillSheetTypeInfoCopyWith<$Res> get typeInfo;
}

/// @nodoc
class __$$PillSheetV2ImplCopyWithImpl<$Res>
    extends _$PillSheetCopyWithImpl<$Res, _$PillSheetV2Impl>
    implements _$$PillSheetV2ImplCopyWith<$Res> {
  __$$PillSheetV2ImplCopyWithImpl(
    _$PillSheetV2Impl _value,
    $Res Function(_$PillSheetV2Impl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? typeInfo = null,
    Object? beginDate = null,
    Object? createdAt = freezed,
    Object? deletedAt = freezed,
    Object? groupIndex = null,
    Object? restDurations = null,
    Object? pills = null,
    Object? version = null,
  }) {
    return _then(
      _$PillSheetV2Impl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        typeInfo: null == typeInfo
            ? _value.typeInfo
            : typeInfo // ignore: cast_nullable_to_non_nullable
                  as PillSheetTypeInfo,
        beginDate: null == beginDate
            ? _value.beginDate
            : beginDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        deletedAt: freezed == deletedAt
            ? _value.deletedAt
            : deletedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        groupIndex: null == groupIndex
            ? _value.groupIndex
            : groupIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        restDurations: null == restDurations
            ? _value._restDurations
            : restDurations // ignore: cast_nullable_to_non_nullable
                  as List<RestDuration>,
        pills: null == pills
            ? _value._pills
            : pills // ignore: cast_nullable_to_non_nullable
                  as List<Pill>,
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$PillSheetV2Impl extends PillSheetV2 {
  _$PillSheetV2Impl({
    required this.id,
    @JsonKey() required this.typeInfo,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required this.beginDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    required this.createdAt,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    this.deletedAt,
    required this.groupIndex,
    required final List<RestDuration> restDurations,
    required final List<Pill> pills,
    this.version = 'v2',
  }) : _restDurations = restDurations,
       _pills = pills,
       super._();

  /// FirestoreドキュメントID
  /// データベース保存時に自動生成される一意識別子
  @override
  final String id;

  /// ピルシートの種類情報
  /// シート名、総数、服用期間などの基本設定
  @override
  @JsonKey()
  final PillSheetTypeInfo typeInfo;

  /// ピルシート開始日
  /// このシートでピル服用を開始した日付
  @override
  @JsonKey(
    fromJson: NonNullTimestampConverter.timestampToDateTime,
    toJson: NonNullTimestampConverter.dateTimeToTimestamp,
  )
  final DateTime beginDate;
  @override
  @JsonKey(
    fromJson: TimestampConverter.timestampToDateTime,
    toJson: TimestampConverter.dateTimeToTimestamp,
  )
  final DateTime? createdAt;
  @override
  @JsonKey(
    fromJson: TimestampConverter.timestampToDateTime,
    toJson: TimestampConverter.dateTimeToTimestamp,
  )
  final DateTime? deletedAt;

  /// グループインデックス
  /// 複数のピルシートをグループ化する際の順序番号
  @override
  final int groupIndex;

  /// 休薬期間のリスト
  /// このピルシート期間中の全ての休薬期間記録
  final List<RestDuration> _restDurations;

  /// 休薬期間のリスト
  /// このピルシート期間中の全ての休薬期間記録
  @override
  List<RestDuration> get restDurations {
    if (_restDurations is EqualUnmodifiableListView) return _restDurations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_restDurations);
  }

  /// 1回の服用で飲むピルの錠数
  /// 2錠飲みの場合は2がセットされる
  /// NOTE: DBから簡単に確認するための記録用プロパティ。実際の判定には pills[].takenCount を使用すること
  // required int pillTakenCount,
  /// 各ピルの詳細情報リスト
  /// 2錠飲み対応のため、各ピルごとの服用記録を管理
  final List<Pill> _pills;

  /// 1回の服用で飲むピルの錠数
  /// 2錠飲みの場合は2がセットされる
  /// NOTE: DBから簡単に確認するための記録用プロパティ。実際の判定には pills[].takenCount を使用すること
  // required int pillTakenCount,
  /// 各ピルの詳細情報リスト
  /// 2錠飲み対応のため、各ピルごとの服用記録を管理
  @override
  List<Pill> get pills {
    if (_pills is EqualUnmodifiableListView) return _pills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pills);
  }

  /// バージョン識別子
  @override
  @JsonKey()
  final String version;

  @override
  String toString() {
    return 'PillSheet.v2(id: $id, typeInfo: $typeInfo, beginDate: $beginDate, createdAt: $createdAt, deletedAt: $deletedAt, groupIndex: $groupIndex, restDurations: $restDurations, pills: $pills, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PillSheetV2Impl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.typeInfo, typeInfo) ||
                other.typeInfo == typeInfo) &&
            (identical(other.beginDate, beginDate) ||
                other.beginDate == beginDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.groupIndex, groupIndex) ||
                other.groupIndex == groupIndex) &&
            const DeepCollectionEquality().equals(
              other._restDurations,
              _restDurations,
            ) &&
            const DeepCollectionEquality().equals(other._pills, _pills) &&
            (identical(other.version, version) || other.version == version));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    typeInfo,
    beginDate,
    createdAt,
    deletedAt,
    groupIndex,
    const DeepCollectionEquality().hash(_restDurations),
    const DeepCollectionEquality().hash(_pills),
    version,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PillSheetV2ImplCopyWith<_$PillSheetV2Impl> get copyWith =>
      __$$PillSheetV2ImplCopyWithImpl<_$PillSheetV2Impl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      @JsonKey(includeIfNull: false) String? id,
      @JsonKey() PillSheetTypeInfo typeInfo,
      @JsonKey(
        name: 'beginingDate',
        fromJson: NonNullTimestampConverter.timestampToDateTime,
        toJson: NonNullTimestampConverter.dateTimeToTimestamp,
      )
      DateTime beginDate,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? lastTakenDate,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? createdAt,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? deletedAt,
      int groupIndex,
      List<RestDuration> restDurations,
      String version,
    )
    v1,
    required TResult Function(
      String id,
      @JsonKey() PillSheetTypeInfo typeInfo,
      @JsonKey(
        fromJson: NonNullTimestampConverter.timestampToDateTime,
        toJson: NonNullTimestampConverter.dateTimeToTimestamp,
      )
      DateTime beginDate,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? createdAt,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? deletedAt,
      int groupIndex,
      List<RestDuration> restDurations,
      List<Pill> pills,
      String version,
    )
    v2,
  }) {
    return v2(
      id,
      typeInfo,
      beginDate,
      createdAt,
      deletedAt,
      groupIndex,
      restDurations,
      pills,
      version,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      @JsonKey(includeIfNull: false) String? id,
      @JsonKey() PillSheetTypeInfo typeInfo,
      @JsonKey(
        name: 'beginingDate',
        fromJson: NonNullTimestampConverter.timestampToDateTime,
        toJson: NonNullTimestampConverter.dateTimeToTimestamp,
      )
      DateTime beginDate,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? lastTakenDate,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? createdAt,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? deletedAt,
      int groupIndex,
      List<RestDuration> restDurations,
      String version,
    )?
    v1,
    TResult? Function(
      String id,
      @JsonKey() PillSheetTypeInfo typeInfo,
      @JsonKey(
        fromJson: NonNullTimestampConverter.timestampToDateTime,
        toJson: NonNullTimestampConverter.dateTimeToTimestamp,
      )
      DateTime beginDate,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? createdAt,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? deletedAt,
      int groupIndex,
      List<RestDuration> restDurations,
      List<Pill> pills,
      String version,
    )?
    v2,
  }) {
    return v2?.call(
      id,
      typeInfo,
      beginDate,
      createdAt,
      deletedAt,
      groupIndex,
      restDurations,
      pills,
      version,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      @JsonKey(includeIfNull: false) String? id,
      @JsonKey() PillSheetTypeInfo typeInfo,
      @JsonKey(
        name: 'beginingDate',
        fromJson: NonNullTimestampConverter.timestampToDateTime,
        toJson: NonNullTimestampConverter.dateTimeToTimestamp,
      )
      DateTime beginDate,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? lastTakenDate,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? createdAt,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? deletedAt,
      int groupIndex,
      List<RestDuration> restDurations,
      String version,
    )?
    v1,
    TResult Function(
      String id,
      @JsonKey() PillSheetTypeInfo typeInfo,
      @JsonKey(
        fromJson: NonNullTimestampConverter.timestampToDateTime,
        toJson: NonNullTimestampConverter.dateTimeToTimestamp,
      )
      DateTime beginDate,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? createdAt,
      @JsonKey(
        fromJson: TimestampConverter.timestampToDateTime,
        toJson: TimestampConverter.dateTimeToTimestamp,
      )
      DateTime? deletedAt,
      int groupIndex,
      List<RestDuration> restDurations,
      List<Pill> pills,
      String version,
    )?
    v2,
    required TResult orElse(),
  }) {
    if (v2 != null) {
      return v2(
        id,
        typeInfo,
        beginDate,
        createdAt,
        deletedAt,
        groupIndex,
        restDurations,
        pills,
        version,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PillSheetV1 value) v1,
    required TResult Function(PillSheetV2 value) v2,
  }) {
    return v2(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PillSheetV1 value)? v1,
    TResult? Function(PillSheetV2 value)? v2,
  }) {
    return v2?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PillSheetV1 value)? v1,
    TResult Function(PillSheetV2 value)? v2,
    required TResult orElse(),
  }) {
    if (v2 != null) {
      return v2(this);
    }
    return orElse();
  }
}

abstract class PillSheetV2 extends PillSheet {
  factory PillSheetV2({
    required final String id,
    @JsonKey() required final PillSheetTypeInfo typeInfo,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required final DateTime beginDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    required final DateTime? createdAt,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    final DateTime? deletedAt,
    required final int groupIndex,
    required final List<RestDuration> restDurations,
    required final List<Pill> pills,
    final String version,
  }) = _$PillSheetV2Impl;
  PillSheetV2._() : super._();

  @override
  /// FirestoreドキュメントID
  /// データベース保存時に自動生成される一意識別子
  String get id;
  @override
  /// ピルシートの種類情報
  /// シート名、総数、服用期間などの基本設定
  @JsonKey()
  PillSheetTypeInfo get typeInfo;
  @override
  /// ピルシート開始日
  /// このシートでピル服用を開始した日付
  @JsonKey(
    fromJson: NonNullTimestampConverter.timestampToDateTime,
    toJson: NonNullTimestampConverter.dateTimeToTimestamp,
  )
  DateTime get beginDate;
  @override
  @JsonKey(
    fromJson: TimestampConverter.timestampToDateTime,
    toJson: TimestampConverter.dateTimeToTimestamp,
  )
  DateTime? get createdAt;
  @override
  @JsonKey(
    fromJson: TimestampConverter.timestampToDateTime,
    toJson: TimestampConverter.dateTimeToTimestamp,
  )
  DateTime? get deletedAt;
  @override
  /// グループインデックス
  /// 複数のピルシートをグループ化する際の順序番号
  int get groupIndex;
  @override
  /// 休薬期間のリスト
  /// このピルシート期間中の全ての休薬期間記録
  List<RestDuration> get restDurations;

  /// 1回の服用で飲むピルの錠数
  /// 2錠飲みの場合は2がセットされる
  /// NOTE: DBから簡単に確認するための記録用プロパティ。実際の判定には pills[].takenCount を使用すること
  // required int pillTakenCount,
  /// 各ピルの詳細情報リスト
  /// 2錠飲み対応のため、各ピルごとの服用記録を管理
  List<Pill> get pills;
  @override
  /// バージョン識別子
  String get version;
  @override
  @JsonKey(ignore: true)
  _$$PillSheetV2ImplCopyWith<_$PillSheetV2Impl> get copyWith =>
      throw _privateConstructorUsedError;
}
