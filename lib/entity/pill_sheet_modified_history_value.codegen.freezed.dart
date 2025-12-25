// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pill_sheet_modified_history_value.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PillSheetModifiedHistoryValue {

/// ピルシート作成時の記録
/// 新規ピルシートが作成された際の作成情報
 CreatedPillSheetValue? get createdPillSheet;/// 自動記録された最終服用日の変更
/// システムが自動的に最終服用日を更新した際の記録
 AutomaticallyRecordedLastTakenDateValue? get automaticallyRecordedLastTakenDate;/// ピルシート削除時の記録
/// ピルシートが削除された際の削除情報
 DeletedPillSheetValue? get deletedPillSheet;/// ピル服用記録時の情報
/// ユーザーがピルを服用したことを記録した際の情報
 TakenPillValue? get takenPill;/// ピル服用記録の取り消し情報
/// 誤って記録した服用を取り消した際の情報
 RevertTakenPillValue? get revertTakenPill;/// ピル番号変更時の記録
/// ピル番号の調整や修正が行われた際の変更情報
 ChangedPillNumberValue? get changedPillNumber;/// ピルシート終了時の記録
/// シートの服用完了や手動終了時の情報
 EndedPillSheetValue? get endedPillSheet;/// 休薬期間開始時の記録
/// ユーザーが服用を一時停止した際の開始情報
 BeganRestDurationValue? get beganRestDurationValue;/// 休薬期間終了時の記録
/// 休薬期間が終了し服用を再開した際の情報
 EndedRestDurationValue? get endedRestDurationValue;/// 休薬期間開始日変更時の記録（v2から追加）
/// 既存の休薬期間の開始日を変更した際の情報
 ChangedRestDurationBeginDateValue? get changedRestDurationBeginDateValue;/// 休薬期間内容変更時の記録（v2から追加）
/// 休薬期間の設定内容を変更した際の情報
 ChangedRestDurationValue? get changedRestDurationValue;/// 表示開始番号変更時の記録
/// ピルシートの表示番号の開始値を変更した際の情報
 ChangedBeginDisplayNumberValue? get changedBeginDisplayNumber;/// 表示終了番号変更時の記録
/// ピルシートの表示番号の終了値を変更した際の情報
 ChangedEndDisplayNumberValue? get changedEndDisplayNumber;
/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PillSheetModifiedHistoryValueCopyWith<PillSheetModifiedHistoryValue> get copyWith => _$PillSheetModifiedHistoryValueCopyWithImpl<PillSheetModifiedHistoryValue>(this as PillSheetModifiedHistoryValue, _$identity);

  /// Serializes this PillSheetModifiedHistoryValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PillSheetModifiedHistoryValue&&(identical(other.createdPillSheet, createdPillSheet) || other.createdPillSheet == createdPillSheet)&&(identical(other.automaticallyRecordedLastTakenDate, automaticallyRecordedLastTakenDate) || other.automaticallyRecordedLastTakenDate == automaticallyRecordedLastTakenDate)&&(identical(other.deletedPillSheet, deletedPillSheet) || other.deletedPillSheet == deletedPillSheet)&&(identical(other.takenPill, takenPill) || other.takenPill == takenPill)&&(identical(other.revertTakenPill, revertTakenPill) || other.revertTakenPill == revertTakenPill)&&(identical(other.changedPillNumber, changedPillNumber) || other.changedPillNumber == changedPillNumber)&&(identical(other.endedPillSheet, endedPillSheet) || other.endedPillSheet == endedPillSheet)&&(identical(other.beganRestDurationValue, beganRestDurationValue) || other.beganRestDurationValue == beganRestDurationValue)&&(identical(other.endedRestDurationValue, endedRestDurationValue) || other.endedRestDurationValue == endedRestDurationValue)&&(identical(other.changedRestDurationBeginDateValue, changedRestDurationBeginDateValue) || other.changedRestDurationBeginDateValue == changedRestDurationBeginDateValue)&&(identical(other.changedRestDurationValue, changedRestDurationValue) || other.changedRestDurationValue == changedRestDurationValue)&&(identical(other.changedBeginDisplayNumber, changedBeginDisplayNumber) || other.changedBeginDisplayNumber == changedBeginDisplayNumber)&&(identical(other.changedEndDisplayNumber, changedEndDisplayNumber) || other.changedEndDisplayNumber == changedEndDisplayNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,createdPillSheet,automaticallyRecordedLastTakenDate,deletedPillSheet,takenPill,revertTakenPill,changedPillNumber,endedPillSheet,beganRestDurationValue,endedRestDurationValue,changedRestDurationBeginDateValue,changedRestDurationValue,changedBeginDisplayNumber,changedEndDisplayNumber);

@override
String toString() {
  return 'PillSheetModifiedHistoryValue(createdPillSheet: $createdPillSheet, automaticallyRecordedLastTakenDate: $automaticallyRecordedLastTakenDate, deletedPillSheet: $deletedPillSheet, takenPill: $takenPill, revertTakenPill: $revertTakenPill, changedPillNumber: $changedPillNumber, endedPillSheet: $endedPillSheet, beganRestDurationValue: $beganRestDurationValue, endedRestDurationValue: $endedRestDurationValue, changedRestDurationBeginDateValue: $changedRestDurationBeginDateValue, changedRestDurationValue: $changedRestDurationValue, changedBeginDisplayNumber: $changedBeginDisplayNumber, changedEndDisplayNumber: $changedEndDisplayNumber)';
}


}

/// @nodoc
abstract mixin class $PillSheetModifiedHistoryValueCopyWith<$Res>  {
  factory $PillSheetModifiedHistoryValueCopyWith(PillSheetModifiedHistoryValue value, $Res Function(PillSheetModifiedHistoryValue) _then) = _$PillSheetModifiedHistoryValueCopyWithImpl;
@useResult
$Res call({
 CreatedPillSheetValue? createdPillSheet, AutomaticallyRecordedLastTakenDateValue? automaticallyRecordedLastTakenDate, DeletedPillSheetValue? deletedPillSheet, TakenPillValue? takenPill, RevertTakenPillValue? revertTakenPill, ChangedPillNumberValue? changedPillNumber, EndedPillSheetValue? endedPillSheet, BeganRestDurationValue? beganRestDurationValue, EndedRestDurationValue? endedRestDurationValue, ChangedRestDurationBeginDateValue? changedRestDurationBeginDateValue, ChangedRestDurationValue? changedRestDurationValue, ChangedBeginDisplayNumberValue? changedBeginDisplayNumber, ChangedEndDisplayNumberValue? changedEndDisplayNumber
});


$CreatedPillSheetValueCopyWith<$Res>? get createdPillSheet;$AutomaticallyRecordedLastTakenDateValueCopyWith<$Res>? get automaticallyRecordedLastTakenDate;$DeletedPillSheetValueCopyWith<$Res>? get deletedPillSheet;$TakenPillValueCopyWith<$Res>? get takenPill;$RevertTakenPillValueCopyWith<$Res>? get revertTakenPill;$ChangedPillNumberValueCopyWith<$Res>? get changedPillNumber;$EndedPillSheetValueCopyWith<$Res>? get endedPillSheet;$BeganRestDurationValueCopyWith<$Res>? get beganRestDurationValue;$EndedRestDurationValueCopyWith<$Res>? get endedRestDurationValue;$ChangedRestDurationBeginDateValueCopyWith<$Res>? get changedRestDurationBeginDateValue;$ChangedRestDurationValueCopyWith<$Res>? get changedRestDurationValue;$ChangedBeginDisplayNumberValueCopyWith<$Res>? get changedBeginDisplayNumber;$ChangedEndDisplayNumberValueCopyWith<$Res>? get changedEndDisplayNumber;

}
/// @nodoc
class _$PillSheetModifiedHistoryValueCopyWithImpl<$Res>
    implements $PillSheetModifiedHistoryValueCopyWith<$Res> {
  _$PillSheetModifiedHistoryValueCopyWithImpl(this._self, this._then);

  final PillSheetModifiedHistoryValue _self;
  final $Res Function(PillSheetModifiedHistoryValue) _then;

/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? createdPillSheet = freezed,Object? automaticallyRecordedLastTakenDate = freezed,Object? deletedPillSheet = freezed,Object? takenPill = freezed,Object? revertTakenPill = freezed,Object? changedPillNumber = freezed,Object? endedPillSheet = freezed,Object? beganRestDurationValue = freezed,Object? endedRestDurationValue = freezed,Object? changedRestDurationBeginDateValue = freezed,Object? changedRestDurationValue = freezed,Object? changedBeginDisplayNumber = freezed,Object? changedEndDisplayNumber = freezed,}) {
  return _then(_self.copyWith(
createdPillSheet: freezed == createdPillSheet ? _self.createdPillSheet : createdPillSheet // ignore: cast_nullable_to_non_nullable
as CreatedPillSheetValue?,automaticallyRecordedLastTakenDate: freezed == automaticallyRecordedLastTakenDate ? _self.automaticallyRecordedLastTakenDate : automaticallyRecordedLastTakenDate // ignore: cast_nullable_to_non_nullable
as AutomaticallyRecordedLastTakenDateValue?,deletedPillSheet: freezed == deletedPillSheet ? _self.deletedPillSheet : deletedPillSheet // ignore: cast_nullable_to_non_nullable
as DeletedPillSheetValue?,takenPill: freezed == takenPill ? _self.takenPill : takenPill // ignore: cast_nullable_to_non_nullable
as TakenPillValue?,revertTakenPill: freezed == revertTakenPill ? _self.revertTakenPill : revertTakenPill // ignore: cast_nullable_to_non_nullable
as RevertTakenPillValue?,changedPillNumber: freezed == changedPillNumber ? _self.changedPillNumber : changedPillNumber // ignore: cast_nullable_to_non_nullable
as ChangedPillNumberValue?,endedPillSheet: freezed == endedPillSheet ? _self.endedPillSheet : endedPillSheet // ignore: cast_nullable_to_non_nullable
as EndedPillSheetValue?,beganRestDurationValue: freezed == beganRestDurationValue ? _self.beganRestDurationValue : beganRestDurationValue // ignore: cast_nullable_to_non_nullable
as BeganRestDurationValue?,endedRestDurationValue: freezed == endedRestDurationValue ? _self.endedRestDurationValue : endedRestDurationValue // ignore: cast_nullable_to_non_nullable
as EndedRestDurationValue?,changedRestDurationBeginDateValue: freezed == changedRestDurationBeginDateValue ? _self.changedRestDurationBeginDateValue : changedRestDurationBeginDateValue // ignore: cast_nullable_to_non_nullable
as ChangedRestDurationBeginDateValue?,changedRestDurationValue: freezed == changedRestDurationValue ? _self.changedRestDurationValue : changedRestDurationValue // ignore: cast_nullable_to_non_nullable
as ChangedRestDurationValue?,changedBeginDisplayNumber: freezed == changedBeginDisplayNumber ? _self.changedBeginDisplayNumber : changedBeginDisplayNumber // ignore: cast_nullable_to_non_nullable
as ChangedBeginDisplayNumberValue?,changedEndDisplayNumber: freezed == changedEndDisplayNumber ? _self.changedEndDisplayNumber : changedEndDisplayNumber // ignore: cast_nullable_to_non_nullable
as ChangedEndDisplayNumberValue?,
  ));
}
/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CreatedPillSheetValueCopyWith<$Res>? get createdPillSheet {
    if (_self.createdPillSheet == null) {
    return null;
  }

  return $CreatedPillSheetValueCopyWith<$Res>(_self.createdPillSheet!, (value) {
    return _then(_self.copyWith(createdPillSheet: value));
  });
}/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AutomaticallyRecordedLastTakenDateValueCopyWith<$Res>? get automaticallyRecordedLastTakenDate {
    if (_self.automaticallyRecordedLastTakenDate == null) {
    return null;
  }

  return $AutomaticallyRecordedLastTakenDateValueCopyWith<$Res>(_self.automaticallyRecordedLastTakenDate!, (value) {
    return _then(_self.copyWith(automaticallyRecordedLastTakenDate: value));
  });
}/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeletedPillSheetValueCopyWith<$Res>? get deletedPillSheet {
    if (_self.deletedPillSheet == null) {
    return null;
  }

  return $DeletedPillSheetValueCopyWith<$Res>(_self.deletedPillSheet!, (value) {
    return _then(_self.copyWith(deletedPillSheet: value));
  });
}/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TakenPillValueCopyWith<$Res>? get takenPill {
    if (_self.takenPill == null) {
    return null;
  }

  return $TakenPillValueCopyWith<$Res>(_self.takenPill!, (value) {
    return _then(_self.copyWith(takenPill: value));
  });
}/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RevertTakenPillValueCopyWith<$Res>? get revertTakenPill {
    if (_self.revertTakenPill == null) {
    return null;
  }

  return $RevertTakenPillValueCopyWith<$Res>(_self.revertTakenPill!, (value) {
    return _then(_self.copyWith(revertTakenPill: value));
  });
}/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChangedPillNumberValueCopyWith<$Res>? get changedPillNumber {
    if (_self.changedPillNumber == null) {
    return null;
  }

  return $ChangedPillNumberValueCopyWith<$Res>(_self.changedPillNumber!, (value) {
    return _then(_self.copyWith(changedPillNumber: value));
  });
}/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EndedPillSheetValueCopyWith<$Res>? get endedPillSheet {
    if (_self.endedPillSheet == null) {
    return null;
  }

  return $EndedPillSheetValueCopyWith<$Res>(_self.endedPillSheet!, (value) {
    return _then(_self.copyWith(endedPillSheet: value));
  });
}/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BeganRestDurationValueCopyWith<$Res>? get beganRestDurationValue {
    if (_self.beganRestDurationValue == null) {
    return null;
  }

  return $BeganRestDurationValueCopyWith<$Res>(_self.beganRestDurationValue!, (value) {
    return _then(_self.copyWith(beganRestDurationValue: value));
  });
}/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EndedRestDurationValueCopyWith<$Res>? get endedRestDurationValue {
    if (_self.endedRestDurationValue == null) {
    return null;
  }

  return $EndedRestDurationValueCopyWith<$Res>(_self.endedRestDurationValue!, (value) {
    return _then(_self.copyWith(endedRestDurationValue: value));
  });
}/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChangedRestDurationBeginDateValueCopyWith<$Res>? get changedRestDurationBeginDateValue {
    if (_self.changedRestDurationBeginDateValue == null) {
    return null;
  }

  return $ChangedRestDurationBeginDateValueCopyWith<$Res>(_self.changedRestDurationBeginDateValue!, (value) {
    return _then(_self.copyWith(changedRestDurationBeginDateValue: value));
  });
}/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChangedRestDurationValueCopyWith<$Res>? get changedRestDurationValue {
    if (_self.changedRestDurationValue == null) {
    return null;
  }

  return $ChangedRestDurationValueCopyWith<$Res>(_self.changedRestDurationValue!, (value) {
    return _then(_self.copyWith(changedRestDurationValue: value));
  });
}/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChangedBeginDisplayNumberValueCopyWith<$Res>? get changedBeginDisplayNumber {
    if (_self.changedBeginDisplayNumber == null) {
    return null;
  }

  return $ChangedBeginDisplayNumberValueCopyWith<$Res>(_self.changedBeginDisplayNumber!, (value) {
    return _then(_self.copyWith(changedBeginDisplayNumber: value));
  });
}/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChangedEndDisplayNumberValueCopyWith<$Res>? get changedEndDisplayNumber {
    if (_self.changedEndDisplayNumber == null) {
    return null;
  }

  return $ChangedEndDisplayNumberValueCopyWith<$Res>(_self.changedEndDisplayNumber!, (value) {
    return _then(_self.copyWith(changedEndDisplayNumber: value));
  });
}
}


