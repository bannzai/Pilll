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

/// @nodoc
class _$ReminderNotificationCustomizationTearOff {
  const _$ReminderNotificationCustomizationTearOff();

  _ReminderNotificationCustomization call(
      {DateTime? beginTrialDate, String word = pill}) {
    return _ReminderNotificationCustomization(
      beginTrialDate: beginTrialDate,
      word: word,
    );
  }
}

/// @nodoc
const $ReminderNotificationCustomization =
    _$ReminderNotificationCustomizationTearOff();

/// @nodoc
mixin _$ReminderNotificationCustomization {
  DateTime? get beginTrialDate => throw _privateConstructorUsedError;
  String get word => throw _privateConstructorUsedError;

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
  $Res call({DateTime? beginTrialDate, String word});
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
    Object? beginTrialDate = freezed,
    Object? word = freezed,
  }) {
    return _then(_value.copyWith(
      beginTrialDate: beginTrialDate == freezed
          ? _value.beginTrialDate
          : beginTrialDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
  $Res call({DateTime? beginTrialDate, String word});
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
    Object? beginTrialDate = freezed,
    Object? word = freezed,
  }) {
    return _then(_ReminderNotificationCustomization(
      beginTrialDate: beginTrialDate == freezed
          ? _value.beginTrialDate
          : beginTrialDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
  const _$_ReminderNotificationCustomization(
      {this.beginTrialDate, this.word = pill})
      : super._();

  @override
  final DateTime? beginTrialDate;
  @JsonKey()
  @override
  final String word;

  @override
  String toString() {
    return 'ReminderNotificationCustomization(beginTrialDate: $beginTrialDate, word: $word)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReminderNotificationCustomization &&
            const DeepCollectionEquality()
                .equals(other.beginTrialDate, beginTrialDate) &&
            const DeepCollectionEquality().equals(other.word, word));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(beginTrialDate),
      const DeepCollectionEquality().hash(word));

  @JsonKey(ignore: true)
  @override
  _$ReminderNotificationCustomizationCopyWith<
          _ReminderNotificationCustomization>
      get copyWith => __$ReminderNotificationCustomizationCopyWithImpl<
          _ReminderNotificationCustomization>(this, _$identity);
}

abstract class _ReminderNotificationCustomization
    extends ReminderNotificationCustomization {
  const factory _ReminderNotificationCustomization(
      {DateTime? beginTrialDate,
      String word}) = _$_ReminderNotificationCustomization;
  const _ReminderNotificationCustomization._() : super._();

  @override
  DateTime? get beginTrialDate;
  @override
  String get word;
  @override
  @JsonKey(ignore: true)
  _$ReminderNotificationCustomizationCopyWith<
          _ReminderNotificationCustomization>
      get copyWith => throw _privateConstructorUsedError;
}
