// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Schedule {

/// ドキュメントID。Firestore保存時に自動設定される
/// nullの場合は新規作成、値がある場合は既存ドキュメントの更新を示す
@JsonKey(includeIfNull: false) String? get id;/// 予定のタイトル。ユーザーが入力する予定名
/// 例：「婦人科受診」「定期検診」など
 String get title;/// 予定日時。ユーザーがカレンダーUIで選択した日付
/// Firestoreのタイムスタンプ形式で保存される
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get date;/// ローカル通知の設定。nullの場合は通知なし
/// 予定前にリマインドを送るための設定
 LocalNotification? get localNotification;/// 予定作成日時。レコード作成時の記録用
/// データの管理やソート処理で使用される
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get createdDateTime;
/// Create a copy of Schedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleCopyWith<Schedule> get copyWith => _$ScheduleCopyWithImpl<Schedule>(this as Schedule, _$identity);

  /// Serializes this Schedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Schedule&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date)&&(identical(other.localNotification, localNotification) || other.localNotification == localNotification)&&(identical(other.createdDateTime, createdDateTime) || other.createdDateTime == createdDateTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,date,localNotification,createdDateTime);

@override
String toString() {
  return 'Schedule(id: $id, title: $title, date: $date, localNotification: $localNotification, createdDateTime: $createdDateTime)';
}


}

/// @nodoc
abstract mixin class $ScheduleCopyWith<$Res>  {
  factory $ScheduleCopyWith(Schedule value, $Res Function(Schedule) _then) = _$ScheduleCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeIfNull: false) String? id, String title,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime date, LocalNotification? localNotification,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime createdDateTime
});


$LocalNotificationCopyWith<$Res>? get localNotification;

}
/// @nodoc
class _$ScheduleCopyWithImpl<$Res>
    implements $ScheduleCopyWith<$Res> {
  _$ScheduleCopyWithImpl(this._self, this._then);

  final Schedule _self;
  final $Res Function(Schedule) _then;

/// Create a copy of Schedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? title = null,Object? date = null,Object? localNotification = freezed,Object? createdDateTime = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,localNotification: freezed == localNotification ? _self.localNotification : localNotification // ignore: cast_nullable_to_non_nullable
as LocalNotification?,createdDateTime: null == createdDateTime ? _self.createdDateTime : createdDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of Schedule
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalNotificationCopyWith<$Res>? get localNotification {
    if (_self.localNotification == null) {
    return null;
  }

  return $LocalNotificationCopyWith<$Res>(_self.localNotification!, (value) {
    return _then(_self.copyWith(localNotification: value));
  });
}
}