/// Adds pattern-matching-related methods to [PillSheetModifiedHistoryValue].
extension PillSheetModifiedHistoryValuePatterns on PillSheetModifiedHistoryValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PillSheetModifiedHistoryValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PillSheetModifiedHistoryValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PillSheetModifiedHistoryValue value)  $default,){
final _that = this;
switch (_that) {
case _PillSheetModifiedHistoryValue():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PillSheetModifiedHistoryValue value)?  $default,){
final _that = this;
switch (_that) {
case _PillSheetModifiedHistoryValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CreatedPillSheetValue? createdPillSheet,  AutomaticallyRecordedLastTakenDateValue? automaticallyRecordedLastTakenDate,  DeletedPillSheetValue? deletedPillSheet,  TakenPillValue? takenPill,  RevertTakenPillValue? revertTakenPill,  ChangedPillNumberValue? changedPillNumber,  EndedPillSheetValue? endedPillSheet,  BeganRestDurationValue? beganRestDurationValue,  EndedRestDurationValue? endedRestDurationValue,  ChangedRestDurationBeginDateValue? changedRestDurationBeginDateValue,  ChangedRestDurationValue? changedRestDurationValue,  ChangedBeginDisplayNumberValue? changedBeginDisplayNumber,  ChangedEndDisplayNumberValue? changedEndDisplayNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PillSheetModifiedHistoryValue() when $default != null:
return $default(_that.createdPillSheet,_that.automaticallyRecordedLastTakenDate,_that.deletedPillSheet,_that.takenPill,_that.revertTakenPill,_that.changedPillNumber,_that.endedPillSheet,_that.beganRestDurationValue,_that.endedRestDurationValue,_that.changedRestDurationBeginDateValue,_that.changedRestDurationValue,_that.changedBeginDisplayNumber,_that.changedEndDisplayNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CreatedPillSheetValue? createdPillSheet,  AutomaticallyRecordedLastTakenDateValue? automaticallyRecordedLastTakenDate,  DeletedPillSheetValue? deletedPillSheet,  TakenPillValue? takenPill,  RevertTakenPillValue? revertTakenPill,  ChangedPillNumberValue? changedPillNumber,  EndedPillSheetValue? endedPillSheet,  BeganRestDurationValue? beganRestDurationValue,  EndedRestDurationValue? endedRestDurationValue,  ChangedRestDurationBeginDateValue? changedRestDurationBeginDateValue,  ChangedRestDurationValue? changedRestDurationValue,  ChangedBeginDisplayNumberValue? changedBeginDisplayNumber,  ChangedEndDisplayNumberValue? changedEndDisplayNumber)  $default,) {final _that = this;
switch (_that) {
case _PillSheetModifiedHistoryValue():
return $default(_that.createdPillSheet,_that.automaticallyRecordedLastTakenDate,_that.deletedPillSheet,_that.takenPill,_that.revertTakenPill,_that.changedPillNumber,_that.endedPillSheet,_that.beganRestDurationValue,_that.endedRestDurationValue,_that.changedRestDurationBeginDateValue,_that.changedRestDurationValue,_that.changedBeginDisplayNumber,_that.changedEndDisplayNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CreatedPillSheetValue? createdPillSheet,  AutomaticallyRecordedLastTakenDateValue? automaticallyRecordedLastTakenDate,  DeletedPillSheetValue? deletedPillSheet,  TakenPillValue? takenPill,  RevertTakenPillValue? revertTakenPill,  ChangedPillNumberValue? changedPillNumber,  EndedPillSheetValue? endedPillSheet,  BeganRestDurationValue? beganRestDurationValue,  EndedRestDurationValue? endedRestDurationValue,  ChangedRestDurationBeginDateValue? changedRestDurationBeginDateValue,  ChangedRestDurationValue? changedRestDurationValue,  ChangedBeginDisplayNumberValue? changedBeginDisplayNumber,  ChangedEndDisplayNumberValue? changedEndDisplayNumber)?  $default,) {final _that = this;
switch (_that) {
case _PillSheetModifiedHistoryValue() when $default != null:
return $default(_that.createdPillSheet,_that.automaticallyRecordedLastTakenDate,_that.deletedPillSheet,_that.takenPill,_that.revertTakenPill,_that.changedPillNumber,_that.endedPillSheet,_that.beganRestDurationValue,_that.endedRestDurationValue,_that.changedRestDurationBeginDateValue,_that.changedRestDurationValue,_that.changedBeginDisplayNumber,_that.changedEndDisplayNumber);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PillSheetModifiedHistoryValue extends PillSheetModifiedHistoryValue {
  const _PillSheetModifiedHistoryValue({this.createdPillSheet = null, this.automaticallyRecordedLastTakenDate = null, this.deletedPillSheet = null, this.takenPill = null, this.revertTakenPill = null, this.changedPillNumber = null, this.endedPillSheet = null, this.beganRestDurationValue = null, this.endedRestDurationValue = null, this.changedRestDurationBeginDateValue = null, this.changedRestDurationValue = null, this.changedBeginDisplayNumber = null, this.changedEndDisplayNumber = null}): super._();
  factory _PillSheetModifiedHistoryValue.fromJson(Map<String, dynamic> json) => _$PillSheetModifiedHistoryValueFromJson(json);

/// ピルシート作成時の記録
/// 新規ピルシートが作成された際の作成情報
@override@JsonKey() final  CreatedPillSheetValue? createdPillSheet;
/// 自動記録された最終服用日の変更
/// システムが自動的に最終服用日を更新した際の記録
@override@JsonKey() final  AutomaticallyRecordedLastTakenDateValue? automaticallyRecordedLastTakenDate;
/// ピルシート削除時の記録
/// ピルシートが削除された際の削除情報
@override@JsonKey() final  DeletedPillSheetValue? deletedPillSheet;
/// ピル服用記録時の情報
/// ユーザーがピルを服用したことを記録した際の情報
@override@JsonKey() final  TakenPillValue? takenPill;
/// ピル服用記録の取り消し情報
/// 誤って記録した服用を取り消した際の情報
@override@JsonKey() final  RevertTakenPillValue? revertTakenPill;
/// ピル番号変更時の記録
/// ピル番号の調整や修正が行われた際の変更情報
@override@JsonKey() final  ChangedPillNumberValue? changedPillNumber;
/// ピルシート終了時の記録
/// シートの服用完了や手動終了時の情報
@override@JsonKey() final  EndedPillSheetValue? endedPillSheet;
/// 休薬期間開始時の記録
/// ユーザーが服用を一時停止した際の開始情報
@override@JsonKey() final  BeganRestDurationValue? beganRestDurationValue;
/// 休薬期間終了時の記録
/// 休薬期間が終了し服用を再開した際の情報
@override@JsonKey() final  EndedRestDurationValue? endedRestDurationValue;
/// 休薬期間開始日変更時の記録（v2から追加）
/// 既存の休薬期間の開始日を変更した際の情報
@override@JsonKey() final  ChangedRestDurationBeginDateValue? changedRestDurationBeginDateValue;
/// 休薬期間内容変更時の記録（v2から追加）
/// 休薬期間の設定内容を変更した際の情報
@override@JsonKey() final  ChangedRestDurationValue? changedRestDurationValue;
/// 表示開始番号変更時の記録
/// ピルシートの表示番号の開始値を変更した際の情報
@override@JsonKey() final  ChangedBeginDisplayNumberValue? changedBeginDisplayNumber;
/// 表示終了番号変更時の記録
/// ピルシートの表示番号の終了値を変更した際の情報
@override@JsonKey() final  ChangedEndDisplayNumberValue? changedEndDisplayNumber;

/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PillSheetModifiedHistoryValueCopyWith<_PillSheetModifiedHistoryValue> get copyWith => __$PillSheetModifiedHistoryValueCopyWithImpl<_PillSheetModifiedHistoryValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PillSheetModifiedHistoryValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PillSheetModifiedHistoryValue&&(identical(other.createdPillSheet, createdPillSheet) || other.createdPillSheet == createdPillSheet)&&(identical(other.automaticallyRecordedLastTakenDate, automaticallyRecordedLastTakenDate) || other.automaticallyRecordedLastTakenDate == automaticallyRecordedLastTakenDate)&&(identical(other.deletedPillSheet, deletedPillSheet) || other.deletedPillSheet == deletedPillSheet)&&(identical(other.takenPill, takenPill) || other.takenPill == takenPill)&&(identical(other.revertTakenPill, revertTakenPill) || other.revertTakenPill == revertTakenPill)&&(identical(other.changedPillNumber, changedPillNumber) || other.changedPillNumber == changedPillNumber)&&(identical(other.endedPillSheet, endedPillSheet) || other.endedPillSheet == endedPillSheet)&&(identical(other.beganRestDurationValue, beganRestDurationValue) || other.beganRestDurationValue == beganRestDurationValue)&&(identical(other.endedRestDurationValue, endedRestDurationValue) || other.endedRestDurationValue == endedRestDurationValue)&&(identical(other.changedRestDurationBeginDateValue, changedRestDurationBeginDateValue) || other.changedRestDurationBeginDateValue == changedRestDurationBeginDateValue)&&(identical(other.changedRestDurationValue, changedRestDurationValue) || other.changedRestDurationValue == changedRestDurationValue)&&(identical(other.changedBeginDisplayNumber, changedBeginDisplayNumber) || other.changedBeginDisplayNumber == changedBeginDisplayNumber)&&(identical(other.changedEndDisplayNumber, changedEndDisplayNumber) || other.changedEndDisplayNumber == changedEndDisplayNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,createdPillSheet,automaticallyRecordedLastTakenDate,deletedPillSheet,takenPill,revertTakenPill,changedPillNumber,endedPillSheet,beganRestDurationValue,endedRestDurationValue,changedRestDurationBeginDateValue,changedRestDurationValue,changedBeginDisplayNumber,changedEndDisplayNumber);

@override
String toString() {
  return 'PillSheetModifiedHistoryValue(createdPillSheet: $createdPillSheet, automaticallyRecordedLastTakenDate: $automaticallyRecordedLastTakenDate, deletedPillSheet: $deletedPillSheet, takenPill: $takenPill, revertTakenPill: $revertTakenPill, changedPillNumber: $changedPillNumber, endedPillSheet: $endedPillSheet, beganRestDurationValue: $beganRestDurationValue, endedRestDurationValue: $endedRestDurationValue, changedRestDurationBeginDateValue: $changedRestDurationBeginDateValue, changedRestDurationValue: $changedRestDurationValue, changedBeginDisplayNumber: $changedBeginDisplayNumber, changedEndDisplayNumber: $changedEndDisplayNumber)';
}


}

/// @nodoc
abstract mixin class _$PillSheetModifiedHistoryValueCopyWith<$Res> implements $PillSheetModifiedHistoryValueCopyWith<$Res> {
  factory _$PillSheetModifiedHistoryValueCopyWith(_PillSheetModifiedHistoryValue value, $Res Function(_PillSheetModifiedHistoryValue) _then) = __$PillSheetModifiedHistoryValueCopyWithImpl;
@override @useResult
$Res call({
 CreatedPillSheetValue? createdPillSheet, AutomaticallyRecordedLastTakenDateValue? automaticallyRecordedLastTakenDate, DeletedPillSheetValue? deletedPillSheet, TakenPillValue? takenPill, RevertTakenPillValue? revertTakenPill, ChangedPillNumberValue? changedPillNumber, EndedPillSheetValue? endedPillSheet, BeganRestDurationValue? beganRestDurationValue, EndedRestDurationValue? endedRestDurationValue, ChangedRestDurationBeginDateValue? changedRestDurationBeginDateValue, ChangedRestDurationValue? changedRestDurationValue, ChangedBeginDisplayNumberValue? changedBeginDisplayNumber, ChangedEndDisplayNumberValue? changedEndDisplayNumber
});


@override $CreatedPillSheetValueCopyWith<$Res>? get createdPillSheet;@override $AutomaticallyRecordedLastTakenDateValueCopyWith<$Res>? get automaticallyRecordedLastTakenDate;@override $DeletedPillSheetValueCopyWith<$Res>? get deletedPillSheet;@override $TakenPillValueCopyWith<$Res>? get takenPill;@override $RevertTakenPillValueCopyWith<$Res>? get revertTakenPill;@override $ChangedPillNumberValueCopyWith<$Res>? get changedPillNumber;@override $EndedPillSheetValueCopyWith<$Res>? get endedPillSheet;@override $BeganRestDurationValueCopyWith<$Res>? get beganRestDurationValue;@override $EndedRestDurationValueCopyWith<$Res>? get endedRestDurationValue;@override $ChangedRestDurationBeginDateValueCopyWith<$Res>? get changedRestDurationBeginDateValue;@override $ChangedRestDurationValueCopyWith<$Res>? get changedRestDurationValue;@override $ChangedBeginDisplayNumberValueCopyWith<$Res>? get changedBeginDisplayNumber;@override $ChangedEndDisplayNumberValueCopyWith<$Res>? get changedEndDisplayNumber;

}
/// @nodoc
class __$PillSheetModifiedHistoryValueCopyWithImpl<$Res>
    implements _$PillSheetModifiedHistoryValueCopyWith<$Res> {
  __$PillSheetModifiedHistoryValueCopyWithImpl(this._self, this._then);

  final _PillSheetModifiedHistoryValue _self;
  final $Res Function(_PillSheetModifiedHistoryValue) _then;

/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? createdPillSheet = freezed,Object? automaticallyRecordedLastTakenDate = freezed,Object? deletedPillSheet = freezed,Object? takenPill = freezed,Object? revertTakenPill = freezed,Object? changedPillNumber = freezed,Object? endedPillSheet = freezed,Object? beganRestDurationValue = freezed,Object? endedRestDurationValue = freezed,Object? changedRestDurationBeginDateValue = freezed,Object? changedRestDurationValue = freezed,Object? changedBeginDisplayNumber = freezed,Object? changedEndDisplayNumber = freezed,}) {
  return _then(_PillSheetModifiedHistoryValue(
createdPillSheet: freezed == createdPillSheet ? _self.createdPillSheet : createdPillSheet // ignore: cast_nullable_to_non_nullable
as CreatedPillSheetValue?,automaticallyRecordedLastTakenDate: freezed == automaticallyRecordedLastTakenDate ? _self.automaticallyRecordedLastTakenDate : automaticallyRecordedLastTakenDate // ignore: cast_nullable_to_non_nullable
as AutomaticallyRecordedLastTakenDateValue?,deletedPillSheet: freezed == deletedPillSheet ? _self.deletedPillSheet : deletedPillSheet // ignore: cast_nullable_to_non_nullable
as DeletedPillSheetValue?,takenPill: freezed == takenPill ? _self.takenPill : takenPill // ignore: cast_nullable_to_non_nullable
as TakenPillValue?,revertTakenPill: freezed == revertTakenPill ? _self.revertTakenPill : revertTakenPill // ignore: cast_nullable_to_non_nullable
as RevertTakenPillValue?,changedPillNumber: freezed == changedPillNumber ? _self.changedPillNumber : changedPillNumber // ignore: cast_nullable_to_non_nullable
as ChangedPillNumberValue?,endedPillSheet: freezed == endedPillSheet ? _self.endedPillSheet : endedPillSheet // ignore: cast_nullable_to_non_nullable
as EndedPillSheetValue?,beganRestDurationValue: freezed == beganRestDurationValue ? _self.beganRestDurationValue : beganRestDurationValue // ignore: cast_nullable_to_non_nullable
as BeganRestDurationValue?,endedRestDurationValue: freezed == endedRestDurationValue ? _self.endedRestDurationValue : endedRestDurationValue // ignore: cast_nullable_to_non_nullable
as EndedRestDurationValue?,changedRestDurationBeginDateValue: freezed == changedRestDurationBeginDateValue ? _self.changedRestDurationBeginDateValue : changedRestDurationBeginDateValue // ignore: cast_nullable_to_non_nullable
as ChangedRestDurationBeginDateValue?,changedRestDurationValue: freezed == changedRestDurationValue ? _self.changedRestDurationValue : changedRestDurationValue // ignore: cast_nullable_to_non_nullable
as ChangedRestDurationValue?,changedBeginDisplayNumber: freezed == changedBeginDisplayNumber ? _self.changedBeginDisplayNumber : changedBeginDisplayNumber // ignore: cast_nullable_to_non_nullable
as ChangedBeginDisplayNumberValue?,changedEndDisplayNumber: freezed == changedEndDisplayNumber ? _self.changedEndDisplayNumber : changedEndDisplayNumber // ignore: cast_nullable_to_non_nullable
as ChangedEndDisplayNumberValue?,
  ));
}

/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CreatedPillSheetValueCopyWith<$Res>? get createdPillSheet {
    if (_self.createdPillSheet == null) {
    return null;
  }

  return $CreatedPillSheetValueCopyWith<$Res>(_self.createdPillSheet!, (value) {
    return _then(_self.copyWith(createdPillSheet: value));
  });
}/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AutomaticallyRecordedLastTakenDateValueCopyWith<$Res>? get automaticallyRecordedLastTakenDate {
    if (_self.automaticallyRecordedLastTakenDate == null) {
    return null;
  }

  return $AutomaticallyRecordedLastTakenDateValueCopyWith<$Res>(_self.automaticallyRecordedLastTakenDate!, (value) {
    return _then(_self.copyWith(automaticallyRecordedLastTakenDate: value));
  });
}/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeletedPillSheetValueCopyWith<$Res>? get deletedPillSheet {
    if (_self.deletedPillSheet == null) {
    return null;
  }

  return $DeletedPillSheetValueCopyWith<$Res>(_self.deletedPillSheet!, (value) {
    return _then(_self.copyWith(deletedPillSheet: value));
  });
}/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TakenPillValueCopyWith<$Res>? get takenPill {
    if (_self.takenPill == null) {
    return null;
  }

  return $TakenPillValueCopyWith<$Res>(_self.takenPill!, (value) {
    return _then(_self.copyWith(takenPill: value));
  });
}/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RevertTakenPillValueCopyWith<$Res>? get revertTakenPill {
    if (_self.revertTakenPill == null) {
    return null;
  }

  return $RevertTakenPillValueCopyWith<$Res>(_self.revertTakenPill!, (value) {
    return _then(_self.copyWith(revertTakenPill: value));
  });
}/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChangedPillNumberValueCopyWith<$Res>? get changedPillNumber {
    if (_self.changedPillNumber == null) {
    return null;
  }

  return $ChangedPillNumberValueCopyWith<$Res>(_self.changedPillNumber!, (value) {
    return _then(_self.copyWith(changedPillNumber: value));
  });
}/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EndedPillSheetValueCopyWith<$Res>? get endedPillSheet {
    if (_self.endedPillSheet == null) {
    return null;
  }

  return $EndedPillSheetValueCopyWith<$Res>(_self.endedPillSheet!, (value) {
    return _then(_self.copyWith(endedPillSheet: value));
  });
}/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BeganRestDurationValueCopyWith<$Res>? get beganRestDurationValue {
    if (_self.beganRestDurationValue == null) {
    return null;
  }

  return $BeganRestDurationValueCopyWith<$Res>(_self.beganRestDurationValue!, (value) {
    return _then(_self.copyWith(beganRestDurationValue: value));
  });
}/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EndedRestDurationValueCopyWith<$Res>? get endedRestDurationValue {
    if (_self.endedRestDurationValue == null) {
    return null;
  }

  return $EndedRestDurationValueCopyWith<$Res>(_self.endedRestDurationValue!, (value) {
    return _then(_self.copyWith(endedRestDurationValue: value));
  });
}/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChangedRestDurationBeginDateValueCopyWith<$Res>? get changedRestDurationBeginDateValue {
    if (_self.changedRestDurationBeginDateValue == null) {
    return null;
  }

  return $ChangedRestDurationBeginDateValueCopyWith<$Res>(_self.changedRestDurationBeginDateValue!, (value) {
    return _then(_self.copyWith(changedRestDurationBeginDateValue: value));
  });
}/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChangedRestDurationValueCopyWith<$Res>? get changedRestDurationValue {
    if (_self.changedRestDurationValue == null) {
    return null;
  }

  return $ChangedRestDurationValueCopyWith<$Res>(_self.changedRestDurationValue!, (value) {
    return _then(_self.copyWith(changedRestDurationValue: value));
  });
}/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChangedBeginDisplayNumberValueCopyWith<$Res>? get changedBeginDisplayNumber {
    if (_self.changedBeginDisplayNumber == null) {
    return null;
  }

  return $ChangedBeginDisplayNumberValueCopyWith<$Res>(_self.changedBeginDisplayNumber!, (value) {
    return _then(_self.copyWith(changedBeginDisplayNumber: value));
  });
}/// Create a copy of PillSheetModifiedHistoryValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChangedEndDisplayNumberValueCopyWith<$Res>? get changedEndDisplayNumber {
    if (_self.changedEndDisplayNumber == null) {
    return null;
  }

  return $ChangedEndDisplayNumberValueCopyWith<$Res>(_self.changedEndDisplayNumber!, (value) {
    return _then(_self.copyWith(changedEndDisplayNumber: value));
  });
}
}


/// @nodoc
mixin _$CreatedPillSheetValue {

// The below properties are deprecated and added since v1.
// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
/// ピルシート作成日時（非推奨）
/// Firestoreタイムスタンプから自動変換される作成日時
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get pillSheetCreatedAt;/// 作成されたピルシートのIDリスト（非推奨）
/// 複数シート同時作成に対応するためのIDリスト
 List<String> get pillSheetIDs;
/// Create a copy of CreatedPillSheetValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatedPillSheetValueCopyWith<CreatedPillSheetValue> get copyWith => _$CreatedPillSheetValueCopyWithImpl<CreatedPillSheetValue>(this as CreatedPillSheetValue, _$identity);

  /// Serializes this CreatedPillSheetValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatedPillSheetValue&&(identical(other.pillSheetCreatedAt, pillSheetCreatedAt) || other.pillSheetCreatedAt == pillSheetCreatedAt)&&const DeepCollectionEquality().equals(other.pillSheetIDs, pillSheetIDs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pillSheetCreatedAt,const DeepCollectionEquality().hash(pillSheetIDs));

@override
String toString() {
  return 'CreatedPillSheetValue(pillSheetCreatedAt: $pillSheetCreatedAt, pillSheetIDs: $pillSheetIDs)';
}


}

/// @nodoc
abstract mixin class $CreatedPillSheetValueCopyWith<$Res>  {
  factory $CreatedPillSheetValueCopyWith(CreatedPillSheetValue value, $Res Function(CreatedPillSheetValue) _then) = _$CreatedPillSheetValueCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime pillSheetCreatedAt, List<String> pillSheetIDs
});




}
/// @nodoc
class _$CreatedPillSheetValueCopyWithImpl<$Res>
    implements $CreatedPillSheetValueCopyWith<$Res> {
  _$CreatedPillSheetValueCopyWithImpl(this._self, this._then);

  final CreatedPillSheetValue _self;
  final $Res Function(CreatedPillSheetValue) _then;

/// Create a copy of CreatedPillSheetValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pillSheetCreatedAt = null,Object? pillSheetIDs = null,}) {
  return _then(_self.copyWith(
pillSheetCreatedAt: null == pillSheetCreatedAt ? _self.pillSheetCreatedAt : pillSheetCreatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,pillSheetIDs: null == pillSheetIDs ? _self.pillSheetIDs : pillSheetIDs // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CreatedPillSheetValue].
extension CreatedPillSheetValuePatterns on CreatedPillSheetValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreatedPillSheetValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreatedPillSheetValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreatedPillSheetValue value)  $default,){
final _that = this;
switch (_that) {
case _CreatedPillSheetValue():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreatedPillSheetValue value)?  $default,){
final _that = this;
switch (_that) {
case _CreatedPillSheetValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime pillSheetCreatedAt,  List<String> pillSheetIDs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreatedPillSheetValue() when $default != null:
return $default(_that.pillSheetCreatedAt,_that.pillSheetIDs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime pillSheetCreatedAt,  List<String> pillSheetIDs)  $default,) {final _that = this;
switch (_that) {
case _CreatedPillSheetValue():
return $default(_that.pillSheetCreatedAt,_that.pillSheetIDs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime pillSheetCreatedAt,  List<String> pillSheetIDs)?  $default,) {final _that = this;
switch (_that) {
case _CreatedPillSheetValue() when $default != null:
return $default(_that.pillSheetCreatedAt,_that.pillSheetIDs);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CreatedPillSheetValue extends CreatedPillSheetValue {
  const _CreatedPillSheetValue({@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.pillSheetCreatedAt, final  List<String> pillSheetIDs = const []}): _pillSheetIDs = pillSheetIDs,super._();
  factory _CreatedPillSheetValue.fromJson(Map<String, dynamic> json) => _$CreatedPillSheetValueFromJson(json);

// The below properties are deprecated and added since v1.
// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
/// ピルシート作成日時（非推奨）
/// Firestoreタイムスタンプから自動変換される作成日時
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime pillSheetCreatedAt;
/// 作成されたピルシートのIDリスト（非推奨）
/// 複数シート同時作成に対応するためのIDリスト
 final  List<String> _pillSheetIDs;
/// 作成されたピルシートのIDリスト（非推奨）
/// 複数シート同時作成に対応するためのIDリスト
@override@JsonKey() List<String> get pillSheetIDs {
  if (_pillSheetIDs is EqualUnmodifiableListView) return _pillSheetIDs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pillSheetIDs);
}


/// Create a copy of CreatedPillSheetValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatedPillSheetValueCopyWith<_CreatedPillSheetValue> get copyWith => __$CreatedPillSheetValueCopyWithImpl<_CreatedPillSheetValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreatedPillSheetValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatedPillSheetValue&&(identical(other.pillSheetCreatedAt, pillSheetCreatedAt) || other.pillSheetCreatedAt == pillSheetCreatedAt)&&const DeepCollectionEquality().equals(other._pillSheetIDs, _pillSheetIDs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pillSheetCreatedAt,const DeepCollectionEquality().hash(_pillSheetIDs));

@override
String toString() {
  return 'CreatedPillSheetValue(pillSheetCreatedAt: $pillSheetCreatedAt, pillSheetIDs: $pillSheetIDs)';
}


}

/// @nodoc
abstract mixin class _$CreatedPillSheetValueCopyWith<$Res> implements $CreatedPillSheetValueCopyWith<$Res> {
  factory _$CreatedPillSheetValueCopyWith(_CreatedPillSheetValue value, $Res Function(_CreatedPillSheetValue) _then) = __$CreatedPillSheetValueCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime pillSheetCreatedAt, List<String> pillSheetIDs
});




}
/// @nodoc
class __$CreatedPillSheetValueCopyWithImpl<$Res>
    implements _$CreatedPillSheetValueCopyWith<$Res> {
  __$CreatedPillSheetValueCopyWithImpl(this._self, this._then);

  final _CreatedPillSheetValue _self;
  final $Res Function(_CreatedPillSheetValue) _then;

/// Create a copy of CreatedPillSheetValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pillSheetCreatedAt = null,Object? pillSheetIDs = null,}) {
  return _then(_CreatedPillSheetValue(
pillSheetCreatedAt: null == pillSheetCreatedAt ? _self.pillSheetCreatedAt : pillSheetCreatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,pillSheetIDs: null == pillSheetIDs ? _self._pillSheetIDs : pillSheetIDs // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$AutomaticallyRecordedLastTakenDateValue {

// The below properties are deprecated and added since v1.
// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
/// 変更前の最終服用日（非推奨、nullable）
/// 初回服用の場合はnullとなる
@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? get beforeLastTakenDate;/// 変更後の最終服用日（非推奨）
/// 自動記録によって設定された新しい最終服用日
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get afterLastTakenDate;/// 変更前の最終服用ピル番号（非推奨）
/// 自動記録前のピル番号
 int get beforeLastTakenPillNumber;/// 変更後の最終服用ピル番号（非推奨）
/// 自動記録後のピル番号
 int get afterLastTakenPillNumber;
/// Create a copy of AutomaticallyRecordedLastTakenDateValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AutomaticallyRecordedLastTakenDateValueCopyWith<AutomaticallyRecordedLastTakenDateValue> get copyWith => _$AutomaticallyRecordedLastTakenDateValueCopyWithImpl<AutomaticallyRecordedLastTakenDateValue>(this as AutomaticallyRecordedLastTakenDateValue, _$identity);

  /// Serializes this AutomaticallyRecordedLastTakenDateValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AutomaticallyRecordedLastTakenDateValue&&(identical(other.beforeLastTakenDate, beforeLastTakenDate) || other.beforeLastTakenDate == beforeLastTakenDate)&&(identical(other.afterLastTakenDate, afterLastTakenDate) || other.afterLastTakenDate == afterLastTakenDate)&&(identical(other.beforeLastTakenPillNumber, beforeLastTakenPillNumber) || other.beforeLastTakenPillNumber == beforeLastTakenPillNumber)&&(identical(other.afterLastTakenPillNumber, afterLastTakenPillNumber) || other.afterLastTakenPillNumber == afterLastTakenPillNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,beforeLastTakenDate,afterLastTakenDate,beforeLastTakenPillNumber,afterLastTakenPillNumber);

@override
String toString() {
  return 'AutomaticallyRecordedLastTakenDateValue(beforeLastTakenDate: $beforeLastTakenDate, afterLastTakenDate: $afterLastTakenDate, beforeLastTakenPillNumber: $beforeLastTakenPillNumber, afterLastTakenPillNumber: $afterLastTakenPillNumber)';
}


}

/// @nodoc
abstract mixin class $AutomaticallyRecordedLastTakenDateValueCopyWith<$Res>  {
  factory $AutomaticallyRecordedLastTakenDateValueCopyWith(AutomaticallyRecordedLastTakenDateValue value, $Res Function(AutomaticallyRecordedLastTakenDateValue) _then) = _$AutomaticallyRecordedLastTakenDateValueCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? beforeLastTakenDate,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime afterLastTakenDate, int beforeLastTakenPillNumber, int afterLastTakenPillNumber
});




}
/// @nodoc
class _$AutomaticallyRecordedLastTakenDateValueCopyWithImpl<$Res>
    implements $AutomaticallyRecordedLastTakenDateValueCopyWith<$Res> {
  _$AutomaticallyRecordedLastTakenDateValueCopyWithImpl(this._self, this._then);

  final AutomaticallyRecordedLastTakenDateValue _self;
  final $Res Function(AutomaticallyRecordedLastTakenDateValue) _then;

/// Create a copy of AutomaticallyRecordedLastTakenDateValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? beforeLastTakenDate = freezed,Object? afterLastTakenDate = null,Object? beforeLastTakenPillNumber = null,Object? afterLastTakenPillNumber = null,}) {
  return _then(_self.copyWith(
beforeLastTakenDate: freezed == beforeLastTakenDate ? _self.beforeLastTakenDate : beforeLastTakenDate // ignore: cast_nullable_to_non_nullable
as DateTime?,afterLastTakenDate: null == afterLastTakenDate ? _self.afterLastTakenDate : afterLastTakenDate // ignore: cast_nullable_to_non_nullable
as DateTime,beforeLastTakenPillNumber: null == beforeLastTakenPillNumber ? _self.beforeLastTakenPillNumber : beforeLastTakenPillNumber // ignore: cast_nullable_to_non_nullable
as int,afterLastTakenPillNumber: null == afterLastTakenPillNumber ? _self.afterLastTakenPillNumber : afterLastTakenPillNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AutomaticallyRecordedLastTakenDateValue].
extension AutomaticallyRecordedLastTakenDateValuePatterns on AutomaticallyRecordedLastTakenDateValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AutomaticallyRecordedLastTakenDateValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AutomaticallyRecordedLastTakenDateValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AutomaticallyRecordedLastTakenDateValue value)  $default,){
final _that = this;
switch (_that) {
case _AutomaticallyRecordedLastTakenDateValue():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AutomaticallyRecordedLastTakenDateValue value)?  $default,){
final _that = this;
switch (_that) {
case _AutomaticallyRecordedLastTakenDateValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? beforeLastTakenDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime afterLastTakenDate,  int beforeLastTakenPillNumber,  int afterLastTakenPillNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AutomaticallyRecordedLastTakenDateValue() when $default != null:
return $default(_that.beforeLastTakenDate,_that.afterLastTakenDate,_that.beforeLastTakenPillNumber,_that.afterLastTakenPillNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? beforeLastTakenDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime afterLastTakenDate,  int beforeLastTakenPillNumber,  int afterLastTakenPillNumber)  $default,) {final _that = this;
switch (_that) {
case _AutomaticallyRecordedLastTakenDateValue():
return $default(_that.beforeLastTakenDate,_that.afterLastTakenDate,_that.beforeLastTakenPillNumber,_that.afterLastTakenPillNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? beforeLastTakenDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime afterLastTakenDate,  int beforeLastTakenPillNumber,  int afterLastTakenPillNumber)?  $default,) {final _that = this;
switch (_that) {
case _AutomaticallyRecordedLastTakenDateValue() when $default != null:
return $default(_that.beforeLastTakenDate,_that.afterLastTakenDate,_that.beforeLastTakenPillNumber,_that.afterLastTakenPillNumber);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AutomaticallyRecordedLastTakenDateValue extends AutomaticallyRecordedLastTakenDateValue {
  const _AutomaticallyRecordedLastTakenDateValue({@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) this.beforeLastTakenDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.afterLastTakenDate, required this.beforeLastTakenPillNumber, required this.afterLastTakenPillNumber}): super._();
  factory _AutomaticallyRecordedLastTakenDateValue.fromJson(Map<String, dynamic> json) => _$AutomaticallyRecordedLastTakenDateValueFromJson(json);

// The below properties are deprecated and added since v1.
// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
/// 変更前の最終服用日（非推奨、nullable）
/// 初回服用の場合はnullとなる
@override@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) final  DateTime? beforeLastTakenDate;
/// 変更後の最終服用日（非推奨）
/// 自動記録によって設定された新しい最終服用日
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime afterLastTakenDate;
/// 変更前の最終服用ピル番号（非推奨）
/// 自動記録前のピル番号
@override final  int beforeLastTakenPillNumber;
/// 変更後の最終服用ピル番号（非推奨）
/// 自動記録後のピル番号
@override final  int afterLastTakenPillNumber;

/// Create a copy of AutomaticallyRecordedLastTakenDateValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AutomaticallyRecordedLastTakenDateValueCopyWith<_AutomaticallyRecordedLastTakenDateValue> get copyWith => __$AutomaticallyRecordedLastTakenDateValueCopyWithImpl<_AutomaticallyRecordedLastTakenDateValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AutomaticallyRecordedLastTakenDateValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AutomaticallyRecordedLastTakenDateValue&&(identical(other.beforeLastTakenDate, beforeLastTakenDate) || other.beforeLastTakenDate == beforeLastTakenDate)&&(identical(other.afterLastTakenDate, afterLastTakenDate) || other.afterLastTakenDate == afterLastTakenDate)&&(identical(other.beforeLastTakenPillNumber, beforeLastTakenPillNumber) || other.beforeLastTakenPillNumber == beforeLastTakenPillNumber)&&(identical(other.afterLastTakenPillNumber, afterLastTakenPillNumber) || other.afterLastTakenPillNumber == afterLastTakenPillNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,beforeLastTakenDate,afterLastTakenDate,beforeLastTakenPillNumber,afterLastTakenPillNumber);

@override
String toString() {
  return 'AutomaticallyRecordedLastTakenDateValue(beforeLastTakenDate: $beforeLastTakenDate, afterLastTakenDate: $afterLastTakenDate, beforeLastTakenPillNumber: $beforeLastTakenPillNumber, afterLastTakenPillNumber: $afterLastTakenPillNumber)';
}


}

/// @nodoc
abstract mixin class _$AutomaticallyRecordedLastTakenDateValueCopyWith<$Res> implements $AutomaticallyRecordedLastTakenDateValueCopyWith<$Res> {
  factory _$AutomaticallyRecordedLastTakenDateValueCopyWith(_AutomaticallyRecordedLastTakenDateValue value, $Res Function(_AutomaticallyRecordedLastTakenDateValue) _then) = __$AutomaticallyRecordedLastTakenDateValueCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? beforeLastTakenDate,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime afterLastTakenDate, int beforeLastTakenPillNumber, int afterLastTakenPillNumber
});




}
/// @nodoc
class __$AutomaticallyRecordedLastTakenDateValueCopyWithImpl<$Res>
    implements _$AutomaticallyRecordedLastTakenDateValueCopyWith<$Res> {
  __$AutomaticallyRecordedLastTakenDateValueCopyWithImpl(this._self, this._then);

  final _AutomaticallyRecordedLastTakenDateValue _self;
  final $Res Function(_AutomaticallyRecordedLastTakenDateValue) _then;

/// Create a copy of AutomaticallyRecordedLastTakenDateValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? beforeLastTakenDate = freezed,Object? afterLastTakenDate = null,Object? beforeLastTakenPillNumber = null,Object? afterLastTakenPillNumber = null,}) {
  return _then(_AutomaticallyRecordedLastTakenDateValue(
beforeLastTakenDate: freezed == beforeLastTakenDate ? _self.beforeLastTakenDate : beforeLastTakenDate // ignore: cast_nullable_to_non_nullable
as DateTime?,afterLastTakenDate: null == afterLastTakenDate ? _self.afterLastTakenDate : afterLastTakenDate // ignore: cast_nullable_to_non_nullable
as DateTime,beforeLastTakenPillNumber: null == beforeLastTakenPillNumber ? _self.beforeLastTakenPillNumber : beforeLastTakenPillNumber // ignore: cast_nullable_to_non_nullable
as int,afterLastTakenPillNumber: null == afterLastTakenPillNumber ? _self.afterLastTakenPillNumber : afterLastTakenPillNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DeletedPillSheetValue {

// The below properties are deprecated and added since v1.
// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
/// ピルシート削除日時（非推奨）
/// Firestoreタイムスタンプから自動変換される削除日時
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get pillSheetDeletedAt;/// 削除されたピルシートのIDリスト（非推奨）
/// 複数シート同時削除に対応するためのIDリスト
 List<String> get pillSheetIDs;
/// Create a copy of DeletedPillSheetValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeletedPillSheetValueCopyWith<DeletedPillSheetValue> get copyWith => _$DeletedPillSheetValueCopyWithImpl<DeletedPillSheetValue>(this as DeletedPillSheetValue, _$identity);

  /// Serializes this DeletedPillSheetValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeletedPillSheetValue&&(identical(other.pillSheetDeletedAt, pillSheetDeletedAt) || other.pillSheetDeletedAt == pillSheetDeletedAt)&&const DeepCollectionEquality().equals(other.pillSheetIDs, pillSheetIDs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pillSheetDeletedAt,const DeepCollectionEquality().hash(pillSheetIDs));

@override
String toString() {
  return 'DeletedPillSheetValue(pillSheetDeletedAt: $pillSheetDeletedAt, pillSheetIDs: $pillSheetIDs)';
}


}

/// @nodoc
abstract mixin class $DeletedPillSheetValueCopyWith<$Res>  {
  factory $DeletedPillSheetValueCopyWith(DeletedPillSheetValue value, $Res Function(DeletedPillSheetValue) _then) = _$DeletedPillSheetValueCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime pillSheetDeletedAt, List<String> pillSheetIDs
});




}
/// @nodoc
class _$DeletedPillSheetValueCopyWithImpl<$Res>
    implements $DeletedPillSheetValueCopyWith<$Res> {
  _$DeletedPillSheetValueCopyWithImpl(this._self, this._then);

  final DeletedPillSheetValue _self;
  final $Res Function(DeletedPillSheetValue) _then;

/// Create a copy of DeletedPillSheetValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pillSheetDeletedAt = null,Object? pillSheetIDs = null,}) {
  return _then(_self.copyWith(
pillSheetDeletedAt: null == pillSheetDeletedAt ? _self.pillSheetDeletedAt : pillSheetDeletedAt // ignore: cast_nullable_to_non_nullable
as DateTime,pillSheetIDs: null == pillSheetIDs ? _self.pillSheetIDs : pillSheetIDs // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [DeletedPillSheetValue].
extension DeletedPillSheetValuePatterns on DeletedPillSheetValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeletedPillSheetValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeletedPillSheetValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeletedPillSheetValue value)  $default,){
final _that = this;
switch (_that) {
case _DeletedPillSheetValue():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeletedPillSheetValue value)?  $default,){
final _that = this;
switch (_that) {
case _DeletedPillSheetValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime pillSheetDeletedAt,  List<String> pillSheetIDs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeletedPillSheetValue() when $default != null:
return $default(_that.pillSheetDeletedAt,_that.pillSheetIDs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime pillSheetDeletedAt,  List<String> pillSheetIDs)  $default,) {final _that = this;
switch (_that) {
case _DeletedPillSheetValue():
return $default(_that.pillSheetDeletedAt,_that.pillSheetIDs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime pillSheetDeletedAt,  List<String> pillSheetIDs)?  $default,) {final _that = this;
switch (_that) {
case _DeletedPillSheetValue() when $default != null:
return $default(_that.pillSheetDeletedAt,_that.pillSheetIDs);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _DeletedPillSheetValue extends DeletedPillSheetValue {
  const _DeletedPillSheetValue({@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.pillSheetDeletedAt, final  List<String> pillSheetIDs = const []}): _pillSheetIDs = pillSheetIDs,super._();
  factory _DeletedPillSheetValue.fromJson(Map<String, dynamic> json) => _$DeletedPillSheetValueFromJson(json);

// The below properties are deprecated and added since v1.
// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
/// ピルシート削除日時（非推奨）
/// Firestoreタイムスタンプから自動変換される削除日時
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime pillSheetDeletedAt;
/// 削除されたピルシートのIDリスト（非推奨）
/// 複数シート同時削除に対応するためのIDリスト
 final  List<String> _pillSheetIDs;
/// 削除されたピルシートのIDリスト（非推奨）
/// 複数シート同時削除に対応するためのIDリスト
@override@JsonKey() List<String> get pillSheetIDs {
  if (_pillSheetIDs is EqualUnmodifiableListView) return _pillSheetIDs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pillSheetIDs);
}


/// Create a copy of DeletedPillSheetValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeletedPillSheetValueCopyWith<_DeletedPillSheetValue> get copyWith => __$DeletedPillSheetValueCopyWithImpl<_DeletedPillSheetValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeletedPillSheetValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeletedPillSheetValue&&(identical(other.pillSheetDeletedAt, pillSheetDeletedAt) || other.pillSheetDeletedAt == pillSheetDeletedAt)&&const DeepCollectionEquality().equals(other._pillSheetIDs, _pillSheetIDs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pillSheetDeletedAt,const DeepCollectionEquality().hash(_pillSheetIDs));

@override
String toString() {
  return 'DeletedPillSheetValue(pillSheetDeletedAt: $pillSheetDeletedAt, pillSheetIDs: $pillSheetIDs)';
}


}

/// @nodoc
abstract mixin class _$DeletedPillSheetValueCopyWith<$Res> implements $DeletedPillSheetValueCopyWith<$Res> {
  factory _$DeletedPillSheetValueCopyWith(_DeletedPillSheetValue value, $Res Function(_DeletedPillSheetValue) _then) = __$DeletedPillSheetValueCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime pillSheetDeletedAt, List<String> pillSheetIDs
});




}
/// @nodoc
class __$DeletedPillSheetValueCopyWithImpl<$Res>
    implements _$DeletedPillSheetValueCopyWith<$Res> {
  __$DeletedPillSheetValueCopyWithImpl(this._self, this._then);

  final _DeletedPillSheetValue _self;
  final $Res Function(_DeletedPillSheetValue) _then;

/// Create a copy of DeletedPillSheetValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pillSheetDeletedAt = null,Object? pillSheetIDs = null,}) {
  return _then(_DeletedPillSheetValue(
pillSheetDeletedAt: null == pillSheetDeletedAt ? _self.pillSheetDeletedAt : pillSheetDeletedAt // ignore: cast_nullable_to_non_nullable
as DateTime,pillSheetIDs: null == pillSheetIDs ? _self._pillSheetIDs : pillSheetIDs // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$TakenPillValue {

// ============ BEGIN: Added since v1 ============
/// クイック記録かどうかのフラグ（v1追加）
/// nullは途中から追加されたプロパティのため判定不能を表す
// null => 途中から追加したプロパティなので、どちらか不明
 bool? get isQuickRecord;/// 服用記録の編集情報（v1追加）
/// ユーザーが後から服用時刻を編集した場合の詳細情報
 TakenPillEditedValue? get edited;// ============ END: Added since v1 ============
// The below properties are deprecated and added since v1.
// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
/// 変更前の最終服用日（非推奨、nullable）
/// 初回服用の場合はnullとなる
@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? get beforeLastTakenDate;/// 変更後の最終服用日（非推奨）
/// 服用記録によって設定された新しい最終服用日
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get afterLastTakenDate;/// 変更前の最終服用ピル番号（非推奨）
/// 服用記録前のピル番号
 int get beforeLastTakenPillNumber;/// 変更後の最終服用ピル番号（非推奨）
/// 服用記録後のピル番号
 int get afterLastTakenPillNumber;
/// Create a copy of TakenPillValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TakenPillValueCopyWith<TakenPillValue> get copyWith => _$TakenPillValueCopyWithImpl<TakenPillValue>(this as TakenPillValue, _$identity);

  /// Serializes this TakenPillValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TakenPillValue&&(identical(other.isQuickRecord, isQuickRecord) || other.isQuickRecord == isQuickRecord)&&(identical(other.edited, edited) || other.edited == edited)&&(identical(other.beforeLastTakenDate, beforeLastTakenDate) || other.beforeLastTakenDate == beforeLastTakenDate)&&(identical(other.afterLastTakenDate, afterLastTakenDate) || other.afterLastTakenDate == afterLastTakenDate)&&(identical(other.beforeLastTakenPillNumber, beforeLastTakenPillNumber) || other.beforeLastTakenPillNumber == beforeLastTakenPillNumber)&&(identical(other.afterLastTakenPillNumber, afterLastTakenPillNumber) || other.afterLastTakenPillNumber == afterLastTakenPillNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isQuickRecord,edited,beforeLastTakenDate,afterLastTakenDate,beforeLastTakenPillNumber,afterLastTakenPillNumber);

@override
String toString() {
  return 'TakenPillValue(isQuickRecord: $isQuickRecord, edited: $edited, beforeLastTakenDate: $beforeLastTakenDate, afterLastTakenDate: $afterLastTakenDate, beforeLastTakenPillNumber: $beforeLastTakenPillNumber, afterLastTakenPillNumber: $afterLastTakenPillNumber)';
}


}

/// @nodoc
abstract mixin class $TakenPillValueCopyWith<$Res>  {
  factory $TakenPillValueCopyWith(TakenPillValue value, $Res Function(TakenPillValue) _then) = _$TakenPillValueCopyWithImpl;
@useResult
$Res call({
 bool? isQuickRecord, TakenPillEditedValue? edited,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? beforeLastTakenDate,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime afterLastTakenDate, int beforeLastTakenPillNumber, int afterLastTakenPillNumber
});


$TakenPillEditedValueCopyWith<$Res>? get edited;

}
/// @nodoc
class _$TakenPillValueCopyWithImpl<$Res>
    implements $TakenPillValueCopyWith<$Res> {
  _$TakenPillValueCopyWithImpl(this._self, this._then);

  final TakenPillValue _self;
  final $Res Function(TakenPillValue) _then;

/// Create a copy of TakenPillValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isQuickRecord = freezed,Object? edited = freezed,Object? beforeLastTakenDate = freezed,Object? afterLastTakenDate = null,Object? beforeLastTakenPillNumber = null,Object? afterLastTakenPillNumber = null,}) {
  return _then(_self.copyWith(
isQuickRecord: freezed == isQuickRecord ? _self.isQuickRecord : isQuickRecord // ignore: cast_nullable_to_non_nullable
as bool?,edited: freezed == edited ? _self.edited : edited // ignore: cast_nullable_to_non_nullable
as TakenPillEditedValue?,beforeLastTakenDate: freezed == beforeLastTakenDate ? _self.beforeLastTakenDate : beforeLastTakenDate // ignore: cast_nullable_to_non_nullable
as DateTime?,afterLastTakenDate: null == afterLastTakenDate ? _self.afterLastTakenDate : afterLastTakenDate // ignore: cast_nullable_to_non_nullable
as DateTime,beforeLastTakenPillNumber: null == beforeLastTakenPillNumber ? _self.beforeLastTakenPillNumber : beforeLastTakenPillNumber // ignore: cast_nullable_to_non_nullable
as int,afterLastTakenPillNumber: null == afterLastTakenPillNumber ? _self.afterLastTakenPillNumber : afterLastTakenPillNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of TakenPillValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TakenPillEditedValueCopyWith<$Res>? get edited {
    if (_self.edited == null) {
    return null;
  }

  return $TakenPillEditedValueCopyWith<$Res>(_self.edited!, (value) {
    return _then(_self.copyWith(edited: value));
  });
}
}


/// Adds pattern-matching-related methods to [TakenPillValue].
extension TakenPillValuePatterns on TakenPillValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TakenPillValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TakenPillValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TakenPillValue value)  $default,){
final _that = this;
switch (_that) {
case _TakenPillValue():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TakenPillValue value)?  $default,){
final _that = this;
switch (_that) {
case _TakenPillValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? isQuickRecord,  TakenPillEditedValue? edited, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? beforeLastTakenDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime afterLastTakenDate,  int beforeLastTakenPillNumber,  int afterLastTakenPillNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TakenPillValue() when $default != null:
return $default(_that.isQuickRecord,_that.edited,_that.beforeLastTakenDate,_that.afterLastTakenDate,_that.beforeLastTakenPillNumber,_that.afterLastTakenPillNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? isQuickRecord,  TakenPillEditedValue? edited, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? beforeLastTakenDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime afterLastTakenDate,  int beforeLastTakenPillNumber,  int afterLastTakenPillNumber)  $default,) {final _that = this;
switch (_that) {
case _TakenPillValue():
return $default(_that.isQuickRecord,_that.edited,_that.beforeLastTakenDate,_that.afterLastTakenDate,_that.beforeLastTakenPillNumber,_that.afterLastTakenPillNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? isQuickRecord,  TakenPillEditedValue? edited, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? beforeLastTakenDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime afterLastTakenDate,  int beforeLastTakenPillNumber,  int afterLastTakenPillNumber)?  $default,) {final _that = this;
switch (_that) {
case _TakenPillValue() when $default != null:
return $default(_that.isQuickRecord,_that.edited,_that.beforeLastTakenDate,_that.afterLastTakenDate,_that.beforeLastTakenPillNumber,_that.afterLastTakenPillNumber);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TakenPillValue extends TakenPillValue {
  const _TakenPillValue({this.isQuickRecord, this.edited, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) this.beforeLastTakenDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.afterLastTakenDate, required this.beforeLastTakenPillNumber, required this.afterLastTakenPillNumber}): super._();
  factory _TakenPillValue.fromJson(Map<String, dynamic> json) => _$TakenPillValueFromJson(json);

// ============ BEGIN: Added since v1 ============
/// クイック記録かどうかのフラグ（v1追加）
/// nullは途中から追加されたプロパティのため判定不能を表す
// null => 途中から追加したプロパティなので、どちらか不明
@override final  bool? isQuickRecord;
/// 服用記録の編集情報（v1追加）
/// ユーザーが後から服用時刻を編集した場合の詳細情報
@override final  TakenPillEditedValue? edited;
// ============ END: Added since v1 ============
// The below properties are deprecated and added since v1.
// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
/// 変更前の最終服用日（非推奨、nullable）
/// 初回服用の場合はnullとなる
@override@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) final  DateTime? beforeLastTakenDate;
/// 変更後の最終服用日（非推奨）
/// 服用記録によって設定された新しい最終服用日
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime afterLastTakenDate;
/// 変更前の最終服用ピル番号（非推奨）
/// 服用記録前のピル番号
@override final  int beforeLastTakenPillNumber;
/// 変更後の最終服用ピル番号（非推奨）
/// 服用記録後のピル番号
@override final  int afterLastTakenPillNumber;

/// Create a copy of TakenPillValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TakenPillValueCopyWith<_TakenPillValue> get copyWith => __$TakenPillValueCopyWithImpl<_TakenPillValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TakenPillValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TakenPillValue&&(identical(other.isQuickRecord, isQuickRecord) || other.isQuickRecord == isQuickRecord)&&(identical(other.edited, edited) || other.edited == edited)&&(identical(other.beforeLastTakenDate, beforeLastTakenDate) || other.beforeLastTakenDate == beforeLastTakenDate)&&(identical(other.afterLastTakenDate, afterLastTakenDate) || other.afterLastTakenDate == afterLastTakenDate)&&(identical(other.beforeLastTakenPillNumber, beforeLastTakenPillNumber) || other.beforeLastTakenPillNumber == beforeLastTakenPillNumber)&&(identical(other.afterLastTakenPillNumber, afterLastTakenPillNumber) || other.afterLastTakenPillNumber == afterLastTakenPillNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isQuickRecord,edited,beforeLastTakenDate,afterLastTakenDate,beforeLastTakenPillNumber,afterLastTakenPillNumber);

@override
String toString() {
  return 'TakenPillValue(isQuickRecord: $isQuickRecord, edited: $edited, beforeLastTakenDate: $beforeLastTakenDate, afterLastTakenDate: $afterLastTakenDate, beforeLastTakenPillNumber: $beforeLastTakenPillNumber, afterLastTakenPillNumber: $afterLastTakenPillNumber)';
}


}

/// @nodoc
abstract mixin class _$TakenPillValueCopyWith<$Res> implements $TakenPillValueCopyWith<$Res> {
  factory _$TakenPillValueCopyWith(_TakenPillValue value, $Res Function(_TakenPillValue) _then) = __$TakenPillValueCopyWithImpl;
@override @useResult
$Res call({
 bool? isQuickRecord, TakenPillEditedValue? edited,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? beforeLastTakenDate,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime afterLastTakenDate, int beforeLastTakenPillNumber, int afterLastTakenPillNumber
});


@override $TakenPillEditedValueCopyWith<$Res>? get edited;

}
/// @nodoc
class __$TakenPillValueCopyWithImpl<$Res>
    implements _$TakenPillValueCopyWith<$Res> {
  __$TakenPillValueCopyWithImpl(this._self, this._then);

  final _TakenPillValue _self;
  final $Res Function(_TakenPillValue) _then;

/// Create a copy of TakenPillValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isQuickRecord = freezed,Object? edited = freezed,Object? beforeLastTakenDate = freezed,Object? afterLastTakenDate = null,Object? beforeLastTakenPillNumber = null,Object? afterLastTakenPillNumber = null,}) {
  return _then(_TakenPillValue(
isQuickRecord: freezed == isQuickRecord ? _self.isQuickRecord : isQuickRecord // ignore: cast_nullable_to_non_nullable
as bool?,edited: freezed == edited ? _self.edited : edited // ignore: cast_nullable_to_non_nullable
as TakenPillEditedValue?,beforeLastTakenDate: freezed == beforeLastTakenDate ? _self.beforeLastTakenDate : beforeLastTakenDate // ignore: cast_nullable_to_non_nullable
as DateTime?,afterLastTakenDate: null == afterLastTakenDate ? _self.afterLastTakenDate : afterLastTakenDate // ignore: cast_nullable_to_non_nullable
as DateTime,beforeLastTakenPillNumber: null == beforeLastTakenPillNumber ? _self.beforeLastTakenPillNumber : beforeLastTakenPillNumber // ignore: cast_nullable_to_non_nullable
as int,afterLastTakenPillNumber: null == afterLastTakenPillNumber ? _self.afterLastTakenPillNumber : afterLastTakenPillNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of TakenPillValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TakenPillEditedValueCopyWith<$Res>? get edited {
    if (_self.edited == null) {
    return null;
  }

  return $TakenPillEditedValueCopyWith<$Res>(_self.edited!, (value) {
    return _then(_self.copyWith(edited: value));
  });
}
}


/// @nodoc
mixin _$TakenPillEditedValue {

// ============ BEGIN: Added since v1 ============
/// 実際の服用時刻（v1追加）
/// ユーザーが編集した後の正確な服用時刻
// 実際の服用時刻。ユーザーが編集した後の服用時刻
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get actualTakenDate;/// 元の履歴記録時刻（v1追加）
/// 通常はユーザーが編集する前の服用時刻として記録される
// 元々の履歴がDBに書き込まれた時刻。通常はユーザーが編集する前の服用時刻
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get historyRecordedDate;/// 編集操作の作成日時（v1追加）
/// この編集レコードがデータベースに作成された日時
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get createdDate;
/// Create a copy of TakenPillEditedValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TakenPillEditedValueCopyWith<TakenPillEditedValue> get copyWith => _$TakenPillEditedValueCopyWithImpl<TakenPillEditedValue>(this as TakenPillEditedValue, _$identity);

  /// Serializes this TakenPillEditedValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TakenPillEditedValue&&(identical(other.actualTakenDate, actualTakenDate) || other.actualTakenDate == actualTakenDate)&&(identical(other.historyRecordedDate, historyRecordedDate) || other.historyRecordedDate == historyRecordedDate)&&(identical(other.createdDate, createdDate) || other.createdDate == createdDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,actualTakenDate,historyRecordedDate,createdDate);

@override
String toString() {
  return 'TakenPillEditedValue(actualTakenDate: $actualTakenDate, historyRecordedDate: $historyRecordedDate, createdDate: $createdDate)';
}


}

/// @nodoc
abstract mixin class $TakenPillEditedValueCopyWith<$Res>  {
  factory $TakenPillEditedValueCopyWith(TakenPillEditedValue value, $Res Function(TakenPillEditedValue) _then) = _$TakenPillEditedValueCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime actualTakenDate,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime historyRecordedDate,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime createdDate
});




}
/// @nodoc
class _$TakenPillEditedValueCopyWithImpl<$Res>
    implements $TakenPillEditedValueCopyWith<$Res> {
  _$TakenPillEditedValueCopyWithImpl(this._self, this._then);

  final TakenPillEditedValue _self;
  final $Res Function(TakenPillEditedValue) _then;

/// Create a copy of TakenPillEditedValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? actualTakenDate = null,Object? historyRecordedDate = null,Object? createdDate = null,}) {
  return _then(_self.copyWith(
actualTakenDate: null == actualTakenDate ? _self.actualTakenDate : actualTakenDate // ignore: cast_nullable_to_non_nullable
as DateTime,historyRecordedDate: null == historyRecordedDate ? _self.historyRecordedDate : historyRecordedDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdDate: null == createdDate ? _self.createdDate : createdDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TakenPillEditedValue].
extension TakenPillEditedValuePatterns on TakenPillEditedValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TakenPillEditedValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TakenPillEditedValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TakenPillEditedValue value)  $default,){
final _that = this;
switch (_that) {
case _TakenPillEditedValue():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TakenPillEditedValue value)?  $default,){
final _that = this;
switch (_that) {
case _TakenPillEditedValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime actualTakenDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime historyRecordedDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime createdDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TakenPillEditedValue() when $default != null:
return $default(_that.actualTakenDate,_that.historyRecordedDate,_that.createdDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime actualTakenDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime historyRecordedDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime createdDate)  $default,) {final _that = this;
switch (_that) {
case _TakenPillEditedValue():
return $default(_that.actualTakenDate,_that.historyRecordedDate,_that.createdDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime actualTakenDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime historyRecordedDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime createdDate)?  $default,) {final _that = this;
switch (_that) {
case _TakenPillEditedValue() when $default != null:
return $default(_that.actualTakenDate,_that.historyRecordedDate,_that.createdDate);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TakenPillEditedValue extends TakenPillEditedValue {
  const _TakenPillEditedValue({@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.actualTakenDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.historyRecordedDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.createdDate}): super._();
  factory _TakenPillEditedValue.fromJson(Map<String, dynamic> json) => _$TakenPillEditedValueFromJson(json);

// ============ BEGIN: Added since v1 ============
/// 実際の服用時刻（v1追加）
/// ユーザーが編集した後の正確な服用時刻
// 実際の服用時刻。ユーザーが編集した後の服用時刻
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime actualTakenDate;
/// 元の履歴記録時刻（v1追加）
/// 通常はユーザーが編集する前の服用時刻として記録される
// 元々の履歴がDBに書き込まれた時刻。通常はユーザーが編集する前の服用時刻
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime historyRecordedDate;
/// 編集操作の作成日時（v1追加）
/// この編集レコードがデータベースに作成された日時
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime createdDate;

/// Create a copy of TakenPillEditedValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TakenPillEditedValueCopyWith<_TakenPillEditedValue> get copyWith => __$TakenPillEditedValueCopyWithImpl<_TakenPillEditedValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TakenPillEditedValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TakenPillEditedValue&&(identical(other.actualTakenDate, actualTakenDate) || other.actualTakenDate == actualTakenDate)&&(identical(other.historyRecordedDate, historyRecordedDate) || other.historyRecordedDate == historyRecordedDate)&&(identical(other.createdDate, createdDate) || other.createdDate == createdDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,actualTakenDate,historyRecordedDate,createdDate);

@override
String toString() {
  return 'TakenPillEditedValue(actualTakenDate: $actualTakenDate, historyRecordedDate: $historyRecordedDate, createdDate: $createdDate)';
}


}

/// @nodoc
abstract mixin class _$TakenPillEditedValueCopyWith<$Res> implements $TakenPillEditedValueCopyWith<$Res> {
  factory _$TakenPillEditedValueCopyWith(_TakenPillEditedValue value, $Res Function(_TakenPillEditedValue) _then) = __$TakenPillEditedValueCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime actualTakenDate,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime historyRecordedDate,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime createdDate
});




}
/// @nodoc
class __$TakenPillEditedValueCopyWithImpl<$Res>
    implements _$TakenPillEditedValueCopyWith<$Res> {
  __$TakenPillEditedValueCopyWithImpl(this._self, this._then);

  final _TakenPillEditedValue _self;
  final $Res Function(_TakenPillEditedValue) _then;

/// Create a copy of TakenPillEditedValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? actualTakenDate = null,Object? historyRecordedDate = null,Object? createdDate = null,}) {
  return _then(_TakenPillEditedValue(
actualTakenDate: null == actualTakenDate ? _self.actualTakenDate : actualTakenDate // ignore: cast_nullable_to_non_nullable
as DateTime,historyRecordedDate: null == historyRecordedDate ? _self.historyRecordedDate : historyRecordedDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdDate: null == createdDate ? _self.createdDate : createdDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$RevertTakenPillValue {

// The below properties are deprecated and added since v1.
// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
/// 取り消し前の最終服用日（非推奨、nullable）
/// 取り消し操作前の最終服用日
@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? get beforeLastTakenDate;/// 取り消し後の最終服用日（非推奨、nullable）
/// 取り消し操作後の最終服用日、服用履歴がなくなった場合はnull
@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? get afterLastTakenDate;/// 取り消し前の最終服用ピル番号（非推奨）
/// 取り消し操作前のピル番号
 int get beforeLastTakenPillNumber;/// 取り消し後の最終服用ピル番号（非推奨）
/// 取り消し操作後のピル番号
 int get afterLastTakenPillNumber;
/// Create a copy of RevertTakenPillValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RevertTakenPillValueCopyWith<RevertTakenPillValue> get copyWith => _$RevertTakenPillValueCopyWithImpl<RevertTakenPillValue>(this as RevertTakenPillValue, _$identity);

  /// Serializes this RevertTakenPillValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RevertTakenPillValue&&(identical(other.beforeLastTakenDate, beforeLastTakenDate) || other.beforeLastTakenDate == beforeLastTakenDate)&&(identical(other.afterLastTakenDate, afterLastTakenDate) || other.afterLastTakenDate == afterLastTakenDate)&&(identical(other.beforeLastTakenPillNumber, beforeLastTakenPillNumber) || other.beforeLastTakenPillNumber == beforeLastTakenPillNumber)&&(identical(other.afterLastTakenPillNumber, afterLastTakenPillNumber) || other.afterLastTakenPillNumber == afterLastTakenPillNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,beforeLastTakenDate,afterLastTakenDate,beforeLastTakenPillNumber,afterLastTakenPillNumber);

@override
String toString() {
  return 'RevertTakenPillValue(beforeLastTakenDate: $beforeLastTakenDate, afterLastTakenDate: $afterLastTakenDate, beforeLastTakenPillNumber: $beforeLastTakenPillNumber, afterLastTakenPillNumber: $afterLastTakenPillNumber)';
}


}

/// @nodoc
abstract mixin class $RevertTakenPillValueCopyWith<$Res>  {
  factory $RevertTakenPillValueCopyWith(RevertTakenPillValue value, $Res Function(RevertTakenPillValue) _then) = _$RevertTakenPillValueCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? beforeLastTakenDate,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? afterLastTakenDate, int beforeLastTakenPillNumber, int afterLastTakenPillNumber
});




}
/// @nodoc
class _$RevertTakenPillValueCopyWithImpl<$Res>
    implements $RevertTakenPillValueCopyWith<$Res> {
  _$RevertTakenPillValueCopyWithImpl(this._self, this._then);

  final RevertTakenPillValue _self;
  final $Res Function(RevertTakenPillValue) _then;

/// Create a copy of RevertTakenPillValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? beforeLastTakenDate = freezed,Object? afterLastTakenDate = freezed,Object? beforeLastTakenPillNumber = null,Object? afterLastTakenPillNumber = null,}) {
  return _then(_self.copyWith(
beforeLastTakenDate: freezed == beforeLastTakenDate ? _self.beforeLastTakenDate : beforeLastTakenDate // ignore: cast_nullable_to_non_nullable
as DateTime?,afterLastTakenDate: freezed == afterLastTakenDate ? _self.afterLastTakenDate : afterLastTakenDate // ignore: cast_nullable_to_non_nullable
as DateTime?,beforeLastTakenPillNumber: null == beforeLastTakenPillNumber ? _self.beforeLastTakenPillNumber : beforeLastTakenPillNumber // ignore: cast_nullable_to_non_nullable
as int,afterLastTakenPillNumber: null == afterLastTakenPillNumber ? _self.afterLastTakenPillNumber : afterLastTakenPillNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RevertTakenPillValue].
extension RevertTakenPillValuePatterns on RevertTakenPillValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RevertTakenPillValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RevertTakenPillValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RevertTakenPillValue value)  $default,){
final _that = this;
switch (_that) {
case _RevertTakenPillValue():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RevertTakenPillValue value)?  $default,){
final _that = this;
switch (_that) {
case _RevertTakenPillValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? beforeLastTakenDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? afterLastTakenDate,  int beforeLastTakenPillNumber,  int afterLastTakenPillNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RevertTakenPillValue() when $default != null:
return $default(_that.beforeLastTakenDate,_that.afterLastTakenDate,_that.beforeLastTakenPillNumber,_that.afterLastTakenPillNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? beforeLastTakenDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? afterLastTakenDate,  int beforeLastTakenPillNumber,  int afterLastTakenPillNumber)  $default,) {final _that = this;
switch (_that) {
case _RevertTakenPillValue():
return $default(_that.beforeLastTakenDate,_that.afterLastTakenDate,_that.beforeLastTakenPillNumber,_that.afterLastTakenPillNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? beforeLastTakenDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? afterLastTakenDate,  int beforeLastTakenPillNumber,  int afterLastTakenPillNumber)?  $default,) {final _that = this;
switch (_that) {
case _RevertTakenPillValue() when $default != null:
return $default(_that.beforeLastTakenDate,_that.afterLastTakenDate,_that.beforeLastTakenPillNumber,_that.afterLastTakenPillNumber);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _RevertTakenPillValue extends RevertTakenPillValue {
  const _RevertTakenPillValue({@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) this.beforeLastTakenDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) required this.afterLastTakenDate, required this.beforeLastTakenPillNumber, required this.afterLastTakenPillNumber}): super._();
  factory _RevertTakenPillValue.fromJson(Map<String, dynamic> json) => _$RevertTakenPillValueFromJson(json);

// The below properties are deprecated and added since v1.
// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
/// 取り消し前の最終服用日（非推奨、nullable）
/// 取り消し操作前の最終服用日
@override@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) final  DateTime? beforeLastTakenDate;
/// 取り消し後の最終服用日（非推奨、nullable）
/// 取り消し操作後の最終服用日、服用履歴がなくなった場合はnull
@override@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) final  DateTime? afterLastTakenDate;
/// 取り消し前の最終服用ピル番号（非推奨）
/// 取り消し操作前のピル番号
@override final  int beforeLastTakenPillNumber;
/// 取り消し後の最終服用ピル番号（非推奨）
/// 取り消し操作後のピル番号
@override final  int afterLastTakenPillNumber;

/// Create a copy of RevertTakenPillValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RevertTakenPillValueCopyWith<_RevertTakenPillValue> get copyWith => __$RevertTakenPillValueCopyWithImpl<_RevertTakenPillValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RevertTakenPillValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RevertTakenPillValue&&(identical(other.beforeLastTakenDate, beforeLastTakenDate) || other.beforeLastTakenDate == beforeLastTakenDate)&&(identical(other.afterLastTakenDate, afterLastTakenDate) || other.afterLastTakenDate == afterLastTakenDate)&&(identical(other.beforeLastTakenPillNumber, beforeLastTakenPillNumber) || other.beforeLastTakenPillNumber == beforeLastTakenPillNumber)&&(identical(other.afterLastTakenPillNumber, afterLastTakenPillNumber) || other.afterLastTakenPillNumber == afterLastTakenPillNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,beforeLastTakenDate,afterLastTakenDate,beforeLastTakenPillNumber,afterLastTakenPillNumber);

@override
String toString() {
  return 'RevertTakenPillValue(beforeLastTakenDate: $beforeLastTakenDate, afterLastTakenDate: $afterLastTakenDate, beforeLastTakenPillNumber: $beforeLastTakenPillNumber, afterLastTakenPillNumber: $afterLastTakenPillNumber)';
}


}

/// @nodoc
abstract mixin class _$RevertTakenPillValueCopyWith<$Res> implements $RevertTakenPillValueCopyWith<$Res> {
  factory _$RevertTakenPillValueCopyWith(_RevertTakenPillValue value, $Res Function(_RevertTakenPillValue) _then) = __$RevertTakenPillValueCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? beforeLastTakenDate,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? afterLastTakenDate, int beforeLastTakenPillNumber, int afterLastTakenPillNumber
});




}
/// @nodoc
class __$RevertTakenPillValueCopyWithImpl<$Res>
    implements _$RevertTakenPillValueCopyWith<$Res> {
  __$RevertTakenPillValueCopyWithImpl(this._self, this._then);

  final _RevertTakenPillValue _self;
  final $Res Function(_RevertTakenPillValue) _then;

/// Create a copy of RevertTakenPillValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? beforeLastTakenDate = freezed,Object? afterLastTakenDate = freezed,Object? beforeLastTakenPillNumber = null,Object? afterLastTakenPillNumber = null,}) {
  return _then(_RevertTakenPillValue(
beforeLastTakenDate: freezed == beforeLastTakenDate ? _self.beforeLastTakenDate : beforeLastTakenDate // ignore: cast_nullable_to_non_nullable
as DateTime?,afterLastTakenDate: freezed == afterLastTakenDate ? _self.afterLastTakenDate : afterLastTakenDate // ignore: cast_nullable_to_non_nullable
as DateTime?,beforeLastTakenPillNumber: null == beforeLastTakenPillNumber ? _self.beforeLastTakenPillNumber : beforeLastTakenPillNumber // ignore: cast_nullable_to_non_nullable
as int,afterLastTakenPillNumber: null == afterLastTakenPillNumber ? _self.afterLastTakenPillNumber : afterLastTakenPillNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ChangedPillNumberValue {

// The below properties are deprecated and added since v1.
// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
/// 変更前の開始日（非推奨）
/// ピル番号変更前のピルシート開始日
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get beforeBeginingDate;/// 変更後の開始日（非推奨）
/// ピル番号変更後のピルシート開始日
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get afterBeginingDate;/// 変更前の今日のピル番号（非推奨）
/// 変更操作前の今日に対応するピル番号
 int get beforeTodayPillNumber;/// 変更後の今日のピル番号（非推奨）
/// 変更操作後の今日に対応するピル番号
 int get afterTodayPillNumber;/// 変更前のグループインデックス（非推奨）
/// ピルシートグループ内での順序番号（デフォルト：1）
 int get beforeGroupIndex;/// 変更後のグループインデックス（非推奨）
/// ピルシートグループ内での順序番号（デフォルト：1）
 int get afterGroupIndex;
/// Create a copy of ChangedPillNumberValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangedPillNumberValueCopyWith<ChangedPillNumberValue> get copyWith => _$ChangedPillNumberValueCopyWithImpl<ChangedPillNumberValue>(this as ChangedPillNumberValue, _$identity);

  /// Serializes this ChangedPillNumberValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangedPillNumberValue&&(identical(other.beforeBeginingDate, beforeBeginingDate) || other.beforeBeginingDate == beforeBeginingDate)&&(identical(other.afterBeginingDate, afterBeginingDate) || other.afterBeginingDate == afterBeginingDate)&&(identical(other.beforeTodayPillNumber, beforeTodayPillNumber) || other.beforeTodayPillNumber == beforeTodayPillNumber)&&(identical(other.afterTodayPillNumber, afterTodayPillNumber) || other.afterTodayPillNumber == afterTodayPillNumber)&&(identical(other.beforeGroupIndex, beforeGroupIndex) || other.beforeGroupIndex == beforeGroupIndex)&&(identical(other.afterGroupIndex, afterGroupIndex) || other.afterGroupIndex == afterGroupIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,beforeBeginingDate,afterBeginingDate,beforeTodayPillNumber,afterTodayPillNumber,beforeGroupIndex,afterGroupIndex);

@override
String toString() {
  return 'ChangedPillNumberValue(beforeBeginingDate: $beforeBeginingDate, afterBeginingDate: $afterBeginingDate, beforeTodayPillNumber: $beforeTodayPillNumber, afterTodayPillNumber: $afterTodayPillNumber, beforeGroupIndex: $beforeGroupIndex, afterGroupIndex: $afterGroupIndex)';
}


}

/// @nodoc
abstract mixin class $ChangedPillNumberValueCopyWith<$Res>  {
  factory $ChangedPillNumberValueCopyWith(ChangedPillNumberValue value, $Res Function(ChangedPillNumberValue) _then) = _$ChangedPillNumberValueCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime beforeBeginingDate,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime afterBeginingDate, int beforeTodayPillNumber, int afterTodayPillNumber, int beforeGroupIndex, int afterGroupIndex
});




}
/// @nodoc
class _$ChangedPillNumberValueCopyWithImpl<$Res>
    implements $ChangedPillNumberValueCopyWith<$Res> {
  _$ChangedPillNumberValueCopyWithImpl(this._self, this._then);

  final ChangedPillNumberValue _self;
  final $Res Function(ChangedPillNumberValue) _then;

/// Create a copy of ChangedPillNumberValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? beforeBeginingDate = null,Object? afterBeginingDate = null,Object? beforeTodayPillNumber = null,Object? afterTodayPillNumber = null,Object? beforeGroupIndex = null,Object? afterGroupIndex = null,}) {
  return _then(_self.copyWith(
beforeBeginingDate: null == beforeBeginingDate ? _self.beforeBeginingDate : beforeBeginingDate // ignore: cast_nullable_to_non_nullable
as DateTime,afterBeginingDate: null == afterBeginingDate ? _self.afterBeginingDate : afterBeginingDate // ignore: cast_nullable_to_non_nullable
as DateTime,beforeTodayPillNumber: null == beforeTodayPillNumber ? _self.beforeTodayPillNumber : beforeTodayPillNumber // ignore: cast_nullable_to_non_nullable
as int,afterTodayPillNumber: null == afterTodayPillNumber ? _self.afterTodayPillNumber : afterTodayPillNumber // ignore: cast_nullable_to_non_nullable
as int,beforeGroupIndex: null == beforeGroupIndex ? _self.beforeGroupIndex : beforeGroupIndex // ignore: cast_nullable_to_non_nullable
as int,afterGroupIndex: null == afterGroupIndex ? _self.afterGroupIndex : afterGroupIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ChangedPillNumberValue].
extension ChangedPillNumberValuePatterns on ChangedPillNumberValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChangedPillNumberValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangedPillNumberValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChangedPillNumberValue value)  $default,){
final _that = this;
switch (_that) {
case _ChangedPillNumberValue():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChangedPillNumberValue value)?  $default,){
final _that = this;
switch (_that) {
case _ChangedPillNumberValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime beforeBeginingDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime afterBeginingDate,  int beforeTodayPillNumber,  int afterTodayPillNumber,  int beforeGroupIndex,  int afterGroupIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangedPillNumberValue() when $default != null:
return $default(_that.beforeBeginingDate,_that.afterBeginingDate,_that.beforeTodayPillNumber,_that.afterTodayPillNumber,_that.beforeGroupIndex,_that.afterGroupIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime beforeBeginingDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime afterBeginingDate,  int beforeTodayPillNumber,  int afterTodayPillNumber,  int beforeGroupIndex,  int afterGroupIndex)  $default,) {final _that = this;
switch (_that) {
case _ChangedPillNumberValue():
return $default(_that.beforeBeginingDate,_that.afterBeginingDate,_that.beforeTodayPillNumber,_that.afterTodayPillNumber,_that.beforeGroupIndex,_that.afterGroupIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime beforeBeginingDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime afterBeginingDate,  int beforeTodayPillNumber,  int afterTodayPillNumber,  int beforeGroupIndex,  int afterGroupIndex)?  $default,) {final _that = this;
switch (_that) {
case _ChangedPillNumberValue() when $default != null:
return $default(_that.beforeBeginingDate,_that.afterBeginingDate,_that.beforeTodayPillNumber,_that.afterTodayPillNumber,_that.beforeGroupIndex,_that.afterGroupIndex);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ChangedPillNumberValue extends ChangedPillNumberValue {
  const _ChangedPillNumberValue({@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.beforeBeginingDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.afterBeginingDate, required this.beforeTodayPillNumber, required this.afterTodayPillNumber, this.beforeGroupIndex = 1, this.afterGroupIndex = 1}): super._();
  factory _ChangedPillNumberValue.fromJson(Map<String, dynamic> json) => _$ChangedPillNumberValueFromJson(json);

// The below properties are deprecated and added since v1.
// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
/// 変更前の開始日（非推奨）
/// ピル番号変更前のピルシート開始日
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime beforeBeginingDate;
/// 変更後の開始日（非推奨）
/// ピル番号変更後のピルシート開始日
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime afterBeginingDate;
/// 変更前の今日のピル番号（非推奨）
/// 変更操作前の今日に対応するピル番号
@override final  int beforeTodayPillNumber;
/// 変更後の今日のピル番号（非推奨）
/// 変更操作後の今日に対応するピル番号
@override final  int afterTodayPillNumber;
/// 変更前のグループインデックス（非推奨）
/// ピルシートグループ内での順序番号（デフォルト：1）
@override@JsonKey() final  int beforeGroupIndex;
/// 変更後のグループインデックス（非推奨）
/// ピルシートグループ内での順序番号（デフォルト：1）
@override@JsonKey() final  int afterGroupIndex;

/// Create a copy of ChangedPillNumberValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangedPillNumberValueCopyWith<_ChangedPillNumberValue> get copyWith => __$ChangedPillNumberValueCopyWithImpl<_ChangedPillNumberValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChangedPillNumberValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangedPillNumberValue&&(identical(other.beforeBeginingDate, beforeBeginingDate) || other.beforeBeginingDate == beforeBeginingDate)&&(identical(other.afterBeginingDate, afterBeginingDate) || other.afterBeginingDate == afterBeginingDate)&&(identical(other.beforeTodayPillNumber, beforeTodayPillNumber) || other.beforeTodayPillNumber == beforeTodayPillNumber)&&(identical(other.afterTodayPillNumber, afterTodayPillNumber) || other.afterTodayPillNumber == afterTodayPillNumber)&&(identical(other.beforeGroupIndex, beforeGroupIndex) || other.beforeGroupIndex == beforeGroupIndex)&&(identical(other.afterGroupIndex, afterGroupIndex) || other.afterGroupIndex == afterGroupIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,beforeBeginingDate,afterBeginingDate,beforeTodayPillNumber,afterTodayPillNumber,beforeGroupIndex,afterGroupIndex);

@override
String toString() {
  return 'ChangedPillNumberValue(beforeBeginingDate: $beforeBeginingDate, afterBeginingDate: $afterBeginingDate, beforeTodayPillNumber: $beforeTodayPillNumber, afterTodayPillNumber: $afterTodayPillNumber, beforeGroupIndex: $beforeGroupIndex, afterGroupIndex: $afterGroupIndex)';
}


}

/// @nodoc
abstract mixin class _$ChangedPillNumberValueCopyWith<$Res> implements $ChangedPillNumberValueCopyWith<$Res> {
  factory _$ChangedPillNumberValueCopyWith(_ChangedPillNumberValue value, $Res Function(_ChangedPillNumberValue) _then) = __$ChangedPillNumberValueCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime beforeBeginingDate,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime afterBeginingDate, int beforeTodayPillNumber, int afterTodayPillNumber, int beforeGroupIndex, int afterGroupIndex
});




}
/// @nodoc
class __$ChangedPillNumberValueCopyWithImpl<$Res>
    implements _$ChangedPillNumberValueCopyWith<$Res> {
  __$ChangedPillNumberValueCopyWithImpl(this._self, this._then);

  final _ChangedPillNumberValue _self;
  final $Res Function(_ChangedPillNumberValue) _then;

/// Create a copy of ChangedPillNumberValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? beforeBeginingDate = null,Object? afterBeginingDate = null,Object? beforeTodayPillNumber = null,Object? afterTodayPillNumber = null,Object? beforeGroupIndex = null,Object? afterGroupIndex = null,}) {
  return _then(_ChangedPillNumberValue(
beforeBeginingDate: null == beforeBeginingDate ? _self.beforeBeginingDate : beforeBeginingDate // ignore: cast_nullable_to_non_nullable
as DateTime,afterBeginingDate: null == afterBeginingDate ? _self.afterBeginingDate : afterBeginingDate // ignore: cast_nullable_to_non_nullable
as DateTime,beforeTodayPillNumber: null == beforeTodayPillNumber ? _self.beforeTodayPillNumber : beforeTodayPillNumber // ignore: cast_nullable_to_non_nullable
as int,afterTodayPillNumber: null == afterTodayPillNumber ? _self.afterTodayPillNumber : afterTodayPillNumber // ignore: cast_nullable_to_non_nullable
as int,beforeGroupIndex: null == beforeGroupIndex ? _self.beforeGroupIndex : beforeGroupIndex // ignore: cast_nullable_to_non_nullable
as int,afterGroupIndex: null == afterGroupIndex ? _self.afterGroupIndex : afterGroupIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$EndedPillSheetValue {

/// 終了記録日（必須）
/// サーバーで書き込まれるピルシート終了の公式記録日時
// 終了した日付。サーバーで書き込まれる
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get endRecordDate;/// 終了時点での最終服用日（必須）
/// シート終了時の最後に服用したピルの日付
// 終了した時点での最終服用日
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get lastTakenDate;
/// Create a copy of EndedPillSheetValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EndedPillSheetValueCopyWith<EndedPillSheetValue> get copyWith => _$EndedPillSheetValueCopyWithImpl<EndedPillSheetValue>(this as EndedPillSheetValue, _$identity);

  /// Serializes this EndedPillSheetValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EndedPillSheetValue&&(identical(other.endRecordDate, endRecordDate) || other.endRecordDate == endRecordDate)&&(identical(other.lastTakenDate, lastTakenDate) || other.lastTakenDate == lastTakenDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,endRecordDate,lastTakenDate);

@override
String toString() {
  return 'EndedPillSheetValue(endRecordDate: $endRecordDate, lastTakenDate: $lastTakenDate)';
}


}

/// @nodoc
abstract mixin class $EndedPillSheetValueCopyWith<$Res>  {
  factory $EndedPillSheetValueCopyWith(EndedPillSheetValue value, $Res Function(EndedPillSheetValue) _then) = _$EndedPillSheetValueCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime endRecordDate,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime lastTakenDate
});




}
/// @nodoc
class _$EndedPillSheetValueCopyWithImpl<$Res>
    implements $EndedPillSheetValueCopyWith<$Res> {
  _$EndedPillSheetValueCopyWithImpl(this._self, this._then);

  final EndedPillSheetValue _self;
  final $Res Function(EndedPillSheetValue) _then;

/// Create a copy of EndedPillSheetValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? endRecordDate = null,Object? lastTakenDate = null,}) {
  return _then(_self.copyWith(
endRecordDate: null == endRecordDate ? _self.endRecordDate : endRecordDate // ignore: cast_nullable_to_non_nullable
as DateTime,lastTakenDate: null == lastTakenDate ? _self.lastTakenDate : lastTakenDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [EndedPillSheetValue].
extension EndedPillSheetValuePatterns on EndedPillSheetValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EndedPillSheetValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EndedPillSheetValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EndedPillSheetValue value)  $default,){
final _that = this;
switch (_that) {
case _EndedPillSheetValue():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EndedPillSheetValue value)?  $default,){
final _that = this;
switch (_that) {
case _EndedPillSheetValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime endRecordDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime lastTakenDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EndedPillSheetValue() when $default != null:
return $default(_that.endRecordDate,_that.lastTakenDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime endRecordDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime lastTakenDate)  $default,) {final _that = this;
switch (_that) {
case _EndedPillSheetValue():
return $default(_that.endRecordDate,_that.lastTakenDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime endRecordDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime lastTakenDate)?  $default,) {final _that = this;
switch (_that) {
case _EndedPillSheetValue() when $default != null:
return $default(_that.endRecordDate,_that.lastTakenDate);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _EndedPillSheetValue extends EndedPillSheetValue {
  const _EndedPillSheetValue({@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.endRecordDate, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.lastTakenDate}): super._();
  factory _EndedPillSheetValue.fromJson(Map<String, dynamic> json) => _$EndedPillSheetValueFromJson(json);

/// 終了記録日（必須）
/// サーバーで書き込まれるピルシート終了の公式記録日時
// 終了した日付。サーバーで書き込まれる
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime endRecordDate;
/// 終了時点での最終服用日（必須）
/// シート終了時の最後に服用したピルの日付
// 終了した時点での最終服用日
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime lastTakenDate;

/// Create a copy of EndedPillSheetValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EndedPillSheetValueCopyWith<_EndedPillSheetValue> get copyWith => __$EndedPillSheetValueCopyWithImpl<_EndedPillSheetValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EndedPillSheetValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EndedPillSheetValue&&(identical(other.endRecordDate, endRecordDate) || other.endRecordDate == endRecordDate)&&(identical(other.lastTakenDate, lastTakenDate) || other.lastTakenDate == lastTakenDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,endRecordDate,lastTakenDate);

@override
String toString() {
  return 'EndedPillSheetValue(endRecordDate: $endRecordDate, lastTakenDate: $lastTakenDate)';
}


}

/// @nodoc
abstract mixin class _$EndedPillSheetValueCopyWith<$Res> implements $EndedPillSheetValueCopyWith<$Res> {
  factory _$EndedPillSheetValueCopyWith(_EndedPillSheetValue value, $Res Function(_EndedPillSheetValue) _then) = __$EndedPillSheetValueCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime endRecordDate,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime lastTakenDate
});




}
/// @nodoc
class __$EndedPillSheetValueCopyWithImpl<$Res>
    implements _$EndedPillSheetValueCopyWith<$Res> {
  __$EndedPillSheetValueCopyWithImpl(this._self, this._then);

  final _EndedPillSheetValue _self;
  final $Res Function(_EndedPillSheetValue) _then;

/// Create a copy of EndedPillSheetValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? endRecordDate = null,Object? lastTakenDate = null,}) {
  return _then(_EndedPillSheetValue(
endRecordDate: null == endRecordDate ? _self.endRecordDate : endRecordDate // ignore: cast_nullable_to_non_nullable
as DateTime,lastTakenDate: null == lastTakenDate ? _self.lastTakenDate : lastTakenDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$BeganRestDurationValue {

// ============ BEGIN: Added since v1 ============
/// 開始された休薬期間の詳細情報（v1追加）
/// どの服用お休み期間かを特定するため完全な休薬期間データを記録
// どの服用お休み期間か特定するのが大変なので記録したものを使用する
 RestDuration get restDuration;
/// Create a copy of BeganRestDurationValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BeganRestDurationValueCopyWith<BeganRestDurationValue> get copyWith => _$BeganRestDurationValueCopyWithImpl<BeganRestDurationValue>(this as BeganRestDurationValue, _$identity);

  /// Serializes this BeganRestDurationValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BeganRestDurationValue&&(identical(other.restDuration, restDuration) || other.restDuration == restDuration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,restDuration);

@override
String toString() {
  return 'BeganRestDurationValue(restDuration: $restDuration)';
}


}

/// @nodoc
abstract mixin class $BeganRestDurationValueCopyWith<$Res>  {
  factory $BeganRestDurationValueCopyWith(BeganRestDurationValue value, $Res Function(BeganRestDurationValue) _then) = _$BeganRestDurationValueCopyWithImpl;
@useResult
$Res call({
 RestDuration restDuration
});


$RestDurationCopyWith<$Res> get restDuration;

}
/// @nodoc
class _$BeganRestDurationValueCopyWithImpl<$Res>
    implements $BeganRestDurationValueCopyWith<$Res> {
  _$BeganRestDurationValueCopyWithImpl(this._self, this._then);

  final BeganRestDurationValue _self;
  final $Res Function(BeganRestDurationValue) _then;

/// Create a copy of BeganRestDurationValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? restDuration = null,}) {
  return _then(_self.copyWith(
restDuration: null == restDuration ? _self.restDuration : restDuration // ignore: cast_nullable_to_non_nullable
as RestDuration,
  ));
}
/// Create a copy of BeganRestDurationValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RestDurationCopyWith<$Res> get restDuration {
  
  return $RestDurationCopyWith<$Res>(_self.restDuration, (value) {
    return _then(_self.copyWith(restDuration: value));
  });
}
}


/// Adds pattern-matching-related methods to [BeganRestDurationValue].
extension BeganRestDurationValuePatterns on BeganRestDurationValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BeganRestDurationValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BeganRestDurationValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BeganRestDurationValue value)  $default,){
final _that = this;
switch (_that) {
case _BeganRestDurationValue():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BeganRestDurationValue value)?  $default,){
final _that = this;
switch (_that) {
case _BeganRestDurationValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RestDuration restDuration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BeganRestDurationValue() when $default != null:
return $default(_that.restDuration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RestDuration restDuration)  $default,) {final _that = this;
switch (_that) {
case _BeganRestDurationValue():
return $default(_that.restDuration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RestDuration restDuration)?  $default,) {final _that = this;
switch (_that) {
case _BeganRestDurationValue() when $default != null:
return $default(_that.restDuration);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BeganRestDurationValue extends BeganRestDurationValue {
  const _BeganRestDurationValue({required this.restDuration}): super._();
  factory _BeganRestDurationValue.fromJson(Map<String, dynamic> json) => _$BeganRestDurationValueFromJson(json);

// ============ BEGIN: Added since v1 ============
/// 開始された休薬期間の詳細情報（v1追加）
/// どの服用お休み期間かを特定するため完全な休薬期間データを記録
// どの服用お休み期間か特定するのが大変なので記録したものを使用する
@override final  RestDuration restDuration;

/// Create a copy of BeganRestDurationValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BeganRestDurationValueCopyWith<_BeganRestDurationValue> get copyWith => __$BeganRestDurationValueCopyWithImpl<_BeganRestDurationValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BeganRestDurationValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BeganRestDurationValue&&(identical(other.restDuration, restDuration) || other.restDuration == restDuration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,restDuration);

@override
String toString() {
  return 'BeganRestDurationValue(restDuration: $restDuration)';
}


}

/// @nodoc
abstract mixin class _$BeganRestDurationValueCopyWith<$Res> implements $BeganRestDurationValueCopyWith<$Res> {
  factory _$BeganRestDurationValueCopyWith(_BeganRestDurationValue value, $Res Function(_BeganRestDurationValue) _then) = __$BeganRestDurationValueCopyWithImpl;
@override @useResult
$Res call({
 RestDuration restDuration
});


@override $RestDurationCopyWith<$Res> get restDuration;

}
/// @nodoc
class __$BeganRestDurationValueCopyWithImpl<$Res>
    implements _$BeganRestDurationValueCopyWith<$Res> {
  __$BeganRestDurationValueCopyWithImpl(this._self, this._then);

  final _BeganRestDurationValue _self;
  final $Res Function(_BeganRestDurationValue) _then;

/// Create a copy of BeganRestDurationValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? restDuration = null,}) {
  return _then(_BeganRestDurationValue(
restDuration: null == restDuration ? _self.restDuration : restDuration // ignore: cast_nullable_to_non_nullable
as RestDuration,
  ));
}

/// Create a copy of BeganRestDurationValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RestDurationCopyWith<$Res> get restDuration {
  
  return $RestDurationCopyWith<$Res>(_self.restDuration, (value) {
    return _then(_self.copyWith(restDuration: value));
  });
}
}


/// @nodoc
mixin _$EndedRestDurationValue {

// ============ BEGIN: Added since v1 ============
/// 終了された休薬期間の詳細情報（v1追加）
/// どの服用お休み期間かを特定するため完全な休薬期間データを記録
// どの服用お休み期間か特定するのが大変なので記録したものを使用する
 RestDuration get restDuration;
/// Create a copy of EndedRestDurationValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EndedRestDurationValueCopyWith<EndedRestDurationValue> get copyWith => _$EndedRestDurationValueCopyWithImpl<EndedRestDurationValue>(this as EndedRestDurationValue, _$identity);

  /// Serializes this EndedRestDurationValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EndedRestDurationValue&&(identical(other.restDuration, restDuration) || other.restDuration == restDuration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,restDuration);

@override
String toString() {
  return 'EndedRestDurationValue(restDuration: $restDuration)';
}


}

/// @nodoc
abstract mixin class $EndedRestDurationValueCopyWith<$Res>  {
  factory $EndedRestDurationValueCopyWith(EndedRestDurationValue value, $Res Function(EndedRestDurationValue) _then) = _$EndedRestDurationValueCopyWithImpl;
@useResult
$Res call({
 RestDuration restDuration
});


$RestDurationCopyWith<$Res> get restDuration;

}
/// @nodoc
class _$EndedRestDurationValueCopyWithImpl<$Res>
    implements $EndedRestDurationValueCopyWith<$Res> {
  _$EndedRestDurationValueCopyWithImpl(this._self, this._then);

  final EndedRestDurationValue _self;
  final $Res Function(EndedRestDurationValue) _then;

/// Create a copy of EndedRestDurationValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? restDuration = null,}) {
  return _then(_self.copyWith(
restDuration: null == restDuration ? _self.restDuration : restDuration // ignore: cast_nullable_to_non_nullable
as RestDuration,
  ));
}
/// Create a copy of EndedRestDurationValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RestDurationCopyWith<$Res> get restDuration {
  
  return $RestDurationCopyWith<$Res>(_self.restDuration, (value) {
    return _then(_self.copyWith(restDuration: value));
  });
}
}


/// Adds pattern-matching-related methods to [EndedRestDurationValue].
extension EndedRestDurationValuePatterns on EndedRestDurationValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EndedRestDurationValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EndedRestDurationValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EndedRestDurationValue value)  $default,){
final _that = this;
switch (_that) {
case _EndedRestDurationValue():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EndedRestDurationValue value)?  $default,){
final _that = this;
switch (_that) {
case _EndedRestDurationValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RestDuration restDuration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EndedRestDurationValue() when $default != null:
return $default(_that.restDuration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RestDuration restDuration)  $default,) {final _that = this;
switch (_that) {
case _EndedRestDurationValue():
return $default(_that.restDuration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RestDuration restDuration)?  $default,) {final _that = this;
switch (_that) {
case _EndedRestDurationValue() when $default != null:
return $default(_that.restDuration);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _EndedRestDurationValue extends EndedRestDurationValue {
  const _EndedRestDurationValue({required this.restDuration}): super._();
  factory _EndedRestDurationValue.fromJson(Map<String, dynamic> json) => _$EndedRestDurationValueFromJson(json);

// ============ BEGIN: Added since v1 ============
/// 終了された休薬期間の詳細情報（v1追加）
/// どの服用お休み期間かを特定するため完全な休薬期間データを記録
// どの服用お休み期間か特定するのが大変なので記録したものを使用する
@override final  RestDuration restDuration;

/// Create a copy of EndedRestDurationValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EndedRestDurationValueCopyWith<_EndedRestDurationValue> get copyWith => __$EndedRestDurationValueCopyWithImpl<_EndedRestDurationValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EndedRestDurationValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EndedRestDurationValue&&(identical(other.restDuration, restDuration) || other.restDuration == restDuration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,restDuration);

@override
String toString() {
  return 'EndedRestDurationValue(restDuration: $restDuration)';
}


}

/// @nodoc
abstract mixin class _$EndedRestDurationValueCopyWith<$Res> implements $EndedRestDurationValueCopyWith<$Res> {
  factory _$EndedRestDurationValueCopyWith(_EndedRestDurationValue value, $Res Function(_EndedRestDurationValue) _then) = __$EndedRestDurationValueCopyWithImpl;
@override @useResult
$Res call({
 RestDuration restDuration
});


@override $RestDurationCopyWith<$Res> get restDuration;

}
/// @nodoc
class __$EndedRestDurationValueCopyWithImpl<$Res>
    implements _$EndedRestDurationValueCopyWith<$Res> {
  __$EndedRestDurationValueCopyWithImpl(this._self, this._then);

  final _EndedRestDurationValue _self;
  final $Res Function(_EndedRestDurationValue) _then;

/// Create a copy of EndedRestDurationValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? restDuration = null,}) {
  return _then(_EndedRestDurationValue(
restDuration: null == restDuration ? _self.restDuration : restDuration // ignore: cast_nullable_to_non_nullable
as RestDuration,
  ));
}

/// Create a copy of EndedRestDurationValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RestDurationCopyWith<$Res> get restDuration {
  
  return $RestDurationCopyWith<$Res>(_self.restDuration, (value) {
    return _then(_self.copyWith(restDuration: value));
  });
}
}


/// @nodoc
mixin _$ChangedRestDurationBeginDateValue {

/// 変更前の休薬期間情報（v2追加）
/// 開始日変更前の完全な休薬期間データ
 RestDuration get beforeRestDuration;/// 変更後の休薬期間情報（v2追加）
/// 開始日変更後の完全な休薬期間データ
 RestDuration get afterRestDuration;
/// Create a copy of ChangedRestDurationBeginDateValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangedRestDurationBeginDateValueCopyWith<ChangedRestDurationBeginDateValue> get copyWith => _$ChangedRestDurationBeginDateValueCopyWithImpl<ChangedRestDurationBeginDateValue>(this as ChangedRestDurationBeginDateValue, _$identity);

  /// Serializes this ChangedRestDurationBeginDateValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangedRestDurationBeginDateValue&&(identical(other.beforeRestDuration, beforeRestDuration) || other.beforeRestDuration == beforeRestDuration)&&(identical(other.afterRestDuration, afterRestDuration) || other.afterRestDuration == afterRestDuration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,beforeRestDuration,afterRestDuration);

@override
String toString() {
  return 'ChangedRestDurationBeginDateValue(beforeRestDuration: $beforeRestDuration, afterRestDuration: $afterRestDuration)';
}


}

/// @nodoc
abstract mixin class $ChangedRestDurationBeginDateValueCopyWith<$Res>  {
  factory $ChangedRestDurationBeginDateValueCopyWith(ChangedRestDurationBeginDateValue value, $Res Function(ChangedRestDurationBeginDateValue) _then) = _$ChangedRestDurationBeginDateValueCopyWithImpl;
@useResult
$Res call({
 RestDuration beforeRestDuration, RestDuration afterRestDuration
});


$RestDurationCopyWith<$Res> get beforeRestDuration;$RestDurationCopyWith<$Res> get afterRestDuration;

}
/// @nodoc
class _$ChangedRestDurationBeginDateValueCopyWithImpl<$Res>
    implements $ChangedRestDurationBeginDateValueCopyWith<$Res> {
  _$ChangedRestDurationBeginDateValueCopyWithImpl(this._self, this._then);

  final ChangedRestDurationBeginDateValue _self;
  final $Res Function(ChangedRestDurationBeginDateValue) _then;

/// Create a copy of ChangedRestDurationBeginDateValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? beforeRestDuration = null,Object? afterRestDuration = null,}) {
  return _then(_self.copyWith(
beforeRestDuration: null == beforeRestDuration ? _self.beforeRestDuration : beforeRestDuration // ignore: cast_nullable_to_non_nullable
as RestDuration,afterRestDuration: null == afterRestDuration ? _self.afterRestDuration : afterRestDuration // ignore: cast_nullable_to_non_nullable
as RestDuration,
  ));
}
/// Create a copy of ChangedRestDurationBeginDateValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RestDurationCopyWith<$Res> get beforeRestDuration {
  
  return $RestDurationCopyWith<$Res>(_self.beforeRestDuration, (value) {
    return _then(_self.copyWith(beforeRestDuration: value));
  });
}/// Create a copy of ChangedRestDurationBeginDateValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RestDurationCopyWith<$Res> get afterRestDuration {
  
  return $RestDurationCopyWith<$Res>(_self.afterRestDuration, (value) {
    return _then(_self.copyWith(afterRestDuration: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChangedRestDurationBeginDateValue].
extension ChangedRestDurationBeginDateValuePatterns on ChangedRestDurationBeginDateValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChangedRestDurationBeginDateValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangedRestDurationBeginDateValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChangedRestDurationBeginDateValue value)  $default,){
final _that = this;
switch (_that) {
case _ChangedRestDurationBeginDateValue():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChangedRestDurationBeginDateValue value)?  $default,){
final _that = this;
switch (_that) {
case _ChangedRestDurationBeginDateValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RestDuration beforeRestDuration,  RestDuration afterRestDuration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangedRestDurationBeginDateValue() when $default != null:
return $default(_that.beforeRestDuration,_that.afterRestDuration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RestDuration beforeRestDuration,  RestDuration afterRestDuration)  $default,) {final _that = this;
switch (_that) {
case _ChangedRestDurationBeginDateValue():
return $default(_that.beforeRestDuration,_that.afterRestDuration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RestDuration beforeRestDuration,  RestDuration afterRestDuration)?  $default,) {final _that = this;
switch (_that) {
case _ChangedRestDurationBeginDateValue() when $default != null:
return $default(_that.beforeRestDuration,_that.afterRestDuration);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ChangedRestDurationBeginDateValue extends ChangedRestDurationBeginDateValue {
  const _ChangedRestDurationBeginDateValue({required this.beforeRestDuration, required this.afterRestDuration}): super._();
  factory _ChangedRestDurationBeginDateValue.fromJson(Map<String, dynamic> json) => _$ChangedRestDurationBeginDateValueFromJson(json);

/// 変更前の休薬期間情報（v2追加）
/// 開始日変更前の完全な休薬期間データ
@override final  RestDuration beforeRestDuration;
/// 変更後の休薬期間情報（v2追加）
/// 開始日変更後の完全な休薬期間データ
@override final  RestDuration afterRestDuration;

/// Create a copy of ChangedRestDurationBeginDateValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangedRestDurationBeginDateValueCopyWith<_ChangedRestDurationBeginDateValue> get copyWith => __$ChangedRestDurationBeginDateValueCopyWithImpl<_ChangedRestDurationBeginDateValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChangedRestDurationBeginDateValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangedRestDurationBeginDateValue&&(identical(other.beforeRestDuration, beforeRestDuration) || other.beforeRestDuration == beforeRestDuration)&&(identical(other.afterRestDuration, afterRestDuration) || other.afterRestDuration == afterRestDuration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,beforeRestDuration,afterRestDuration);

@override
String toString() {
  return 'ChangedRestDurationBeginDateValue(beforeRestDuration: $beforeRestDuration, afterRestDuration: $afterRestDuration)';
}


}

/// @nodoc
abstract mixin class _$ChangedRestDurationBeginDateValueCopyWith<$Res> implements $ChangedRestDurationBeginDateValueCopyWith<$Res> {
  factory _$ChangedRestDurationBeginDateValueCopyWith(_ChangedRestDurationBeginDateValue value, $Res Function(_ChangedRestDurationBeginDateValue) _then) = __$ChangedRestDurationBeginDateValueCopyWithImpl;
@override @useResult
$Res call({
 RestDuration beforeRestDuration, RestDuration afterRestDuration
});


@override $RestDurationCopyWith<$Res> get beforeRestDuration;@override $RestDurationCopyWith<$Res> get afterRestDuration;

}
/// @nodoc
class __$ChangedRestDurationBeginDateValueCopyWithImpl<$Res>
    implements _$ChangedRestDurationBeginDateValueCopyWith<$Res> {
  __$ChangedRestDurationBeginDateValueCopyWithImpl(this._self, this._then);

  final _ChangedRestDurationBeginDateValue _self;
  final $Res Function(_ChangedRestDurationBeginDateValue) _then;

/// Create a copy of ChangedRestDurationBeginDateValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? beforeRestDuration = null,Object? afterRestDuration = null,}) {
  return _then(_ChangedRestDurationBeginDateValue(
beforeRestDuration: null == beforeRestDuration ? _self.beforeRestDuration : beforeRestDuration // ignore: cast_nullable_to_non_nullable
as RestDuration,afterRestDuration: null == afterRestDuration ? _self.afterRestDuration : afterRestDuration // ignore: cast_nullable_to_non_nullable
as RestDuration,
  ));
}

/// Create a copy of ChangedRestDurationBeginDateValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RestDurationCopyWith<$Res> get beforeRestDuration {
  
  return $RestDurationCopyWith<$Res>(_self.beforeRestDuration, (value) {
    return _then(_self.copyWith(beforeRestDuration: value));
  });
}/// Create a copy of ChangedRestDurationBeginDateValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RestDurationCopyWith<$Res> get afterRestDuration {
  
  return $RestDurationCopyWith<$Res>(_self.afterRestDuration, (value) {
    return _then(_self.copyWith(afterRestDuration: value));
  });
}
}


/// @nodoc
mixin _$ChangedRestDurationValue {

/// 変更前の休薬期間情報（v2追加）
/// 内容変更前の完全な休薬期間データ
 RestDuration get beforeRestDuration;/// 変更後の休薬期間情報（v2追加）
/// 内容変更後の完全な休薬期間データ
 RestDuration get afterRestDuration;
/// Create a copy of ChangedRestDurationValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangedRestDurationValueCopyWith<ChangedRestDurationValue> get copyWith => _$ChangedRestDurationValueCopyWithImpl<ChangedRestDurationValue>(this as ChangedRestDurationValue, _$identity);

  /// Serializes this ChangedRestDurationValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangedRestDurationValue&&(identical(other.beforeRestDuration, beforeRestDuration) || other.beforeRestDuration == beforeRestDuration)&&(identical(other.afterRestDuration, afterRestDuration) || other.afterRestDuration == afterRestDuration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,beforeRestDuration,afterRestDuration);

@override
String toString() {
  return 'ChangedRestDurationValue(beforeRestDuration: $beforeRestDuration, afterRestDuration: $afterRestDuration)';
}


}

/// @nodoc
abstract mixin class $ChangedRestDurationValueCopyWith<$Res>  {
  factory $ChangedRestDurationValueCopyWith(ChangedRestDurationValue value, $Res Function(ChangedRestDurationValue) _then) = _$ChangedRestDurationValueCopyWithImpl;
@useResult
$Res call({
 RestDuration beforeRestDuration, RestDuration afterRestDuration
});


$RestDurationCopyWith<$Res> get beforeRestDuration;$RestDurationCopyWith<$Res> get afterRestDuration;

}
/// @nodoc
class _$ChangedRestDurationValueCopyWithImpl<$Res>
    implements $ChangedRestDurationValueCopyWith<$Res> {
  _$ChangedRestDurationValueCopyWithImpl(this._self, this._then);

  final ChangedRestDurationValue _self;
  final $Res Function(ChangedRestDurationValue) _then;

/// Create a copy of ChangedRestDurationValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? beforeRestDuration = null,Object? afterRestDuration = null,}) {
  return _then(_self.copyWith(
beforeRestDuration: null == beforeRestDuration ? _self.beforeRestDuration : beforeRestDuration // ignore: cast_nullable_to_non_nullable
as RestDuration,afterRestDuration: null == afterRestDuration ? _self.afterRestDuration : afterRestDuration // ignore: cast_nullable_to_non_nullable
as RestDuration,
  ));
}
/// Create a copy of ChangedRestDurationValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RestDurationCopyWith<$Res> get beforeRestDuration {
  
  return $RestDurationCopyWith<$Res>(_self.beforeRestDuration, (value) {
    return _then(_self.copyWith(beforeRestDuration: value));
  });
}/// Create a copy of ChangedRestDurationValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RestDurationCopyWith<$Res> get afterRestDuration {
  
  return $RestDurationCopyWith<$Res>(_self.afterRestDuration, (value) {
    return _then(_self.copyWith(afterRestDuration: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChangedRestDurationValue].
extension ChangedRestDurationValuePatterns on ChangedRestDurationValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChangedRestDurationValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangedRestDurationValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChangedRestDurationValue value)  $default,){
final _that = this;
switch (_that) {
case _ChangedRestDurationValue():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChangedRestDurationValue value)?  $default,){
final _that = this;
switch (_that) {
case _ChangedRestDurationValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RestDuration beforeRestDuration,  RestDuration afterRestDuration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangedRestDurationValue() when $default != null:
return $default(_that.beforeRestDuration,_that.afterRestDuration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RestDuration beforeRestDuration,  RestDuration afterRestDuration)  $default,) {final _that = this;
switch (_that) {
case _ChangedRestDurationValue():
return $default(_that.beforeRestDuration,_that.afterRestDuration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RestDuration beforeRestDuration,  RestDuration afterRestDuration)?  $default,) {final _that = this;
switch (_that) {
case _ChangedRestDurationValue() when $default != null:
return $default(_that.beforeRestDuration,_that.afterRestDuration);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ChangedRestDurationValue extends ChangedRestDurationValue {
  const _ChangedRestDurationValue({required this.beforeRestDuration, required this.afterRestDuration}): super._();
  factory _ChangedRestDurationValue.fromJson(Map<String, dynamic> json) => _$ChangedRestDurationValueFromJson(json);

/// 変更前の休薬期間情報（v2追加）
/// 内容変更前の完全な休薬期間データ
@override final  RestDuration beforeRestDuration;
/// 変更後の休薬期間情報（v2追加）
/// 内容変更後の完全な休薬期間データ
@override final  RestDuration afterRestDuration;

/// Create a copy of ChangedRestDurationValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangedRestDurationValueCopyWith<_ChangedRestDurationValue> get copyWith => __$ChangedRestDurationValueCopyWithImpl<_ChangedRestDurationValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChangedRestDurationValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangedRestDurationValue&&(identical(other.beforeRestDuration, beforeRestDuration) || other.beforeRestDuration == beforeRestDuration)&&(identical(other.afterRestDuration, afterRestDuration) || other.afterRestDuration == afterRestDuration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,beforeRestDuration,afterRestDuration);

@override
String toString() {
  return 'ChangedRestDurationValue(beforeRestDuration: $beforeRestDuration, afterRestDuration: $afterRestDuration)';
}


}

/// @nodoc
abstract mixin class _$ChangedRestDurationValueCopyWith<$Res> implements $ChangedRestDurationValueCopyWith<$Res> {
  factory _$ChangedRestDurationValueCopyWith(_ChangedRestDurationValue value, $Res Function(_ChangedRestDurationValue) _then) = __$ChangedRestDurationValueCopyWithImpl;
@override @useResult
$Res call({
 RestDuration beforeRestDuration, RestDuration afterRestDuration
});


@override $RestDurationCopyWith<$Res> get beforeRestDuration;@override $RestDurationCopyWith<$Res> get afterRestDuration;

}
/// @nodoc
class __$ChangedRestDurationValueCopyWithImpl<$Res>
    implements _$ChangedRestDurationValueCopyWith<$Res> {
  __$ChangedRestDurationValueCopyWithImpl(this._self, this._then);

  final _ChangedRestDurationValue _self;
  final $Res Function(_ChangedRestDurationValue) _then;

/// Create a copy of ChangedRestDurationValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? beforeRestDuration = null,Object? afterRestDuration = null,}) {
  return _then(_ChangedRestDurationValue(
beforeRestDuration: null == beforeRestDuration ? _self.beforeRestDuration : beforeRestDuration // ignore: cast_nullable_to_non_nullable
as RestDuration,afterRestDuration: null == afterRestDuration ? _self.afterRestDuration : afterRestDuration // ignore: cast_nullable_to_non_nullable
as RestDuration,
  ));
}

/// Create a copy of ChangedRestDurationValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RestDurationCopyWith<$Res> get beforeRestDuration {
  
  return $RestDurationCopyWith<$Res>(_self.beforeRestDuration, (value) {
    return _then(_self.copyWith(beforeRestDuration: value));
  });
}/// Create a copy of ChangedRestDurationValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RestDurationCopyWith<$Res> get afterRestDuration {
  
  return $RestDurationCopyWith<$Res>(_self.afterRestDuration, (value) {
    return _then(_self.copyWith(afterRestDuration: value));
  });
}
}


/// @nodoc
mixin _$ChangedBeginDisplayNumberValue {

// The below properties are deprecated and added since v1.
// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
/// 変更前の表示番号設定（非推奨、nullable）
/// 番号を変更したことがない場合はnullとなる
// 番号を変更した事が無い場合もあるのでnullable
 PillSheetGroupDisplayNumberSetting? get beforeDisplayNumberSetting;/// 変更後の表示番号設定（非推奨）
/// 変更操作後の新しい表示番号設定
 PillSheetGroupDisplayNumberSetting get afterDisplayNumberSetting;
/// Create a copy of ChangedBeginDisplayNumberValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangedBeginDisplayNumberValueCopyWith<ChangedBeginDisplayNumberValue> get copyWith => _$ChangedBeginDisplayNumberValueCopyWithImpl<ChangedBeginDisplayNumberValue>(this as ChangedBeginDisplayNumberValue, _$identity);

  /// Serializes this ChangedBeginDisplayNumberValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangedBeginDisplayNumberValue&&(identical(other.beforeDisplayNumberSetting, beforeDisplayNumberSetting) || other.beforeDisplayNumberSetting == beforeDisplayNumberSetting)&&(identical(other.afterDisplayNumberSetting, afterDisplayNumberSetting) || other.afterDisplayNumberSetting == afterDisplayNumberSetting));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,beforeDisplayNumberSetting,afterDisplayNumberSetting);

@override
String toString() {
  return 'ChangedBeginDisplayNumberValue(beforeDisplayNumberSetting: $beforeDisplayNumberSetting, afterDisplayNumberSetting: $afterDisplayNumberSetting)';
}


}

/// @nodoc
abstract mixin class $ChangedBeginDisplayNumberValueCopyWith<$Res>  {
  factory $ChangedBeginDisplayNumberValueCopyWith(ChangedBeginDisplayNumberValue value, $Res Function(ChangedBeginDisplayNumberValue) _then) = _$ChangedBeginDisplayNumberValueCopyWithImpl;
@useResult
$Res call({
 PillSheetGroupDisplayNumberSetting? beforeDisplayNumberSetting, PillSheetGroupDisplayNumberSetting afterDisplayNumberSetting
});


$PillSheetGroupDisplayNumberSettingCopyWith<$Res>? get beforeDisplayNumberSetting;$PillSheetGroupDisplayNumberSettingCopyWith<$Res> get afterDisplayNumberSetting;

}
/// @nodoc
class _$ChangedBeginDisplayNumberValueCopyWithImpl<$Res>
    implements $ChangedBeginDisplayNumberValueCopyWith<$Res> {
  _$ChangedBeginDisplayNumberValueCopyWithImpl(this._self, this._then);

  final ChangedBeginDisplayNumberValue _self;
  final $Res Function(ChangedBeginDisplayNumberValue) _then;

/// Create a copy of ChangedBeginDisplayNumberValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? beforeDisplayNumberSetting = freezed,Object? afterDisplayNumberSetting = null,}) {
  return _then(_self.copyWith(
beforeDisplayNumberSetting: freezed == beforeDisplayNumberSetting ? _self.beforeDisplayNumberSetting : beforeDisplayNumberSetting // ignore: cast_nullable_to_non_nullable
as PillSheetGroupDisplayNumberSetting?,afterDisplayNumberSetting: null == afterDisplayNumberSetting ? _self.afterDisplayNumberSetting : afterDisplayNumberSetting // ignore: cast_nullable_to_non_nullable
as PillSheetGroupDisplayNumberSetting,
  ));
}
/// Create a copy of ChangedBeginDisplayNumberValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PillSheetGroupDisplayNumberSettingCopyWith<$Res>? get beforeDisplayNumberSetting {
    if (_self.beforeDisplayNumberSetting == null) {
    return null;
  }

  return $PillSheetGroupDisplayNumberSettingCopyWith<$Res>(_self.beforeDisplayNumberSetting!, (value) {
    return _then(_self.copyWith(beforeDisplayNumberSetting: value));
  });
}/// Create a copy of ChangedBeginDisplayNumberValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PillSheetGroupDisplayNumberSettingCopyWith<$Res> get afterDisplayNumberSetting {
  
  return $PillSheetGroupDisplayNumberSettingCopyWith<$Res>(_self.afterDisplayNumberSetting, (value) {
    return _then(_self.copyWith(afterDisplayNumberSetting: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChangedBeginDisplayNumberValue].
extension ChangedBeginDisplayNumberValuePatterns on ChangedBeginDisplayNumberValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChangedBeginDisplayNumberValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangedBeginDisplayNumberValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChangedBeginDisplayNumberValue value)  $default,){
final _that = this;
switch (_that) {
case _ChangedBeginDisplayNumberValue():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChangedBeginDisplayNumberValue value)?  $default,){
final _that = this;
switch (_that) {
case _ChangedBeginDisplayNumberValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PillSheetGroupDisplayNumberSetting? beforeDisplayNumberSetting,  PillSheetGroupDisplayNumberSetting afterDisplayNumberSetting)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangedBeginDisplayNumberValue() when $default != null:
return $default(_that.beforeDisplayNumberSetting,_that.afterDisplayNumberSetting);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PillSheetGroupDisplayNumberSetting? beforeDisplayNumberSetting,  PillSheetGroupDisplayNumberSetting afterDisplayNumberSetting)  $default,) {final _that = this;
switch (_that) {
case _ChangedBeginDisplayNumberValue():
return $default(_that.beforeDisplayNumberSetting,_that.afterDisplayNumberSetting);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PillSheetGroupDisplayNumberSetting? beforeDisplayNumberSetting,  PillSheetGroupDisplayNumberSetting afterDisplayNumberSetting)?  $default,) {final _that = this;
switch (_that) {
case _ChangedBeginDisplayNumberValue() when $default != null:
return $default(_that.beforeDisplayNumberSetting,_that.afterDisplayNumberSetting);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ChangedBeginDisplayNumberValue extends ChangedBeginDisplayNumberValue {
  const _ChangedBeginDisplayNumberValue({required this.beforeDisplayNumberSetting, required this.afterDisplayNumberSetting}): super._();
  factory _ChangedBeginDisplayNumberValue.fromJson(Map<String, dynamic> json) => _$ChangedBeginDisplayNumberValueFromJson(json);

// The below properties are deprecated and added since v1.
// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
/// 変更前の表示番号設定（非推奨、nullable）
/// 番号を変更したことがない場合はnullとなる
// 番号を変更した事が無い場合もあるのでnullable
@override final  PillSheetGroupDisplayNumberSetting? beforeDisplayNumberSetting;
/// 変更後の表示番号設定（非推奨）
/// 変更操作後の新しい表示番号設定
@override final  PillSheetGroupDisplayNumberSetting afterDisplayNumberSetting;

/// Create a copy of ChangedBeginDisplayNumberValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangedBeginDisplayNumberValueCopyWith<_ChangedBeginDisplayNumberValue> get copyWith => __$ChangedBeginDisplayNumberValueCopyWithImpl<_ChangedBeginDisplayNumberValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChangedBeginDisplayNumberValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangedBeginDisplayNumberValue&&(identical(other.beforeDisplayNumberSetting, beforeDisplayNumberSetting) || other.beforeDisplayNumberSetting == beforeDisplayNumberSetting)&&(identical(other.afterDisplayNumberSetting, afterDisplayNumberSetting) || other.afterDisplayNumberSetting == afterDisplayNumberSetting));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,beforeDisplayNumberSetting,afterDisplayNumberSetting);

@override
String toString() {
  return 'ChangedBeginDisplayNumberValue(beforeDisplayNumberSetting: $beforeDisplayNumberSetting, afterDisplayNumberSetting: $afterDisplayNumberSetting)';
}


}

/// @nodoc
abstract mixin class _$ChangedBeginDisplayNumberValueCopyWith<$Res> implements $ChangedBeginDisplayNumberValueCopyWith<$Res> {
  factory _$ChangedBeginDisplayNumberValueCopyWith(_ChangedBeginDisplayNumberValue value, $Res Function(_ChangedBeginDisplayNumberValue) _then) = __$ChangedBeginDisplayNumberValueCopyWithImpl;
@override @useResult
$Res call({
 PillSheetGroupDisplayNumberSetting? beforeDisplayNumberSetting, PillSheetGroupDisplayNumberSetting afterDisplayNumberSetting
});


@override $PillSheetGroupDisplayNumberSettingCopyWith<$Res>? get beforeDisplayNumberSetting;@override $PillSheetGroupDisplayNumberSettingCopyWith<$Res> get afterDisplayNumberSetting;

}
/// @nodoc
class __$ChangedBeginDisplayNumberValueCopyWithImpl<$Res>
    implements _$ChangedBeginDisplayNumberValueCopyWith<$Res> {
  __$ChangedBeginDisplayNumberValueCopyWithImpl(this._self, this._then);

  final _ChangedBeginDisplayNumberValue _self;
  final $Res Function(_ChangedBeginDisplayNumberValue) _then;

/// Create a copy of ChangedBeginDisplayNumberValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? beforeDisplayNumberSetting = freezed,Object? afterDisplayNumberSetting = null,}) {
  return _then(_ChangedBeginDisplayNumberValue(
beforeDisplayNumberSetting: freezed == beforeDisplayNumberSetting ? _self.beforeDisplayNumberSetting : beforeDisplayNumberSetting // ignore: cast_nullable_to_non_nullable
as PillSheetGroupDisplayNumberSetting?,afterDisplayNumberSetting: null == afterDisplayNumberSetting ? _self.afterDisplayNumberSetting : afterDisplayNumberSetting // ignore: cast_nullable_to_non_nullable
as PillSheetGroupDisplayNumberSetting,
  ));
}

/// Create a copy of ChangedBeginDisplayNumberValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PillSheetGroupDisplayNumberSettingCopyWith<$Res>? get beforeDisplayNumberSetting {
    if (_self.beforeDisplayNumberSetting == null) {
    return null;
  }

  return $PillSheetGroupDisplayNumberSettingCopyWith<$Res>(_self.beforeDisplayNumberSetting!, (value) {
    return _then(_self.copyWith(beforeDisplayNumberSetting: value));
  });
}/// Create a copy of ChangedBeginDisplayNumberValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PillSheetGroupDisplayNumberSettingCopyWith<$Res> get afterDisplayNumberSetting {
  
  return $PillSheetGroupDisplayNumberSettingCopyWith<$Res>(_self.afterDisplayNumberSetting, (value) {
    return _then(_self.copyWith(afterDisplayNumberSetting: value));
  });
}
}


/// @nodoc
mixin _$ChangedEndDisplayNumberValue {

// The below properties are deprecated and added since v1.
// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
/// 変更前の表示番号設定（非推奨、nullable）
/// 番号を変更したことがない場合はnullとなる
// 番号を変更した事が無い場合もあるのでnullable
 PillSheetGroupDisplayNumberSetting? get beforeDisplayNumberSetting;/// 変更後の表示番号設定（非推奨）
/// 変更操作後の新しい表示番号設定
 PillSheetGroupDisplayNumberSetting get afterDisplayNumberSetting;
/// Create a copy of ChangedEndDisplayNumberValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangedEndDisplayNumberValueCopyWith<ChangedEndDisplayNumberValue> get copyWith => _$ChangedEndDisplayNumberValueCopyWithImpl<ChangedEndDisplayNumberValue>(this as ChangedEndDisplayNumberValue, _$identity);

  /// Serializes this ChangedEndDisplayNumberValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangedEndDisplayNumberValue&&(identical(other.beforeDisplayNumberSetting, beforeDisplayNumberSetting) || other.beforeDisplayNumberSetting == beforeDisplayNumberSetting)&&(identical(other.afterDisplayNumberSetting, afterDisplayNumberSetting) || other.afterDisplayNumberSetting == afterDisplayNumberSetting));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,beforeDisplayNumberSetting,afterDisplayNumberSetting);

@override
String toString() {
  return 'ChangedEndDisplayNumberValue(beforeDisplayNumberSetting: $beforeDisplayNumberSetting, afterDisplayNumberSetting: $afterDisplayNumberSetting)';
}


}

/// @nodoc
abstract mixin class $ChangedEndDisplayNumberValueCopyWith<$Res>  {
  factory $ChangedEndDisplayNumberValueCopyWith(ChangedEndDisplayNumberValue value, $Res Function(ChangedEndDisplayNumberValue) _then) = _$ChangedEndDisplayNumberValueCopyWithImpl;
@useResult
$Res call({
 PillSheetGroupDisplayNumberSetting? beforeDisplayNumberSetting, PillSheetGroupDisplayNumberSetting afterDisplayNumberSetting
});


$PillSheetGroupDisplayNumberSettingCopyWith<$Res>? get beforeDisplayNumberSetting;$PillSheetGroupDisplayNumberSettingCopyWith<$Res> get afterDisplayNumberSetting;

}
/// @nodoc
class _$ChangedEndDisplayNumberValueCopyWithImpl<$Res>
    implements $ChangedEndDisplayNumberValueCopyWith<$Res> {
  _$ChangedEndDisplayNumberValueCopyWithImpl(this._self, this._then);

  final ChangedEndDisplayNumberValue _self;
  final $Res Function(ChangedEndDisplayNumberValue) _then;

/// Create a copy of ChangedEndDisplayNumberValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? beforeDisplayNumberSetting = freezed,Object? afterDisplayNumberSetting = null,}) {
  return _then(_self.copyWith(
beforeDisplayNumberSetting: freezed == beforeDisplayNumberSetting ? _self.beforeDisplayNumberSetting : beforeDisplayNumberSetting // ignore: cast_nullable_to_non_nullable
as PillSheetGroupDisplayNumberSetting?,afterDisplayNumberSetting: null == afterDisplayNumberSetting ? _self.afterDisplayNumberSetting : afterDisplayNumberSetting // ignore: cast_nullable_to_non_nullable
as PillSheetGroupDisplayNumberSetting,
  ));
}
/// Create a copy of ChangedEndDisplayNumberValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PillSheetGroupDisplayNumberSettingCopyWith<$Res>? get beforeDisplayNumberSetting {
    if (_self.beforeDisplayNumberSetting == null) {
    return null;
  }

  return $PillSheetGroupDisplayNumberSettingCopyWith<$Res>(_self.beforeDisplayNumberSetting!, (value) {
    return _then(_self.copyWith(beforeDisplayNumberSetting: value));
  });
}/// Create a copy of ChangedEndDisplayNumberValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PillSheetGroupDisplayNumberSettingCopyWith<$Res> get afterDisplayNumberSetting {
  
  return $PillSheetGroupDisplayNumberSettingCopyWith<$Res>(_self.afterDisplayNumberSetting, (value) {
    return _then(_self.copyWith(afterDisplayNumberSetting: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChangedEndDisplayNumberValue].
extension ChangedEndDisplayNumberValuePatterns on ChangedEndDisplayNumberValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChangedEndDisplayNumberValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangedEndDisplayNumberValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChangedEndDisplayNumberValue value)  $default,){
final _that = this;
switch (_that) {
case _ChangedEndDisplayNumberValue():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChangedEndDisplayNumberValue value)?  $default,){
final _that = this;
switch (_that) {
case _ChangedEndDisplayNumberValue() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PillSheetGroupDisplayNumberSetting? beforeDisplayNumberSetting,  PillSheetGroupDisplayNumberSetting afterDisplayNumberSetting)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangedEndDisplayNumberValue() when $default != null:
return $default(_that.beforeDisplayNumberSetting,_that.afterDisplayNumberSetting);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PillSheetGroupDisplayNumberSetting? beforeDisplayNumberSetting,  PillSheetGroupDisplayNumberSetting afterDisplayNumberSetting)  $default,) {final _that = this;
switch (_that) {
case _ChangedEndDisplayNumberValue():
return $default(_that.beforeDisplayNumberSetting,_that.afterDisplayNumberSetting);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PillSheetGroupDisplayNumberSetting? beforeDisplayNumberSetting,  PillSheetGroupDisplayNumberSetting afterDisplayNumberSetting)?  $default,) {final _that = this;
switch (_that) {
case _ChangedEndDisplayNumberValue() when $default != null:
return $default(_that.beforeDisplayNumberSetting,_that.afterDisplayNumberSetting);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ChangedEndDisplayNumberValue extends ChangedEndDisplayNumberValue {
  const _ChangedEndDisplayNumberValue({required this.beforeDisplayNumberSetting, required this.afterDisplayNumberSetting}): super._();
  factory _ChangedEndDisplayNumberValue.fromJson(Map<String, dynamic> json) => _$ChangedEndDisplayNumberValueFromJson(json);

// The below properties are deprecated and added since v1.
// This is deprecated property. TODO: [PillSheetModifiedHistory-V2] delete after 2024-05-01
/// 変更前の表示番号設定（非推奨、nullable）
/// 番号を変更したことがない場合はnullとなる
// 番号を変更した事が無い場合もあるのでnullable
@override final  PillSheetGroupDisplayNumberSetting? beforeDisplayNumberSetting;
/// 変更後の表示番号設定（非推奨）
/// 変更操作後の新しい表示番号設定
@override final  PillSheetGroupDisplayNumberSetting afterDisplayNumberSetting;

/// Create a copy of ChangedEndDisplayNumberValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangedEndDisplayNumberValueCopyWith<_ChangedEndDisplayNumberValue> get copyWith => __$ChangedEndDisplayNumberValueCopyWithImpl<_ChangedEndDisplayNumberValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChangedEndDisplayNumberValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangedEndDisplayNumberValue&&(identical(other.beforeDisplayNumberSetting, beforeDisplayNumberSetting) || other.beforeDisplayNumberSetting == beforeDisplayNumberSetting)&&(identical(other.afterDisplayNumberSetting, afterDisplayNumberSetting) || other.afterDisplayNumberSetting == afterDisplayNumberSetting));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,beforeDisplayNumberSetting,afterDisplayNumberSetting);

@override
String toString() {
  return 'ChangedEndDisplayNumberValue(beforeDisplayNumberSetting: $beforeDisplayNumberSetting, afterDisplayNumberSetting: $afterDisplayNumberSetting)';
}


}

/// @nodoc
abstract mixin class _$ChangedEndDisplayNumberValueCopyWith<$Res> implements $ChangedEndDisplayNumberValueCopyWith<$Res> {
  factory _$ChangedEndDisplayNumberValueCopyWith(_ChangedEndDisplayNumberValue value, $Res Function(_ChangedEndDisplayNumberValue) _then) = __$ChangedEndDisplayNumberValueCopyWithImpl;
@override @useResult
$Res call({
 PillSheetGroupDisplayNumberSetting? beforeDisplayNumberSetting, PillSheetGroupDisplayNumberSetting afterDisplayNumberSetting
});


@override $PillSheetGroupDisplayNumberSettingCopyWith<$Res>? get beforeDisplayNumberSetting;@override $PillSheetGroupDisplayNumberSettingCopyWith<$Res> get afterDisplayNumberSetting;

}
/// @nodoc
class __$ChangedEndDisplayNumberValueCopyWithImpl<$Res>
    implements _$ChangedEndDisplayNumberValueCopyWith<$Res> {
  __$ChangedEndDisplayNumberValueCopyWithImpl(this._self, this._then);

  final _ChangedEndDisplayNumberValue _self;
  final $Res Function(_ChangedEndDisplayNumberValue) _then;

/// Create a copy of ChangedEndDisplayNumberValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? beforeDisplayNumberSetting = freezed,Object? afterDisplayNumberSetting = null,}) {
  return _then(_ChangedEndDisplayNumberValue(
beforeDisplayNumberSetting: freezed == beforeDisplayNumberSetting ? _self.beforeDisplayNumberSetting : beforeDisplayNumberSetting // ignore: cast_nullable_to_non_nullable
as PillSheetGroupDisplayNumberSetting?,afterDisplayNumberSetting: null == afterDisplayNumberSetting ? _self.afterDisplayNumberSetting : afterDisplayNumberSetting // ignore: cast_nullable_to_non_nullable
as PillSheetGroupDisplayNumberSetting,
  ));
}

/// Create a copy of ChangedEndDisplayNumberValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PillSheetGroupDisplayNumberSettingCopyWith<$Res>? get beforeDisplayNumberSetting {
    if (_self.beforeDisplayNumberSetting == null) {
    return null;
  }

  return $PillSheetGroupDisplayNumberSettingCopyWith<$Res>(_self.beforeDisplayNumberSetting!, (value) {
    return _then(_self.copyWith(beforeDisplayNumberSetting: value));
  });
}/// Create a copy of ChangedEndDisplayNumberValue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PillSheetGroupDisplayNumberSettingCopyWith<$Res> get afterDisplayNumberSetting {
  
  return $PillSheetGroupDisplayNumberSettingCopyWith<$Res>(_self.afterDisplayNumberSetting, (value) {
    return _then(_self.copyWith(afterDisplayNumberSetting: value));
  });
}
}

// dart format on
