// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder_notification_customization.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReminderNotificationCustomization _$ReminderNotificationCustomizationFromJson(
    Map<String, dynamic> json) {
  return _ReminderNotificationCustomization.fromJson(json);
}

/// @nodoc
mixin _$ReminderNotificationCustomization {
  String get word => throw _privateConstructorUsedError;
  bool get isInVisibleReminderDate => throw _privateConstructorUsedError;
  bool get isInVisiblePillNumber => throw _privateConstructorUsedError;
  bool get isInVisibleDescription => throw _privateConstructorUsedError;

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
      _$ReminderNotificationCustomizationCopyWithImpl<$Res,
          ReminderNotificationCustomization>;
  @useResult
  $Res call(
      {String word,
      bool isInVisibleReminderDate,
      bool isInVisiblePillNumber,
      bool isInVisibleDescription});
}

/// @nodoc
class _$ReminderNotificationCustomizationCopyWithImpl<$Res,
        $Val extends ReminderNotificationCustomization>
    implements $ReminderNotificationCustomizationCopyWith<$Res> {
  _$ReminderNotificationCustomizationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? word = null,
    Object? isInVisibleReminderDate = null,
    Object? isInVisiblePillNumber = null,
    Object? isInVisibleDescription = null,
  }) {
    return _then(_value.copyWith(
      word: null == word
          ? _value.word
          : word // ignore: cast_nullable_to_non_nullable
              as String,
      isInVisibleReminderDate: null == isInVisibleReminderDate
          ? _value.isInVisibleReminderDate
          : isInVisibleReminderDate // ignore: cast_nullable_to_non_nullable
              as bool,
      isInVisiblePillNumber: null == isInVisiblePillNumber
          ? _value.isInVisiblePillNumber
          : isInVisiblePillNumber // ignore: cast_nullable_to_non_nullable
              as bool,
      isInVisibleDescription: null == isInVisibleDescription
          ? _value.isInVisibleDescription
          : isInVisibleDescription // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReminderNotificationCustomizationImplCopyWith<$Res>
    implements $ReminderNotificationCustomizationCopyWith<$Res> {
  factory _$$ReminderNotificationCustomizationImplCopyWith(
          _$ReminderNotificationCustomizationImpl value,
          $Res Function(_$ReminderNotificationCustomizationImpl) then) =
      __$$ReminderNotificationCustomizationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String word,
      bool isInVisibleReminderDate,
      bool isInVisiblePillNumber,
      bool isInVisibleDescription});
}

/// @nodoc
class __$$ReminderNotificationCustomizationImplCopyWithImpl<$Res>
    extends _$ReminderNotificationCustomizationCopyWithImpl<$Res,
        _$ReminderNotificationCustomizationImpl>
    implements _$$ReminderNotificationCustomizationImplCopyWith<$Res> {
  __$$ReminderNotificationCustomizationImplCopyWithImpl(
      _$ReminderNotificationCustomizationImpl _value,
      $Res Function(_$ReminderNotificationCustomizationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? word = null,
    Object? isInVisibleReminderDate = null,
    Object? isInVisiblePillNumber = null,
    Object? isInVisibleDescription = null,
  }) {
    return _then(_$ReminderNotificationCustomizationImpl(
      word: null == word
          ? _value.word
          : word // ignore: cast_nullable_to_non_nullable
              as String,
      isInVisibleReminderDate: null == isInVisibleReminderDate
          ? _value.isInVisibleReminderDate
          : isInVisibleReminderDate // ignore: cast_nullable_to_non_nullable
              as bool,
      isInVisiblePillNumber: null == isInVisiblePillNumber
          ? _value.isInVisiblePillNumber
          : isInVisiblePillNumber // ignore: cast_nullable_to_non_nullable
              as bool,
      isInVisibleDescription: null == isInVisibleDescription
          ? _value.isInVisibleDescription
          : isInVisibleDescription // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$ReminderNotificationCustomizationImpl
    extends _ReminderNotificationCustomization {
  const _$ReminderNotificationCustomizationImpl(
      {this.word = pillEmoji,
      this.isInVisibleReminderDate = false,
      this.isInVisiblePillNumber = false,
      this.isInVisibleDescription = false})
      : super._();

  factory _$ReminderNotificationCustomizationImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ReminderNotificationCustomizationImplFromJson(json);

  @override
  @JsonKey()
  final String word;
  @override
  @JsonKey()
  final bool isInVisibleReminderDate;
  @override
  @JsonKey()
  final bool isInVisiblePillNumber;
  @override
  @JsonKey()
  final bool isInVisibleDescription;

  @override
  String toString() {
    return 'ReminderNotificationCustomization(word: $word, isInVisibleReminderDate: $isInVisibleReminderDate, isInVisiblePillNumber: $isInVisiblePillNumber, isInVisibleDescription: $isInVisibleDescription)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReminderNotificationCustomizationImpl &&
            (identical(other.word, word) || other.word == word) &&
            (identical(
                    other.isInVisibleReminderDate, isInVisibleReminderDate) ||
                other.isInVisibleReminderDate == isInVisibleReminderDate) &&
            (identical(other.isInVisiblePillNumber, isInVisiblePillNumber) ||
                other.isInVisiblePillNumber == isInVisiblePillNumber) &&
            (identical(other.isInVisibleDescription, isInVisibleDescription) ||
                other.isInVisibleDescription == isInVisibleDescription));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, word, isInVisibleReminderDate,
      isInVisiblePillNumber, isInVisibleDescription);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReminderNotificationCustomizationImplCopyWith<
          _$ReminderNotificationCustomizationImpl>
      get copyWith => __$$ReminderNotificationCustomizationImplCopyWithImpl<
          _$ReminderNotificationCustomizationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReminderNotificationCustomizationImplToJson(
      this,
    );
  }
}

abstract class _ReminderNotificationCustomization
    extends ReminderNotificationCustomization {
  const factory _ReminderNotificationCustomization(
          {final String word,
          final bool isInVisibleReminderDate,
          final bool isInVisiblePillNumber,
          final bool isInVisibleDescription}) =
      _$ReminderNotificationCustomizationImpl;
  const _ReminderNotificationCustomization._() : super._();

  factory _ReminderNotificationCustomization.fromJson(
          Map<String, dynamic> json) =
      _$ReminderNotificationCustomizationImpl.fromJson;

  @override
  String get word;
  @override
  bool get isInVisibleReminderDate;
  @override
  bool get isInVisiblePillNumber;
  @override
  bool get isInVisibleDescription;
  @override
  @JsonKey(ignore: true)
  _$$ReminderNotificationCustomizationImplCopyWith<
          _$ReminderNotificationCustomizationImpl>
      get copyWith => throw _privateConstructorUsedError;
}
