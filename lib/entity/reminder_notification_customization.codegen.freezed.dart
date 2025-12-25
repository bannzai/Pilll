// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder_notification_customization.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReminderNotificationCustomization {

/// 設定のバージョン番号
///
/// 新機能追加時の後方互換性を保つためのバージョン管理に使用されます。
/// 現在の最新バージョンは'v2'です。
 String get version;/// 通知タイトルの冒頭に表示される文字
///
/// 通知のタイトル部分に表示される絵文字や文字を設定します。
/// デフォルトは💊絵文字が設定されています。
 String get word;/// 通知に日付表示を含めるかどうかの制御フラグ
///
/// trueの場合、通知タイトルに日付（例: 8/14 (水)）を表示しません。
/// falseの場合、通知タイトルに日付を表示します。
 bool get isInVisibleReminderDate;/// 通知にピル番号表示を含めるかどうかの制御フラグ
///
/// trueの場合、通知タイトルにピル番号（例: 15番目）を表示しません。
/// falseの場合、通知タイトルにピル番号を表示します。
 bool get isInVisiblePillNumber;/// 通知に説明文を含めるかどうかの制御フラグ
///
/// trueの場合、通知の説明文（メッセージ本文）を表示しません。
/// falseの場合、dailyTakenMessageまたはmissedTakenMessageが表示されます。
 bool get isInVisibleDescription;// BEGIN: From v2
/// 日々の服用時に表示するメッセージ
///
/// v2で追加された機能です。通常の服用リマインダー時に表示される
/// カスタマイズ可能なメッセージです。
 String get dailyTakenMessage;// TODO: [Localizations]
/// 飲み忘れ時に表示するメッセージ
///
/// v2で追加された機能です。複数日の飲み忘れが検出された場合に
/// 表示されるメッセージです。デフォルトでは🤔絵文字付きの
/// 日本語メッセージが設定されています。
 String get missedTakenMessage;
/// Create a copy of ReminderNotificationCustomization
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderNotificationCustomizationCopyWith<ReminderNotificationCustomization> get copyWith => _$ReminderNotificationCustomizationCopyWithImpl<ReminderNotificationCustomization>(this as ReminderNotificationCustomization, _$identity);

  /// Serializes this ReminderNotificationCustomization to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderNotificationCustomization&&(identical(other.version, version) || other.version == version)&&(identical(other.word, word) || other.word == word)&&(identical(other.isInVisibleReminderDate, isInVisibleReminderDate) || other.isInVisibleReminderDate == isInVisibleReminderDate)&&(identical(other.isInVisiblePillNumber, isInVisiblePillNumber) || other.isInVisiblePillNumber == isInVisiblePillNumber)&&(identical(other.isInVisibleDescription, isInVisibleDescription) || other.isInVisibleDescription == isInVisibleDescription)&&(identical(other.dailyTakenMessage, dailyTakenMessage) || other.dailyTakenMessage == dailyTakenMessage)&&(identical(other.missedTakenMessage, missedTakenMessage) || other.missedTakenMessage == missedTakenMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,word,isInVisibleReminderDate,isInVisiblePillNumber,isInVisibleDescription,dailyTakenMessage,missedTakenMessage);

@override
String toString() {
  return 'ReminderNotificationCustomization(version: $version, word: $word, isInVisibleReminderDate: $isInVisibleReminderDate, isInVisiblePillNumber: $isInVisiblePillNumber, isInVisibleDescription: $isInVisibleDescription, dailyTakenMessage: $dailyTakenMessage, missedTakenMessage: $missedTakenMessage)';
}


}

