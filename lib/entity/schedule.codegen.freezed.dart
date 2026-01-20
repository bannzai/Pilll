// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Schedule _$ScheduleFromJson(Map<String, dynamic> json) {
  return _Schedule.fromJson(json);
}

/// @nodoc
mixin _$Schedule {
  /// ドキュメントID。Firestore保存時に自動設定される
  /// nullの場合は新規作成、値がある場合は既存ドキュメントの更新を示す
  @JsonKey(includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;

  /// 予定のタイトル。ユーザーが入力する予定名
  /// 例：「婦人科受診」「定期検診」など
  String get title => throw _privateConstructorUsedError;

  /// 予定日時。ユーザーがカレンダーUIで選択した日付
  /// Firestoreのタイムスタンプ形式で保存される
  @JsonKey(
    fromJson: NonNullTimestampConverter.timestampToDateTime,
    toJson: NonNullTimestampConverter.dateTimeToTimestamp,
  )
  DateTime get date => throw _privateConstructorUsedError;

  /// ローカル通知の設定。nullの場合は通知なし
  /// 予定前にリマインドを送るための設定
  LocalNotification? get localNotification =>
      throw _privateConstructorUsedError;

  /// 予定作成日時。レコード作成時の記録用
  /// データの管理やソート処理で使用される
  @JsonKey(
    fromJson: NonNullTimestampConverter.timestampToDateTime,
    toJson: NonNullTimestampConverter.dateTimeToTimestamp,
  )
  DateTime get createdDateTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScheduleCopyWith<Schedule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleCopyWith<$Res> {
  factory $ScheduleCopyWith(Schedule value, $Res Function(Schedule) then) =
      _$ScheduleCopyWithImpl<$Res, Schedule>;
  @useResult
  $Res call({
    @JsonKey(includeIfNull: false) String? id,
    String title,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    DateTime date,
    LocalNotification? localNotification,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    DateTime createdDateTime,
  });

  $LocalNotificationCopyWith<$Res>? get localNotification;
}

/// @nodoc
class _$ScheduleCopyWithImpl<$Res, $Val extends Schedule>
    implements $ScheduleCopyWith<$Res> {
  _$ScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? date = null,
    Object? localNotification = freezed,
    Object? createdDateTime = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            localNotification: freezed == localNotification
                ? _value.localNotification
                : localNotification // ignore: cast_nullable_to_non_nullable
                      as LocalNotification?,
            createdDateTime: null == createdDateTime
                ? _value.createdDateTime
                : createdDateTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  @override
  @pragma('vm:prefer-inline')
  $LocalNotificationCopyWith<$Res>? get localNotification {
    if (_value.localNotification == null) {
      return null;
    }

    return $LocalNotificationCopyWith<$Res>(_value.localNotification!, (value) {
      return _then(_value.copyWith(localNotification: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ScheduleImplCopyWith<$Res>
    implements $ScheduleCopyWith<$Res> {
  factory _$$ScheduleImplCopyWith(
    _$ScheduleImpl value,
    $Res Function(_$ScheduleImpl) then,
  ) = __$$ScheduleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(includeIfNull: false) String? id,
    String title,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    DateTime date,
    LocalNotification? localNotification,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    DateTime createdDateTime,
  });

  @override
  $LocalNotificationCopyWith<$Res>? get localNotification;
}

/// @nodoc
class __$$ScheduleImplCopyWithImpl<$Res>
    extends _$ScheduleCopyWithImpl<$Res, _$ScheduleImpl>
    implements _$$ScheduleImplCopyWith<$Res> {
  __$$ScheduleImplCopyWithImpl(
    _$ScheduleImpl _value,
    $Res Function(_$ScheduleImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? date = null,
    Object? localNotification = freezed,
    Object? createdDateTime = null,
  }) {
    return _then(
      _$ScheduleImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        localNotification: freezed == localNotification
            ? _value.localNotification
            : localNotification // ignore: cast_nullable_to_non_nullable
                  as LocalNotification?,
        createdDateTime: null == createdDateTime
            ? _value.createdDateTime
            : createdDateTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$ScheduleImpl extends _Schedule {
  const _$ScheduleImpl({
    @JsonKey(includeIfNull: false) this.id,
    required this.title,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required this.date,
    this.localNotification,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required this.createdDateTime,
  }) : super._();

  factory _$ScheduleImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScheduleImplFromJson(json);

  /// ドキュメントID。Firestore保存時に自動設定される
  /// nullの場合は新規作成、値がある場合は既存ドキュメントの更新を示す
  @override
  @JsonKey(includeIfNull: false)
  final String? id;

  /// 予定のタイトル。ユーザーが入力する予定名
  /// 例：「婦人科受診」「定期検診」など
  @override
  final String title;

  /// 予定日時。ユーザーがカレンダーUIで選択した日付
  /// Firestoreのタイムスタンプ形式で保存される
  @override
  @JsonKey(
    fromJson: NonNullTimestampConverter.timestampToDateTime,
    toJson: NonNullTimestampConverter.dateTimeToTimestamp,
  )
  final DateTime date;

  /// ローカル通知の設定。nullの場合は通知なし
  /// 予定前にリマインドを送るための設定
  @override
  final LocalNotification? localNotification;

  /// 予定作成日時。レコード作成時の記録用
  /// データの管理やソート処理で使用される
  @override
  @JsonKey(
    fromJson: NonNullTimestampConverter.timestampToDateTime,
    toJson: NonNullTimestampConverter.dateTimeToTimestamp,
  )
  final DateTime createdDateTime;

  @override
  String toString() {
    return 'Schedule(id: $id, title: $title, date: $date, localNotification: $localNotification, createdDateTime: $createdDateTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.localNotification, localNotification) ||
                other.localNotification == localNotification) &&
            (identical(other.createdDateTime, createdDateTime) ||
                other.createdDateTime == createdDateTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    date,
    localNotification,
    createdDateTime,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleImplCopyWith<_$ScheduleImpl> get copyWith =>
      __$$ScheduleImplCopyWithImpl<_$ScheduleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduleImplToJson(this);
  }
}

abstract class _Schedule extends Schedule {
  const factory _Schedule({
    @JsonKey(includeIfNull: false) final String? id,
    required final String title,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required final DateTime date,
    final LocalNotification? localNotification,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required final DateTime createdDateTime,
  }) = _$ScheduleImpl;
  const _Schedule._() : super._();

  factory _Schedule.fromJson(Map<String, dynamic> json) =
      _$ScheduleImpl.fromJson;

  @override
  /// ドキュメントID。Firestore保存時に自動設定される
  /// nullの場合は新規作成、値がある場合は既存ドキュメントの更新を示す
  @JsonKey(includeIfNull: false)
  String? get id;
  @override
  /// 予定のタイトル。ユーザーが入力する予定名
  /// 例：「婦人科受診」「定期検診」など
  String get title;
  @override
  /// 予定日時。ユーザーがカレンダーUIで選択した日付
  /// Firestoreのタイムスタンプ形式で保存される
  @JsonKey(
    fromJson: NonNullTimestampConverter.timestampToDateTime,
    toJson: NonNullTimestampConverter.dateTimeToTimestamp,
  )
  DateTime get date;
  @override
  /// ローカル通知の設定。nullの場合は通知なし
  /// 予定前にリマインドを送るための設定
  LocalNotification? get localNotification;
  @override
  /// 予定作成日時。レコード作成時の記録用
  /// データの管理やソート処理で使用される
  @JsonKey(
    fromJson: NonNullTimestampConverter.timestampToDateTime,
    toJson: NonNullTimestampConverter.dateTimeToTimestamp,
  )
  DateTime get createdDateTime;
  @override
  @JsonKey(ignore: true)
  _$$ScheduleImplCopyWith<_$ScheduleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LocalNotification _$LocalNotificationFromJson(Map<String, dynamic> json) {
  return _LocalNotification.fromJson(json);
}

/// @nodoc
mixin _$LocalNotification {
  /// flutter_local_notificationsプラグインで使用する通知ID
  /// 通知のキャンセルや更新時に必要な一意識別子
  int get localNotificationID => throw _privateConstructorUsedError;

  /// 通知を送信する日時
  /// ユーザーが設定したリマインド時刻に基づいて計算される
  @JsonKey(
    fromJson: NonNullTimestampConverter.timestampToDateTime,
    toJson: NonNullTimestampConverter.dateTimeToTimestamp,
  )
  DateTime get remindDateTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LocalNotificationCopyWith<LocalNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalNotificationCopyWith<$Res> {
  factory $LocalNotificationCopyWith(
    LocalNotification value,
    $Res Function(LocalNotification) then,
  ) = _$LocalNotificationCopyWithImpl<$Res, LocalNotification>;
  @useResult
  $Res call({
    int localNotificationID,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    DateTime remindDateTime,
  });
}

/// @nodoc
class _$LocalNotificationCopyWithImpl<$Res, $Val extends LocalNotification>
    implements $LocalNotificationCopyWith<$Res> {
  _$LocalNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localNotificationID = null,
    Object? remindDateTime = null,
  }) {
    return _then(
      _value.copyWith(
            localNotificationID: null == localNotificationID
                ? _value.localNotificationID
                : localNotificationID // ignore: cast_nullable_to_non_nullable
                      as int,
            remindDateTime: null == remindDateTime
                ? _value.remindDateTime
                : remindDateTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LocalNotificationImplCopyWith<$Res>
    implements $LocalNotificationCopyWith<$Res> {
  factory _$$LocalNotificationImplCopyWith(
    _$LocalNotificationImpl value,
    $Res Function(_$LocalNotificationImpl) then,
  ) = __$$LocalNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int localNotificationID,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    DateTime remindDateTime,
  });
}

/// @nodoc
class __$$LocalNotificationImplCopyWithImpl<$Res>
    extends _$LocalNotificationCopyWithImpl<$Res, _$LocalNotificationImpl>
    implements _$$LocalNotificationImplCopyWith<$Res> {
  __$$LocalNotificationImplCopyWithImpl(
    _$LocalNotificationImpl _value,
    $Res Function(_$LocalNotificationImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localNotificationID = null,
    Object? remindDateTime = null,
  }) {
    return _then(
      _$LocalNotificationImpl(
        localNotificationID: null == localNotificationID
            ? _value.localNotificationID
            : localNotificationID // ignore: cast_nullable_to_non_nullable
                  as int,
        remindDateTime: null == remindDateTime
            ? _value.remindDateTime
            : remindDateTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$LocalNotificationImpl extends _LocalNotification {
  const _$LocalNotificationImpl({
    required this.localNotificationID,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required this.remindDateTime,
  }) : super._();

  factory _$LocalNotificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocalNotificationImplFromJson(json);

  /// flutter_local_notificationsプラグインで使用する通知ID
  /// 通知のキャンセルや更新時に必要な一意識別子
  @override
  final int localNotificationID;

  /// 通知を送信する日時
  /// ユーザーが設定したリマインド時刻に基づいて計算される
  @override
  @JsonKey(
    fromJson: NonNullTimestampConverter.timestampToDateTime,
    toJson: NonNullTimestampConverter.dateTimeToTimestamp,
  )
  final DateTime remindDateTime;

  @override
  String toString() {
    return 'LocalNotification(localNotificationID: $localNotificationID, remindDateTime: $remindDateTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocalNotificationImpl &&
            (identical(other.localNotificationID, localNotificationID) ||
                other.localNotificationID == localNotificationID) &&
            (identical(other.remindDateTime, remindDateTime) ||
                other.remindDateTime == remindDateTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, localNotificationID, remindDateTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LocalNotificationImplCopyWith<_$LocalNotificationImpl> get copyWith =>
      __$$LocalNotificationImplCopyWithImpl<_$LocalNotificationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LocalNotificationImplToJson(this);
  }
}

abstract class _LocalNotification extends LocalNotification {
  const factory _LocalNotification({
    required final int localNotificationID,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required final DateTime remindDateTime,
  }) = _$LocalNotificationImpl;
  const _LocalNotification._() : super._();

  factory _LocalNotification.fromJson(Map<String, dynamic> json) =
      _$LocalNotificationImpl.fromJson;

  @override
  /// flutter_local_notificationsプラグインで使用する通知ID
  /// 通知のキャンセルや更新時に必要な一意識別子
  int get localNotificationID;
  @override
  /// 通知を送信する日時
  /// ユーザーが設定したリマインド時刻に基づいて計算される
  @JsonKey(
    fromJson: NonNullTimestampConverter.timestampToDateTime,
    toJson: NonNullTimestampConverter.dateTimeToTimestamp,
  )
  DateTime get remindDateTime;
  @override
  @JsonKey(ignore: true)
  _$$LocalNotificationImplCopyWith<_$LocalNotificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
