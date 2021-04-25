// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'post_diary_store_provider_family.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PostDiaryStoreProviderFamilyTearOff {
  const _$PostDiaryStoreProviderFamilyTearOff();

  _PostDiaryStoreProviderFamily call(
      {required DateTime date, required Diary? diary}) {
    return _PostDiaryStoreProviderFamily(
      date: date,
      diary: diary,
    );
  }
}

/// @nodoc
const $PostDiaryStoreProviderFamily = _$PostDiaryStoreProviderFamilyTearOff();

/// @nodoc
mixin _$PostDiaryStoreProviderFamily {
  DateTime get date => throw _privateConstructorUsedError;
  Diary? get diary => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PostDiaryStoreProviderFamilyCopyWith<PostDiaryStoreProviderFamily>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostDiaryStoreProviderFamilyCopyWith<$Res> {
  factory $PostDiaryStoreProviderFamilyCopyWith(
          PostDiaryStoreProviderFamily value,
          $Res Function(PostDiaryStoreProviderFamily) then) =
      _$PostDiaryStoreProviderFamilyCopyWithImpl<$Res>;
  $Res call({DateTime date, Diary? diary});

  $DiaryCopyWith<$Res>? get diary;
}

/// @nodoc
class _$PostDiaryStoreProviderFamilyCopyWithImpl<$Res>
    implements $PostDiaryStoreProviderFamilyCopyWith<$Res> {
  _$PostDiaryStoreProviderFamilyCopyWithImpl(this._value, this._then);

  final PostDiaryStoreProviderFamily _value;
  // ignore: unused_field
  final $Res Function(PostDiaryStoreProviderFamily) _then;

  @override
  $Res call({
    Object? date = freezed,
    Object? diary = freezed,
  }) {
    return _then(_value.copyWith(
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      diary: diary == freezed
          ? _value.diary
          : diary // ignore: cast_nullable_to_non_nullable
              as Diary?,
    ));
  }

  @override
  $DiaryCopyWith<$Res>? get diary {
    if (_value.diary == null) {
      return null;
    }

    return $DiaryCopyWith<$Res>(_value.diary!, (value) {
      return _then(_value.copyWith(diary: value));
    });
  }
}

/// @nodoc
abstract class _$PostDiaryStoreProviderFamilyCopyWith<$Res>
    implements $PostDiaryStoreProviderFamilyCopyWith<$Res> {
  factory _$PostDiaryStoreProviderFamilyCopyWith(
          _PostDiaryStoreProviderFamily value,
          $Res Function(_PostDiaryStoreProviderFamily) then) =
      __$PostDiaryStoreProviderFamilyCopyWithImpl<$Res>;
  @override
  $Res call({DateTime date, Diary? diary});

  @override
  $DiaryCopyWith<$Res>? get diary;
}

/// @nodoc
class __$PostDiaryStoreProviderFamilyCopyWithImpl<$Res>
    extends _$PostDiaryStoreProviderFamilyCopyWithImpl<$Res>
    implements _$PostDiaryStoreProviderFamilyCopyWith<$Res> {
  __$PostDiaryStoreProviderFamilyCopyWithImpl(
      _PostDiaryStoreProviderFamily _value,
      $Res Function(_PostDiaryStoreProviderFamily) _then)
      : super(_value, (v) => _then(v as _PostDiaryStoreProviderFamily));

  @override
  _PostDiaryStoreProviderFamily get _value =>
      super._value as _PostDiaryStoreProviderFamily;

  @override
  $Res call({
    Object? date = freezed,
    Object? diary = freezed,
  }) {
    return _then(_PostDiaryStoreProviderFamily(
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      diary: diary == freezed
          ? _value.diary
          : diary // ignore: cast_nullable_to_non_nullable
              as Diary?,
    ));
  }
}

/// @nodoc
class _$_PostDiaryStoreProviderFamily implements _PostDiaryStoreProviderFamily {
  _$_PostDiaryStoreProviderFamily({required this.date, required this.diary});

  @override
  final DateTime date;
  @override
  final Diary? diary;

  @override
  String toString() {
    return 'PostDiaryStoreProviderFamily(date: $date, diary: $diary)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PostDiaryStoreProviderFamily &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(other.diary, diary) ||
                const DeepCollectionEquality().equals(other.diary, diary)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(diary);

  @JsonKey(ignore: true)
  @override
  _$PostDiaryStoreProviderFamilyCopyWith<_PostDiaryStoreProviderFamily>
      get copyWith => __$PostDiaryStoreProviderFamilyCopyWithImpl<
          _PostDiaryStoreProviderFamily>(this, _$identity);
}

abstract class _PostDiaryStoreProviderFamily
    implements PostDiaryStoreProviderFamily {
  factory _PostDiaryStoreProviderFamily(
      {required DateTime date,
      required Diary? diary}) = _$_PostDiaryStoreProviderFamily;

  @override
  DateTime get date => throw _privateConstructorUsedError;
  @override
  Diary? get diary => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$PostDiaryStoreProviderFamilyCopyWith<_PostDiaryStoreProviderFamily>
      get copyWith => throw _privateConstructorUsedError;
}