/// @nodoc
abstract mixin class $ReminderNotificationCustomizationCopyWith<$Res>  {
  factory $ReminderNotificationCustomizationCopyWith(ReminderNotificationCustomization value, $Res Function(ReminderNotificationCustomization) _then) = _$ReminderNotificationCustomizationCopyWithImpl;
@useResult
$Res call({
 String version, String word, bool isInVisibleReminderDate, bool isInVisiblePillNumber, bool isInVisibleDescription, String dailyTakenMessage, String missedTakenMessage
});




}
/// @nodoc
class _$ReminderNotificationCustomizationCopyWithImpl<$Res>
    implements $ReminderNotificationCustomizationCopyWith<$Res> {
  _$ReminderNotificationCustomizationCopyWithImpl(this._self, this._then);

  final ReminderNotificationCustomization _self;
  final $Res Function(ReminderNotificationCustomization) _then;

/// Create a copy of ReminderNotificationCustomization
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? word = null,Object? isInVisibleReminderDate = null,Object? isInVisiblePillNumber = null,Object? isInVisibleDescription = null,Object? dailyTakenMessage = null,Object? missedTakenMessage = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,isInVisibleReminderDate: null == isInVisibleReminderDate ? _self.isInVisibleReminderDate : isInVisibleReminderDate // ignore: cast_nullable_to_non_nullable
as bool,isInVisiblePillNumber: null == isInVisiblePillNumber ? _self.isInVisiblePillNumber : isInVisiblePillNumber // ignore: cast_nullable_to_non_nullable
as bool,isInVisibleDescription: null == isInVisibleDescription ? _self.isInVisibleDescription : isInVisibleDescription // ignore: cast_nullable_to_non_nullable
as bool,dailyTakenMessage: null == dailyTakenMessage ? _self.dailyTakenMessage : dailyTakenMessage // ignore: cast_nullable_to_non_nullable
as String,missedTakenMessage: null == missedTakenMessage ? _self.missedTakenMessage : missedTakenMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReminderNotificationCustomization].
extension ReminderNotificationCustomizationPatterns on ReminderNotificationCustomization {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReminderNotificationCustomization value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReminderNotificationCustomization() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReminderNotificationCustomization value)  $default,){
final _that = this;
switch (_that) {
case _ReminderNotificationCustomization():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReminderNotificationCustomization value)?  $default,){
final _that = this;
switch (_that) {
case _ReminderNotificationCustomization() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String version,  String word,  bool isInVisibleReminderDate,  bool isInVisiblePillNumber,  bool isInVisibleDescription,  String dailyTakenMessage,  String missedTakenMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReminderNotificationCustomization() when $default != null:
return $default(_that.version,_that.word,_that.isInVisibleReminderDate,_that.isInVisiblePillNumber,_that.isInVisibleDescription,_that.dailyTakenMessage,_that.missedTakenMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String version,  String word,  bool isInVisibleReminderDate,  bool isInVisiblePillNumber,  bool isInVisibleDescription,  String dailyTakenMessage,  String missedTakenMessage)  $default,) {final _that = this;
switch (_that) {
case _ReminderNotificationCustomization():
return $default(_that.version,_that.word,_that.isInVisibleReminderDate,_that.isInVisiblePillNumber,_that.isInVisibleDescription,_that.dailyTakenMessage,_that.missedTakenMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String version,  String word,  bool isInVisibleReminderDate,  bool isInVisiblePillNumber,  bool isInVisibleDescription,  String dailyTakenMessage,  String missedTakenMessage)?  $default,) {final _that = this;
switch (_that) {
case _ReminderNotificationCustomization() when $default != null:
return $default(_that.version,_that.word,_that.isInVisibleReminderDate,_that.isInVisiblePillNumber,_that.isInVisibleDescription,_that.dailyTakenMessage,_that.missedTakenMessage);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ReminderNotificationCustomization extends ReminderNotificationCustomization {
  const _ReminderNotificationCustomization({this.version = 'v2', this.word = pillEmoji, this.isInVisibleReminderDate = false, this.isInVisiblePillNumber = false, this.isInVisibleDescription = false, this.dailyTakenMessage = '', this.missedTakenMessage = '飲み忘れていませんか？\n服用記録がない日が複数あります$thinkingFaceEmoji'}): super._();
  factory _ReminderNotificationCustomization.fromJson(Map<String, dynamic> json) => _$ReminderNotificationCustomizationFromJson(json);

/// 設定のバージョン番号
///
/// 新機能追加時の後方互換性を保つためのバージョン管理に使用されます。
/// 現在の最新バージョンは'v2'です。
@override@JsonKey() final  String version;
/// 通知タイトルの冒頭に表示される文字
///
/// 通知のタイトル部分に表示される絵文字や文字を設定します。
/// デフォルトは💊絵文字が設定されています。
@override@JsonKey() final  String word;
/// 通知に日付表示を含めるかどうかの制御フラグ
///
/// trueの場合、通知タイトルに日付（例: 8/14 (水)）を表示しません。
/// falseの場合、通知タイトルに日付を表示します。
@override@JsonKey() final  bool isInVisibleReminderDate;
/// 通知にピル番号表示を含めるかどうかの制御フラグ
///
/// trueの場合、通知タイトルにピル番号（例: 15番目）を表示しません。
/// falseの場合、通知タイトルにピル番号を表示します。
@override@JsonKey() final  bool isInVisiblePillNumber;
/// 通知に説明文を含めるかどうかの制御フラグ
///
/// trueの場合、通知の説明文（メッセージ本文）を表示しません。
/// falseの場合、dailyTakenMessageまたはmissedTakenMessageが表示されます。
@override@JsonKey() final  bool isInVisibleDescription;
// BEGIN: From v2
/// 日々の服用時に表示するメッセージ
///
/// v2で追加された機能です。通常の服用リマインダー時に表示される
/// カスタマイズ可能なメッセージです。
@override@JsonKey() final  String dailyTakenMessage;
// TODO: [Localizations]
/// 飲み忘れ時に表示するメッセージ
///
/// v2で追加された機能です。複数日の飲み忘れが検出された場合に
/// 表示されるメッセージです。デフォルトでは🤔絵文字付きの
/// 日本語メッセージが設定されています。
@override@JsonKey() final  String missedTakenMessage;

/// Create a copy of ReminderNotificationCustomization
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReminderNotificationCustomizationCopyWith<_ReminderNotificationCustomization> get copyWith => __$ReminderNotificationCustomizationCopyWithImpl<_ReminderNotificationCustomization>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReminderNotificationCustomizationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReminderNotificationCustomization&&(identical(other.version, version) || other.version == version)&&(identical(other.word, word) || other.word == word)&&(identical(other.isInVisibleReminderDate, isInVisibleReminderDate) || other.isInVisibleReminderDate == isInVisibleReminderDate)&&(identical(other.isInVisiblePillNumber, isInVisiblePillNumber) || other.isInVisiblePillNumber == isInVisiblePillNumber)&&(identical(other.isInVisibleDescription, isInVisibleDescription) || other.isInVisibleDescription == isInVisibleDescription)&&(identical(other.dailyTakenMessage, dailyTakenMessage) || other.dailyTakenMessage == dailyTakenMessage)&&(identical(other.missedTakenMessage, missedTakenMessage) || other.missedTakenMessage == missedTakenMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,word,isInVisibleReminderDate,isInVisiblePillNumber,isInVisibleDescription,dailyTakenMessage,missedTakenMessage);

@override
String toString() {
  return 'ReminderNotificationCustomization(version: $version, word: $word, isInVisibleReminderDate: $isInVisibleReminderDate, isInVisiblePillNumber: $isInVisiblePillNumber, isInVisibleDescription: $isInVisibleDescription, dailyTakenMessage: $dailyTakenMessage, missedTakenMessage: $missedTakenMessage)';
}


}

/// @nodoc
abstract mixin class _$ReminderNotificationCustomizationCopyWith<$Res> implements $ReminderNotificationCustomizationCopyWith<$Res> {
  factory _$ReminderNotificationCustomizationCopyWith(_ReminderNotificationCustomization value, $Res Function(_ReminderNotificationCustomization) _then) = __$ReminderNotificationCustomizationCopyWithImpl;
@override @useResult
$Res call({
 String version, String word, bool isInVisibleReminderDate, bool isInVisiblePillNumber, bool isInVisibleDescription, String dailyTakenMessage, String missedTakenMessage
});




}
/// @nodoc
class __$ReminderNotificationCustomizationCopyWithImpl<$Res>
    implements _$ReminderNotificationCustomizationCopyWith<$Res> {
  __$ReminderNotificationCustomizationCopyWithImpl(this._self, this._then);

  final _ReminderNotificationCustomization _self;
  final $Res Function(_ReminderNotificationCustomization) _then;

/// Create a copy of ReminderNotificationCustomization
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? word = null,Object? isInVisibleReminderDate = null,Object? isInVisiblePillNumber = null,Object? isInVisibleDescription = null,Object? dailyTakenMessage = null,Object? missedTakenMessage = null,}) {
  return _then(_ReminderNotificationCustomization(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,isInVisibleReminderDate: null == isInVisibleReminderDate ? _self.isInVisibleReminderDate : isInVisibleReminderDate // ignore: cast_nullable_to_non_nullable
as bool,isInVisiblePillNumber: null == isInVisiblePillNumber ? _self.isInVisiblePillNumber : isInVisiblePillNumber // ignore: cast_nullable_to_non_nullable
as bool,isInVisibleDescription: null == isInVisibleDescription ? _self.isInVisibleDescription : isInVisibleDescription // ignore: cast_nullable_to_non_nullable
as bool,dailyTakenMessage: null == dailyTakenMessage ? _self.dailyTakenMessage : dailyTakenMessage // ignore: cast_nullable_to_non_nullable
as String,missedTakenMessage: null == missedTakenMessage ? _self.missedTakenMessage : missedTakenMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
