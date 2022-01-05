// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'reminder_notification_customization.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ReminderNotificationCustomization _$ReminderNotificationCustomizationFromJson(
    Map<String, dynamic> json) {
  return _ReminderNotificationCustomization.fromJson(json);
}

/// @nodoc
class _$ReminderNotificationCustomizationTearOff {
  const _$ReminderNotificationCustomizationTearOff();

  _ReminderNotificationCustomization call({String word = pill}) {
    return _ReminderNotificationCustomization(
      word: word,
    );
  }

  ReminderNotificationCustomization fromJson(Map<String, Object?> json) {
    return ReminderNotificationCustomization.fromJson(json);
  }
}

/// @nodoc
const $ReminderNotificationCustomization =
    _$ReminderNotificationCustomizationTearOff();

/// @nodoc
mixin _$ReminderNotificationCustomization {
  String get word => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReminderNotificationCustomizationCopyWith<ReminderNotificationCustomization>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReminderNotificationCustomizationCopyWith<$Res> {
  factory $ReminderNotificationCustomizationCopyWith(
          ReminderNotificationCustomization value,
          $Res Function(ReminderNotificationCustomization) then) =
      _$ReminderNotificationCustomizationCopyWithImpl<$Res>;
  $Res call({String word});
}

/// @nodoc
class _$ReminderNotificationCustomizationCopyWithImpl<$Res>
    implements $ReminderNotificationCustomizationCopyWith<$Res> {
  _$ReminderNotificationCustomizationCopyWithImpl(this._value, this._then);

  final ReminderNotificationCustomization _value;
  // ignore: unused_field
  final $Res Function(ReminderNotificationCustomization) _then;

  @override
  $Res call({
    Object? word = freezed,
  }) {
    return _then(_value.copyWith(
      word: word == freezed
          ? _value.word
          : word // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$ReminderNotificationCustomizationCopyWith<$Res>
    implements $ReminderNotificationCustomizationCopyWith<$Res> {
  factory _$ReminderNotificationCustomizationCopyWith(
          _ReminderNotificationCustomization value,
          $Res Function(_ReminderNotificationCustomization) then) =
      __$ReminderNotificationCustomizationCopyWithImpl<$Res>;
  @override
  $Res call({String word});
}

/// @nodoc
class __$ReminderNotificationCustomizationCopyWithImpl<$Res>
    extends _$ReminderNotificationCustomizationCopyWithImpl<$Res>
    implements _$ReminderNotificationCustomizationCopyWith<$Res> {
  __$ReminderNotificationCustomizationCopyWithImpl(
      _ReminderNotificationCustomization _value,
      $Res Function(_ReminderNotificationCustomization) _then)
      : super(_value, (v) => _then(v as _ReminderNotificationCustomization));

  @override
  _ReminderNotificationCustomization get _value =>
      super._value as _ReminderNotificationCustomization;

  @override
  $Res call({
    Object? word = freezed,
  }) {
    return _then(_ReminderNotificationCustomization(
      word: word == freezed
          ? _value.word
          : word // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_ReminderNotificationCustomization
    extends _ReminderNotificationCustomization {
  const _$_ReminderNotificationCustomization({this.word = pill}) : super._();

  factory _$_ReminderNotificationCustomization.fromJson(
          Map<String, dynamic> json) =>
      _$$_ReminderNotificationCustomizationFromJson(json);

  @JsonKey()
  @override
  final String word;

  @override
  String toString() {
    return 'ReminderNotificationCustomization(word: $word)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReminderNotificationCustomization &&
            const DeepCollectionEquality().equals(other.word, word));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(word));

  @JsonKey(ignore: true)
  @override
  _$ReminderNotificationCustomizationCopyWith<
          _ReminderNotificationCustomization>
      get copyWith => __$ReminderNotificationCustomizationCopyWithImpl<
          _ReminderNotificationCustomization>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ReminderNotificationCustomizationToJson(this);
  }
}

abstract class _ReminderNotificationCustomization
    extends ReminderNotificationCustomization {
  const factory _ReminderNotificationCustomization({String word}) =
      _$_ReminderNotificationCustomization;
  const _ReminderNotificationCustomization._() : super._();

  factory _ReminderNotificationCustomization.fromJson(
          Map<String, dynamic> json) =
      _$_ReminderNotificationCustomization.fromJson;

  @override
  String get word;
  @override
  @JsonKey(ignore: true)
  _$ReminderNotificationCustomizationCopyWith<
          _ReminderNotificationCustomization>
      get copyWith => throw _privateConstructorUsedError;
}