/// Adds pattern-matching-related methods to [Schedule].
extension SchedulePatterns on Schedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Schedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Schedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Schedule value)  $default,){
final _that = this;
switch (_that) {
case _Schedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Schedule value)?  $default,){
final _that = this;
switch (_that) {
case _Schedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? id,  String title, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime date,  LocalNotification? localNotification, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime createdDateTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Schedule() when $default != null:
return $default(_that.id,_that.title,_that.date,_that.localNotification,_that.createdDateTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? id,  String title, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime date,  LocalNotification? localNotification, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime createdDateTime)  $default,) {final _that = this;
switch (_that) {
case _Schedule():
return $default(_that.id,_that.title,_that.date,_that.localNotification,_that.createdDateTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeIfNull: false)  String? id,  String title, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime date,  LocalNotification? localNotification, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime createdDateTime)?  $default,) {final _that = this;
switch (_that) {
case _Schedule() when $default != null:
return $default(_that.id,_that.title,_that.date,_that.localNotification,_that.createdDateTime);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Schedule extends Schedule {
  const _Schedule({@JsonKey(includeIfNull: false) this.id, required this.title, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.date, this.localNotification, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.createdDateTime}): super._();
  factory _Schedule.fromJson(Map<String, dynamic> json) => _$ScheduleFromJson(json);

/// ドキュメントID。Firestore保存時に自動設定される
/// nullの場合は新規作成、値がある場合は既存ドキュメントの更新を示す
@override@JsonKey(includeIfNull: false) final  String? id;
/// 予定のタイトル。ユーザーが入力する予定名
/// 例：「婦人科受診」「定期検診」など
@override final  String title;
/// 予定日時。ユーザーがカレンダーUIで選択した日付
/// Firestoreのタイムスタンプ形式で保存される
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime date;
/// ローカル通知の設定。nullの場合は通知なし
/// 予定前にリマインドを送るための設定
@override final  LocalNotification? localNotification;
/// 予定作成日時。レコード作成時の記録用
/// データの管理やソート処理で使用される
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime createdDateTime;

/// Create a copy of Schedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleCopyWith<_Schedule> get copyWith => __$ScheduleCopyWithImpl<_Schedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Schedule&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date)&&(identical(other.localNotification, localNotification) || other.localNotification == localNotification)&&(identical(other.createdDateTime, createdDateTime) || other.createdDateTime == createdDateTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,date,localNotification,createdDateTime);

@override
String toString() {
  return 'Schedule(id: $id, title: $title, date: $date, localNotification: $localNotification, createdDateTime: $createdDateTime)';
}


}

/// @nodoc
abstract mixin class _$ScheduleCopyWith<$Res> implements $ScheduleCopyWith<$Res> {
  factory _$ScheduleCopyWith(_Schedule value, $Res Function(_Schedule) _then) = __$ScheduleCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeIfNull: false) String? id, String title,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime date, LocalNotification? localNotification,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime createdDateTime
});


@override $LocalNotificationCopyWith<$Res>? get localNotification;

}
/// @nodoc
class __$ScheduleCopyWithImpl<$Res>
    implements _$ScheduleCopyWith<$Res> {
  __$ScheduleCopyWithImpl(this._self, this._then);

  final _Schedule _self;
  final $Res Function(_Schedule) _then;

/// Create a copy of Schedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? title = null,Object? date = null,Object? localNotification = freezed,Object? createdDateTime = null,}) {
  return _then(_Schedule(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,localNotification: freezed == localNotification ? _self.localNotification : localNotification // ignore: cast_nullable_to_non_nullable
as LocalNotification?,createdDateTime: null == createdDateTime ? _self.createdDateTime : createdDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of Schedule
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalNotificationCopyWith<$Res>? get localNotification {
    if (_self.localNotification == null) {
    return null;
  }

  return $LocalNotificationCopyWith<$Res>(_self.localNotification!, (value) {
    return _then(_self.copyWith(localNotification: value));
  });
}
}


/// @nodoc
mixin _$LocalNotification {

/// flutter_local_notificationsプラグインで使用する通知ID
/// 通知のキャンセルや更新時に必要な一意識別子
 int get localNotificationID;/// 通知を送信する日時
/// ユーザーが設定したリマインド時刻に基づいて計算される
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get remindDateTime;
/// Create a copy of LocalNotification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalNotificationCopyWith<LocalNotification> get copyWith => _$LocalNotificationCopyWithImpl<LocalNotification>(this as LocalNotification, _$identity);

  /// Serializes this LocalNotification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalNotification&&(identical(other.localNotificationID, localNotificationID) || other.localNotificationID == localNotificationID)&&(identical(other.remindDateTime, remindDateTime) || other.remindDateTime == remindDateTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,localNotificationID,remindDateTime);

@override
String toString() {
  return 'LocalNotification(localNotificationID: $localNotificationID, remindDateTime: $remindDateTime)';
}


}

/// @nodoc
abstract mixin class $LocalNotificationCopyWith<$Res>  {
  factory $LocalNotificationCopyWith(LocalNotification value, $Res Function(LocalNotification) _then) = _$LocalNotificationCopyWithImpl;
@useResult
$Res call({
 int localNotificationID,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime remindDateTime
});




}
/// @nodoc
class _$LocalNotificationCopyWithImpl<$Res>
    implements $LocalNotificationCopyWith<$Res> {
  _$LocalNotificationCopyWithImpl(this._self, this._then);

  final LocalNotification _self;
  final $Res Function(LocalNotification) _then;

/// Create a copy of LocalNotification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? localNotificationID = null,Object? remindDateTime = null,}) {
  return _then(_self.copyWith(
localNotificationID: null == localNotificationID ? _self.localNotificationID : localNotificationID // ignore: cast_nullable_to_non_nullable
as int,remindDateTime: null == remindDateTime ? _self.remindDateTime : remindDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LocalNotification].
extension LocalNotificationPatterns on LocalNotification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocalNotification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocalNotification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocalNotification value)  $default,){
final _that = this;
switch (_that) {
case _LocalNotification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocalNotification value)?  $default,){
final _that = this;
switch (_that) {
case _LocalNotification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int localNotificationID, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime remindDateTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocalNotification() when $default != null:
return $default(_that.localNotificationID,_that.remindDateTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int localNotificationID, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime remindDateTime)  $default,) {final _that = this;
switch (_that) {
case _LocalNotification():
return $default(_that.localNotificationID,_that.remindDateTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int localNotificationID, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime remindDateTime)?  $default,) {final _that = this;
switch (_that) {
case _LocalNotification() when $default != null:
return $default(_that.localNotificationID,_that.remindDateTime);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _LocalNotification extends LocalNotification {
  const _LocalNotification({required this.localNotificationID, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.remindDateTime}): super._();
  factory _LocalNotification.fromJson(Map<String, dynamic> json) => _$LocalNotificationFromJson(json);

/// flutter_local_notificationsプラグインで使用する通知ID
/// 通知のキャンセルや更新時に必要な一意識別子
@override final  int localNotificationID;
/// 通知を送信する日時
/// ユーザーが設定したリマインド時刻に基づいて計算される
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime remindDateTime;

/// Create a copy of LocalNotification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalNotificationCopyWith<_LocalNotification> get copyWith => __$LocalNotificationCopyWithImpl<_LocalNotification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocalNotificationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalNotification&&(identical(other.localNotificationID, localNotificationID) || other.localNotificationID == localNotificationID)&&(identical(other.remindDateTime, remindDateTime) || other.remindDateTime == remindDateTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,localNotificationID,remindDateTime);

@override
String toString() {
  return 'LocalNotification(localNotificationID: $localNotificationID, remindDateTime: $remindDateTime)';
}


}

/// @nodoc
abstract mixin class _$LocalNotificationCopyWith<$Res> implements $LocalNotificationCopyWith<$Res> {
  factory _$LocalNotificationCopyWith(_LocalNotification value, $Res Function(_LocalNotification) _then) = __$LocalNotificationCopyWithImpl;
@override @useResult
$Res call({
 int localNotificationID,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime remindDateTime
});




}
/// @nodoc
class __$LocalNotificationCopyWithImpl<$Res>
    implements _$LocalNotificationCopyWith<$Res> {
  __$LocalNotificationCopyWithImpl(this._self, this._then);

  final _LocalNotification _self;
  final $Res Function(_LocalNotification) _then;

/// Create a copy of LocalNotification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? localNotificationID = null,Object? remindDateTime = null,}) {
  return _then(_LocalNotification(
localNotificationID: null == localNotificationID ? _self.localNotificationID : localNotificationID // ignore: cast_nullable_to_non_nullable
as int,remindDateTime: null == remindDateTime ? _self.remindDateTime : remindDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
