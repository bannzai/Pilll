// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'notification_bar_store_parameter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$NotificationBarStoreParameterTearOff {
  const _$NotificationBarStoreParameterTearOff();

  _NotificationBarStoreParameter call(
      {required PillSheet? pillSheet,
      required int totalCountOfActionForTakenPill}) {
    return _NotificationBarStoreParameter(
      pillSheet: pillSheet,
      totalCountOfActionForTakenPill: totalCountOfActionForTakenPill,
    );
  }
}

/// @nodoc
const $NotificationBarStoreParameter = _$NotificationBarStoreParameterTearOff();

/// @nodoc
mixin _$NotificationBarStoreParameter {
  PillSheet? get pillSheet => throw _privateConstructorUsedError;
  int get totalCountOfActionForTakenPill => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NotificationBarStoreParameterCopyWith<NotificationBarStoreParameter>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationBarStoreParameterCopyWith<$Res> {
  factory $NotificationBarStoreParameterCopyWith(
          NotificationBarStoreParameter value,
          $Res Function(NotificationBarStoreParameter) then) =
      _$NotificationBarStoreParameterCopyWithImpl<$Res>;
  $Res call({PillSheet? pillSheet, int totalCountOfActionForTakenPill});

  $PillSheetCopyWith<$Res>? get pillSheet;
}

/// @nodoc
class _$NotificationBarStoreParameterCopyWithImpl<$Res>
    implements $NotificationBarStoreParameterCopyWith<$Res> {
  _$NotificationBarStoreParameterCopyWithImpl(this._value, this._then);

  final NotificationBarStoreParameter _value;
  // ignore: unused_field
  final $Res Function(NotificationBarStoreParameter) _then;

  @override
  $Res call({
    Object? pillSheet = freezed,
    Object? totalCountOfActionForTakenPill = freezed,
  }) {
    return _then(_value.copyWith(
      pillSheet: pillSheet == freezed
          ? _value.pillSheet
          : pillSheet // ignore: cast_nullable_to_non_nullable
              as PillSheet?,
      totalCountOfActionForTakenPill: totalCountOfActionForTakenPill == freezed
          ? _value.totalCountOfActionForTakenPill
          : totalCountOfActionForTakenPill // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  @override
  $PillSheetCopyWith<$Res>? get pillSheet {
    if (_value.pillSheet == null) {
      return null;
    }

    return $PillSheetCopyWith<$Res>(_value.pillSheet!, (value) {
      return _then(_value.copyWith(pillSheet: value));
    });
  }
}

/// @nodoc
abstract class _$NotificationBarStoreParameterCopyWith<$Res>
    implements $NotificationBarStoreParameterCopyWith<$Res> {
  factory _$NotificationBarStoreParameterCopyWith(
          _NotificationBarStoreParameter value,
          $Res Function(_NotificationBarStoreParameter) then) =
      __$NotificationBarStoreParameterCopyWithImpl<$Res>;
  @override
  $Res call({PillSheet? pillSheet, int totalCountOfActionForTakenPill});

  @override
  $PillSheetCopyWith<$Res>? get pillSheet;
}

/// @nodoc
class __$NotificationBarStoreParameterCopyWithImpl<$Res>
    extends _$NotificationBarStoreParameterCopyWithImpl<$Res>
    implements _$NotificationBarStoreParameterCopyWith<$Res> {
  __$NotificationBarStoreParameterCopyWithImpl(
      _NotificationBarStoreParameter _value,
      $Res Function(_NotificationBarStoreParameter) _then)
      : super(_value, (v) => _then(v as _NotificationBarStoreParameter));

  @override
  _NotificationBarStoreParameter get _value =>
      super._value as _NotificationBarStoreParameter;

  @override
  $Res call({
    Object? pillSheet = freezed,
    Object? totalCountOfActionForTakenPill = freezed,
  }) {
    return _then(_NotificationBarStoreParameter(
      pillSheet: pillSheet == freezed
          ? _value.pillSheet
          : pillSheet // ignore: cast_nullable_to_non_nullable
              as PillSheet?,
      totalCountOfActionForTakenPill: totalCountOfActionForTakenPill == freezed
          ? _value.totalCountOfActionForTakenPill
          : totalCountOfActionForTakenPill // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_NotificationBarStoreParameter
    implements _NotificationBarStoreParameter {
  _$_NotificationBarStoreParameter(
      {required this.pillSheet, required this.totalCountOfActionForTakenPill});

  @override
  final PillSheet? pillSheet;
  @override
  final int totalCountOfActionForTakenPill;

  @override
  String toString() {
    return 'NotificationBarStoreParameter(pillSheet: $pillSheet, totalCountOfActionForTakenPill: $totalCountOfActionForTakenPill)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _NotificationBarStoreParameter &&
            (identical(other.pillSheet, pillSheet) ||
                const DeepCollectionEquality()
                    .equals(other.pillSheet, pillSheet)) &&
            (identical(other.totalCountOfActionForTakenPill,
                    totalCountOfActionForTakenPill) ||
                const DeepCollectionEquality().equals(
                    other.totalCountOfActionForTakenPill,
                    totalCountOfActionForTakenPill)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(pillSheet) ^
      const DeepCollectionEquality().hash(totalCountOfActionForTakenPill);

  @JsonKey(ignore: true)
  @override
  _$NotificationBarStoreParameterCopyWith<_NotificationBarStoreParameter>
      get copyWith => __$NotificationBarStoreParameterCopyWithImpl<
          _NotificationBarStoreParameter>(this, _$identity);
}

abstract class _NotificationBarStoreParameter
    implements NotificationBarStoreParameter {
  factory _NotificationBarStoreParameter(
          {required PillSheet? pillSheet,
          required int totalCountOfActionForTakenPill}) =
      _$_NotificationBarStoreParameter;

  @override
  PillSheet? get pillSheet => throw _privateConstructorUsedError;
  @override
  int get totalCountOfActionForTakenPill => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$NotificationBarStoreParameterCopyWith<_NotificationBarStoreParameter>
      get copyWith => throw _privateConstructorUsedError;
}
