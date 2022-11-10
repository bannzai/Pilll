// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'menstruation_list_state.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MenstruationListState {
  bool get isNotYetLoaded => throw _privateConstructorUsedError;
  List<Menstruation> get allMenstruations => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MenstruationListStateCopyWith<MenstruationListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MenstruationListStateCopyWith<$Res> {
  factory $MenstruationListStateCopyWith(MenstruationListState value,
          $Res Function(MenstruationListState) then) =
      _$MenstruationListStateCopyWithImpl<$Res, MenstruationListState>;
  @useResult
  $Res call({bool isNotYetLoaded, List<Menstruation> allMenstruations});
}

/// @nodoc
class _$MenstruationListStateCopyWithImpl<$Res,
        $Val extends MenstruationListState>
    implements $MenstruationListStateCopyWith<$Res> {
  _$MenstruationListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isNotYetLoaded = null,
    Object? allMenstruations = null,
  }) {
    return _then(_value.copyWith(
      isNotYetLoaded: null == isNotYetLoaded
          ? _value.isNotYetLoaded
          : isNotYetLoaded // ignore: cast_nullable_to_non_nullable
              as bool,
      allMenstruations: null == allMenstruations
          ? _value.allMenstruations
          : allMenstruations // ignore: cast_nullable_to_non_nullable
              as List<Menstruation>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MenstruationListStateCopyWith<$Res>
    implements $MenstruationListStateCopyWith<$Res> {
  factory _$$_MenstruationListStateCopyWith(_$_MenstruationListState value,
          $Res Function(_$_MenstruationListState) then) =
      __$$_MenstruationListStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isNotYetLoaded, List<Menstruation> allMenstruations});
}

/// @nodoc
class __$$_MenstruationListStateCopyWithImpl<$Res>
    extends _$MenstruationListStateCopyWithImpl<$Res, _$_MenstruationListState>
    implements _$$_MenstruationListStateCopyWith<$Res> {
  __$$_MenstruationListStateCopyWithImpl(_$_MenstruationListState _value,
      $Res Function(_$_MenstruationListState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isNotYetLoaded = null,
    Object? allMenstruations = null,
  }) {
    return _then(_$_MenstruationListState(
      isNotYetLoaded: null == isNotYetLoaded
          ? _value.isNotYetLoaded
          : isNotYetLoaded // ignore: cast_nullable_to_non_nullable
              as bool,
      allMenstruations: null == allMenstruations
          ? _value._allMenstruations
          : allMenstruations // ignore: cast_nullable_to_non_nullable
              as List<Menstruation>,
    ));
  }
}

/// @nodoc

class _$_MenstruationListState extends _MenstruationListState {
  const _$_MenstruationListState(
      {this.isNotYetLoaded = true,
      final List<Menstruation> allMenstruations = const []})
      : _allMenstruations = allMenstruations,
        super._();

  @override
  @JsonKey()
  final bool isNotYetLoaded;
  final List<Menstruation> _allMenstruations;
  @override
  @JsonKey()
  List<Menstruation> get allMenstruations {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allMenstruations);
  }

  @override
  String toString() {
    return 'MenstruationListState(isNotYetLoaded: $isNotYetLoaded, allMenstruations: $allMenstruations)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MenstruationListState &&
            (identical(other.isNotYetLoaded, isNotYetLoaded) ||
                other.isNotYetLoaded == isNotYetLoaded) &&
            const DeepCollectionEquality()
                .equals(other._allMenstruations, _allMenstruations));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isNotYetLoaded,
      const DeepCollectionEquality().hash(_allMenstruations));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MenstruationListStateCopyWith<_$_MenstruationListState> get copyWith =>
      __$$_MenstruationListStateCopyWithImpl<_$_MenstruationListState>(
          this, _$identity);
}

abstract class _MenstruationListState extends MenstruationListState {
  const factory _MenstruationListState(
      {final bool isNotYetLoaded,
      final List<Menstruation> allMenstruations}) = _$_MenstruationListState;
  const _MenstruationListState._() : super._();

  @override
  bool get isNotYetLoaded;
  @override
  List<Menstruation> get allMenstruations;
  @override
  @JsonKey(ignore: true)
  _$$_MenstruationListStateCopyWith<_$_MenstruationListState> get copyWith =>
      throw _privateConstructorUsedError;
}
