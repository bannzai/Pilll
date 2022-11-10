// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'pill_sheet_modified_history_state.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PillSheetModifiedHistoryState {
  bool get isFirstLoadEnded => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  List<PillSheetModifiedHistory> get pillSheetModifiedHistories =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PillSheetModifiedHistoryStateCopyWith<PillSheetModifiedHistoryState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PillSheetModifiedHistoryStateCopyWith<$Res> {
  factory $PillSheetModifiedHistoryStateCopyWith(
          PillSheetModifiedHistoryState value,
          $Res Function(PillSheetModifiedHistoryState) then) =
      _$PillSheetModifiedHistoryStateCopyWithImpl<$Res,
          PillSheetModifiedHistoryState>;
  @useResult
  $Res call(
      {bool isFirstLoadEnded,
      bool isLoading,
      List<PillSheetModifiedHistory> pillSheetModifiedHistories});
}

/// @nodoc
class _$PillSheetModifiedHistoryStateCopyWithImpl<$Res,
        $Val extends PillSheetModifiedHistoryState>
    implements $PillSheetModifiedHistoryStateCopyWith<$Res> {
  _$PillSheetModifiedHistoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isFirstLoadEnded = null,
    Object? isLoading = null,
    Object? pillSheetModifiedHistories = null,
  }) {
    return _then(_value.copyWith(
      isFirstLoadEnded: null == isFirstLoadEnded
          ? _value.isFirstLoadEnded
          : isFirstLoadEnded // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      pillSheetModifiedHistories: null == pillSheetModifiedHistories
          ? _value.pillSheetModifiedHistories
          : pillSheetModifiedHistories // ignore: cast_nullable_to_non_nullable
              as List<PillSheetModifiedHistory>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PillSheetModifiedHistoryStateCopyWith<$Res>
    implements $PillSheetModifiedHistoryStateCopyWith<$Res> {
  factory _$$_PillSheetModifiedHistoryStateCopyWith(
          _$_PillSheetModifiedHistoryState value,
          $Res Function(_$_PillSheetModifiedHistoryState) then) =
      __$$_PillSheetModifiedHistoryStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isFirstLoadEnded,
      bool isLoading,
      List<PillSheetModifiedHistory> pillSheetModifiedHistories});
}

/// @nodoc
class __$$_PillSheetModifiedHistoryStateCopyWithImpl<$Res>
    extends _$PillSheetModifiedHistoryStateCopyWithImpl<$Res,
        _$_PillSheetModifiedHistoryState>
    implements _$$_PillSheetModifiedHistoryStateCopyWith<$Res> {
  __$$_PillSheetModifiedHistoryStateCopyWithImpl(
      _$_PillSheetModifiedHistoryState _value,
      $Res Function(_$_PillSheetModifiedHistoryState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isFirstLoadEnded = null,
    Object? isLoading = null,
    Object? pillSheetModifiedHistories = null,
  }) {
    return _then(_$_PillSheetModifiedHistoryState(
      isFirstLoadEnded: null == isFirstLoadEnded
          ? _value.isFirstLoadEnded
          : isFirstLoadEnded // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      pillSheetModifiedHistories: null == pillSheetModifiedHistories
          ? _value._pillSheetModifiedHistories
          : pillSheetModifiedHistories // ignore: cast_nullable_to_non_nullable
              as List<PillSheetModifiedHistory>,
    ));
  }
}

/// @nodoc

class _$_PillSheetModifiedHistoryState extends _PillSheetModifiedHistoryState {
  const _$_PillSheetModifiedHistoryState(
      {this.isFirstLoadEnded = false,
      this.isLoading = false,
      final List<PillSheetModifiedHistory> pillSheetModifiedHistories =
          const []})
      : _pillSheetModifiedHistories = pillSheetModifiedHistories,
        super._();

  @override
  @JsonKey()
  final bool isFirstLoadEnded;
  @override
  @JsonKey()
  final bool isLoading;
  final List<PillSheetModifiedHistory> _pillSheetModifiedHistories;
  @override
  @JsonKey()
  List<PillSheetModifiedHistory> get pillSheetModifiedHistories {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pillSheetModifiedHistories);
  }

  @override
  String toString() {
    return 'PillSheetModifiedHistoryState(isFirstLoadEnded: $isFirstLoadEnded, isLoading: $isLoading, pillSheetModifiedHistories: $pillSheetModifiedHistories)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PillSheetModifiedHistoryState &&
            (identical(other.isFirstLoadEnded, isFirstLoadEnded) ||
                other.isFirstLoadEnded == isFirstLoadEnded) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(
                other._pillSheetModifiedHistories,
                _pillSheetModifiedHistories));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isFirstLoadEnded, isLoading,
      const DeepCollectionEquality().hash(_pillSheetModifiedHistories));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PillSheetModifiedHistoryStateCopyWith<_$_PillSheetModifiedHistoryState>
      get copyWith => __$$_PillSheetModifiedHistoryStateCopyWithImpl<
          _$_PillSheetModifiedHistoryState>(this, _$identity);
}

abstract class _PillSheetModifiedHistoryState
    extends PillSheetModifiedHistoryState {
  const factory _PillSheetModifiedHistoryState(
          {final bool isFirstLoadEnded,
          final bool isLoading,
          final List<PillSheetModifiedHistory> pillSheetModifiedHistories}) =
      _$_PillSheetModifiedHistoryState;
  const _PillSheetModifiedHistoryState._() : super._();

  @override
  bool get isFirstLoadEnded;
  @override
  bool get isLoading;
  @override
  List<PillSheetModifiedHistory> get pillSheetModifiedHistories;
  @override
  @JsonKey(ignore: true)
  _$$_PillSheetModifiedHistoryStateCopyWith<_$_PillSheetModifiedHistoryState>
      get copyWith => throw _privateConstructorUsedError;
}
