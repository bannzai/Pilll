// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'pill_sheet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
PillSheetTypeInfo _$PillSheetTypeInfoFromJson(Map<String, dynamic> json) {
  return _PillSheetTypeInfo.fromJson(json);
}

/// @nodoc
class _$PillSheetTypeInfoTearOff {
  const _$PillSheetTypeInfoTearOff();

// ignore: unused_element
  _PillSheetTypeInfo call(
      {@required String pillSheetTypeReferencePath,
      @required int totalCount,
      @required int dosingPeriod}) {
    return _PillSheetTypeInfo(
      pillSheetTypeReferencePath: pillSheetTypeReferencePath,
      totalCount: totalCount,
      dosingPeriod: dosingPeriod,
    );
  }

// ignore: unused_element
  PillSheetTypeInfo fromJson(Map<String, Object> json) {
    return PillSheetTypeInfo.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $PillSheetTypeInfo = _$PillSheetTypeInfoTearOff();

/// @nodoc
mixin _$PillSheetTypeInfo {
  String get pillSheetTypeReferencePath;
  int get totalCount;
  int get dosingPeriod;

  Map<String, dynamic> toJson();
  $PillSheetTypeInfoCopyWith<PillSheetTypeInfo> get copyWith;
}

/// @nodoc
abstract class $PillSheetTypeInfoCopyWith<$Res> {
  factory $PillSheetTypeInfoCopyWith(
          PillSheetTypeInfo value, $Res Function(PillSheetTypeInfo) then) =
      _$PillSheetTypeInfoCopyWithImpl<$Res>;
  $Res call(
      {String pillSheetTypeReferencePath, int totalCount, int dosingPeriod});
}

/// @nodoc
class _$PillSheetTypeInfoCopyWithImpl<$Res>
    implements $PillSheetTypeInfoCopyWith<$Res> {
  _$PillSheetTypeInfoCopyWithImpl(this._value, this._then);

  final PillSheetTypeInfo _value;
  // ignore: unused_field
  final $Res Function(PillSheetTypeInfo) _then;

  @override
  $Res call({
    Object pillSheetTypeReferencePath = freezed,
    Object totalCount = freezed,
    Object dosingPeriod = freezed,
  }) {
    return _then(_value.copyWith(
      pillSheetTypeReferencePath: pillSheetTypeReferencePath == freezed
          ? _value.pillSheetTypeReferencePath
          : pillSheetTypeReferencePath as String,
      totalCount: totalCount == freezed ? _value.totalCount : totalCount as int,
      dosingPeriod:
          dosingPeriod == freezed ? _value.dosingPeriod : dosingPeriod as int,
    ));
  }
}

/// @nodoc
abstract class _$PillSheetTypeInfoCopyWith<$Res>
    implements $PillSheetTypeInfoCopyWith<$Res> {
  factory _$PillSheetTypeInfoCopyWith(
          _PillSheetTypeInfo value, $Res Function(_PillSheetTypeInfo) then) =
      __$PillSheetTypeInfoCopyWithImpl<$Res>;
  @override
  $Res call(
      {String pillSheetTypeReferencePath, int totalCount, int dosingPeriod});
}

/// @nodoc
class __$PillSheetTypeInfoCopyWithImpl<$Res>
    extends _$PillSheetTypeInfoCopyWithImpl<$Res>
    implements _$PillSheetTypeInfoCopyWith<$Res> {
  __$PillSheetTypeInfoCopyWithImpl(
      _PillSheetTypeInfo _value, $Res Function(_PillSheetTypeInfo) _then)
      : super(_value, (v) => _then(v as _PillSheetTypeInfo));

  @override
  _PillSheetTypeInfo get _value => super._value as _PillSheetTypeInfo;

  @override
  $Res call({
    Object pillSheetTypeReferencePath = freezed,
    Object totalCount = freezed,
    Object dosingPeriod = freezed,
  }) {
    return _then(_PillSheetTypeInfo(
      pillSheetTypeReferencePath: pillSheetTypeReferencePath == freezed
          ? _value.pillSheetTypeReferencePath
          : pillSheetTypeReferencePath as String,
      totalCount: totalCount == freezed ? _value.totalCount : totalCount as int,
      dosingPeriod:
          dosingPeriod == freezed ? _value.dosingPeriod : dosingPeriod as int,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_PillSheetTypeInfo implements _PillSheetTypeInfo {
  _$_PillSheetTypeInfo(
      {@required this.pillSheetTypeReferencePath,
      @required this.totalCount,
      @required this.dosingPeriod})
      : assert(pillSheetTypeReferencePath != null),
        assert(totalCount != null),
        assert(dosingPeriod != null);

  factory _$_PillSheetTypeInfo.fromJson(Map<String, dynamic> json) =>
      _$_$_PillSheetTypeInfoFromJson(json);

  @override
  final String pillSheetTypeReferencePath;
  @override
  final int totalCount;
  @override
  final int dosingPeriod;

  @override
  String toString() {
    return 'PillSheetTypeInfo(pillSheetTypeReferencePath: $pillSheetTypeReferencePath, totalCount: $totalCount, dosingPeriod: $dosingPeriod)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PillSheetTypeInfo &&
            (identical(other.pillSheetTypeReferencePath,
                    pillSheetTypeReferencePath) ||
                const DeepCollectionEquality().equals(
                    other.pillSheetTypeReferencePath,
                    pillSheetTypeReferencePath)) &&
            (identical(other.totalCount, totalCount) ||
                const DeepCollectionEquality()
                    .equals(other.totalCount, totalCount)) &&
            (identical(other.dosingPeriod, dosingPeriod) ||
                const DeepCollectionEquality()
                    .equals(other.dosingPeriod, dosingPeriod)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(pillSheetTypeReferencePath) ^
      const DeepCollectionEquality().hash(totalCount) ^
      const DeepCollectionEquality().hash(dosingPeriod);

  @override
  _$PillSheetTypeInfoCopyWith<_PillSheetTypeInfo> get copyWith =>
      __$PillSheetTypeInfoCopyWithImpl<_PillSheetTypeInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_PillSheetTypeInfoToJson(this);
  }
}

abstract class _PillSheetTypeInfo implements PillSheetTypeInfo {
  factory _PillSheetTypeInfo(
      {@required String pillSheetTypeReferencePath,
      @required int totalCount,
      @required int dosingPeriod}) = _$_PillSheetTypeInfo;

  factory _PillSheetTypeInfo.fromJson(Map<String, dynamic> json) =
      _$_PillSheetTypeInfo.fromJson;

  @override
  String get pillSheetTypeReferencePath;
  @override
  int get totalCount;
  @override
  int get dosingPeriod;
  @override
  _$PillSheetTypeInfoCopyWith<_PillSheetTypeInfo> get copyWith;
}

PillSheetModel _$PillSheetModelFromJson(Map<String, dynamic> json) {
  return _PillSheetModel.fromJson(json);
}

/// @nodoc
class _$PillSheetModelTearOff {
  const _$PillSheetModelTearOff();

// ignore: unused_element
  _PillSheetModel call(
      {@required PillSheetTypeInfo typeInfo,
      @required DateTime beginingDate,
      @required DateTime lastTakenDate}) {
    return _PillSheetModel(
      typeInfo: typeInfo,
      beginingDate: beginingDate,
      lastTakenDate: lastTakenDate,
    );
  }

// ignore: unused_element
  PillSheetModel fromJson(Map<String, Object> json) {
    return PillSheetModel.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $PillSheetModel = _$PillSheetModelTearOff();

/// @nodoc
mixin _$PillSheetModel {
  PillSheetTypeInfo get typeInfo;
  DateTime get beginingDate;
  DateTime get lastTakenDate;

  Map<String, dynamic> toJson();
  $PillSheetModelCopyWith<PillSheetModel> get copyWith;
}

/// @nodoc
abstract class $PillSheetModelCopyWith<$Res> {
  factory $PillSheetModelCopyWith(
          PillSheetModel value, $Res Function(PillSheetModel) then) =
      _$PillSheetModelCopyWithImpl<$Res>;
  $Res call(
      {PillSheetTypeInfo typeInfo,
      DateTime beginingDate,
      DateTime lastTakenDate});

  $PillSheetTypeInfoCopyWith<$Res> get typeInfo;
}

/// @nodoc
class _$PillSheetModelCopyWithImpl<$Res>
    implements $PillSheetModelCopyWith<$Res> {
  _$PillSheetModelCopyWithImpl(this._value, this._then);

  final PillSheetModel _value;
  // ignore: unused_field
  final $Res Function(PillSheetModel) _then;

  @override
  $Res call({
    Object typeInfo = freezed,
    Object beginingDate = freezed,
    Object lastTakenDate = freezed,
  }) {
    return _then(_value.copyWith(
      typeInfo:
          typeInfo == freezed ? _value.typeInfo : typeInfo as PillSheetTypeInfo,
      beginingDate: beginingDate == freezed
          ? _value.beginingDate
          : beginingDate as DateTime,
      lastTakenDate: lastTakenDate == freezed
          ? _value.lastTakenDate
          : lastTakenDate as DateTime,
    ));
  }

  @override
  $PillSheetTypeInfoCopyWith<$Res> get typeInfo {
    if (_value.typeInfo == null) {
      return null;
    }
    return $PillSheetTypeInfoCopyWith<$Res>(_value.typeInfo, (value) {
      return _then(_value.copyWith(typeInfo: value));
    });
  }
}

/// @nodoc
abstract class _$PillSheetModelCopyWith<$Res>
    implements $PillSheetModelCopyWith<$Res> {
  factory _$PillSheetModelCopyWith(
          _PillSheetModel value, $Res Function(_PillSheetModel) then) =
      __$PillSheetModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {PillSheetTypeInfo typeInfo,
      DateTime beginingDate,
      DateTime lastTakenDate});

  @override
  $PillSheetTypeInfoCopyWith<$Res> get typeInfo;
}

/// @nodoc
class __$PillSheetModelCopyWithImpl<$Res>
    extends _$PillSheetModelCopyWithImpl<$Res>
    implements _$PillSheetModelCopyWith<$Res> {
  __$PillSheetModelCopyWithImpl(
      _PillSheetModel _value, $Res Function(_PillSheetModel) _then)
      : super(_value, (v) => _then(v as _PillSheetModel));

  @override
  _PillSheetModel get _value => super._value as _PillSheetModel;

  @override
  $Res call({
    Object typeInfo = freezed,
    Object beginingDate = freezed,
    Object lastTakenDate = freezed,
  }) {
    return _then(_PillSheetModel(
      typeInfo:
          typeInfo == freezed ? _value.typeInfo : typeInfo as PillSheetTypeInfo,
      beginingDate: beginingDate == freezed
          ? _value.beginingDate
          : beginingDate as DateTime,
      lastTakenDate: lastTakenDate == freezed
          ? _value.lastTakenDate
          : lastTakenDate as DateTime,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_PillSheetModel implements _PillSheetModel {
  _$_PillSheetModel(
      {@required this.typeInfo,
      @required this.beginingDate,
      @required this.lastTakenDate})
      : assert(typeInfo != null),
        assert(beginingDate != null),
        assert(lastTakenDate != null);

  factory _$_PillSheetModel.fromJson(Map<String, dynamic> json) =>
      _$_$_PillSheetModelFromJson(json);

  @override
  final PillSheetTypeInfo typeInfo;
  @override
  final DateTime beginingDate;
  @override
  final DateTime lastTakenDate;

  @override
  String toString() {
    return 'PillSheetModel(typeInfo: $typeInfo, beginingDate: $beginingDate, lastTakenDate: $lastTakenDate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PillSheetModel &&
            (identical(other.typeInfo, typeInfo) ||
                const DeepCollectionEquality()
                    .equals(other.typeInfo, typeInfo)) &&
            (identical(other.beginingDate, beginingDate) ||
                const DeepCollectionEquality()
                    .equals(other.beginingDate, beginingDate)) &&
            (identical(other.lastTakenDate, lastTakenDate) ||
                const DeepCollectionEquality()
                    .equals(other.lastTakenDate, lastTakenDate)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(typeInfo) ^
      const DeepCollectionEquality().hash(beginingDate) ^
      const DeepCollectionEquality().hash(lastTakenDate);

  @override
  _$PillSheetModelCopyWith<_PillSheetModel> get copyWith =>
      __$PillSheetModelCopyWithImpl<_PillSheetModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_PillSheetModelToJson(this);
  }
}

abstract class _PillSheetModel implements PillSheetModel {
  factory _PillSheetModel(
      {@required PillSheetTypeInfo typeInfo,
      @required DateTime beginingDate,
      @required DateTime lastTakenDate}) = _$_PillSheetModel;

  factory _PillSheetModel.fromJson(Map<String, dynamic> json) =
      _$_PillSheetModel.fromJson;

  @override
  PillSheetTypeInfo get typeInfo;
  @override
  DateTime get beginingDate;
  @override
  DateTime get lastTakenDate;
  @override
  _$PillSheetModelCopyWith<_PillSheetModel> get copyWith;
}
