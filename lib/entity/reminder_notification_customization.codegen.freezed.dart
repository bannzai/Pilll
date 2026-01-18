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
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReminderNotificationCustomization _$ReminderNotificationCustomizationFromJson(Map<String, dynamic> json) {
  return _ReminderNotificationCustomization.fromJson(json);
}

/// @nodoc
mixin _$ReminderNotificationCustomization {
  /// 設定のバージョン番号
  ///
  /// 新機能追加時の後方互換性を保つためのバージョン管理に使用されます。
  /// 現在の最新バージョンは'v2'です。
  String get version => throw _privateConstructorUsedError;

  /// 通知タイトルの冒頭に表示される文字
  ///
  /// 通知のタイトル部分に表示される絵文字や文字を設定します。
  /// デフォルトは💊絵文字が設定されています。
  String get word => throw _privateConstructorUsedError;

  /// 通知に日付表示を含めるかどうかの制御フラグ
  ///
  /// trueの場合、通知タイトルに日付（例: 8/14 (水)）を表示しません。
  /// falseの場合、通知タイトルに日付を表示します。
  bool get isInVisibleReminderDate => throw _privateConstructorUsedError;

  /// 通知にピル番号表示を含めるかどうかの制御フラグ
  ///
  /// trueの場合、通知タイトルにピル番号（例: 15番目）を表示しません。
  /// falseの場合、通知タイトルにピル番号を表示します。
  bool get isInVisiblePillNumber => throw _privateConstructorUsedError;

  /// 通知に説明文を含めるかどうかの制御フラグ
  ///
  /// trueの場合、通知の説明文（メッセージ本文）を表示しません。
  /// falseの場合、dailyTakenMessageまたはmissedTakenMessageが表示されます。
  bool get isInVisibleDescription => throw _privateConstructorUsedError; // BEGIN: From v2
  /// 日々の服用時に表示するメッセージ
  ///
  /// v2で追加された機能です。通常の服用リマインダー時に表示される
  /// カスタマイズ可能なメッセージです。
  String get dailyTakenMessage => throw _privateConstructorUsedError; // TODO: [Localizations]
  /// 飲み忘れ時に表示するメッセージ
  ///
  /// v2で追加された機能です。複数日の飲み忘れが検出された場合に
  /// 表示されるメッセージです。デフォルトでは🤔絵文字付きの
  /// 日本語メッセージが設定されています。
  String get missedTakenMessage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReminderNotificationCustomizationCopyWith<ReminderNotificationCustomization> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReminderNotificationCustomizationCopyWith<$Res> {
  factory $ReminderNotificationCustomizationCopyWith(ReminderNotificationCustomization value, $Res Function(ReminderNotificationCustomization) then) =
      _$ReminderNotificationCustomizationCopyWithImpl<$Res, ReminderNotificationCustomization>;
  @useResult
  $Res call({
    String version,
    String word,
    bool isInVisibleReminderDate,
    bool isInVisiblePillNumber,
    bool isInVisibleDescription,
    String dailyTakenMessage,
    String missedTakenMessage,
  });
}

/// @nodoc
class _$ReminderNotificationCustomizationCopyWithImpl<$Res, $Val extends ReminderNotificationCustomization>
    implements $ReminderNotificationCustomizationCopyWith<$Res> {
  _$ReminderNotificationCustomizationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? word = null,
    Object? isInVisibleReminderDate = null,
    Object? isInVisiblePillNumber = null,
    Object? isInVisibleDescription = null,
    Object? dailyTakenMessage = null,
    Object? missedTakenMessage = null,
  }) {
    return _then(
      _value.copyWith(
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as String,
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
            dailyTakenMessage: null == dailyTakenMessage
                ? _value.dailyTakenMessage
                : dailyTakenMessage // ignore: cast_nullable_to_non_nullable
                      as String,
            missedTakenMessage: null == missedTakenMessage
                ? _value.missedTakenMessage
                : missedTakenMessage // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReminderNotificationCustomizationImplCopyWith<$Res> implements $ReminderNotificationCustomizationCopyWith<$Res> {
  factory _$$ReminderNotificationCustomizationImplCopyWith(
    _$ReminderNotificationCustomizationImpl value,
    $Res Function(_$ReminderNotificationCustomizationImpl) then,
  ) = __$$ReminderNotificationCustomizationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String version,
    String word,
    bool isInVisibleReminderDate,
    bool isInVisiblePillNumber,
    bool isInVisibleDescription,
    String dailyTakenMessage,
    String missedTakenMessage,
  });
}

/// @nodoc
class __$$ReminderNotificationCustomizationImplCopyWithImpl<$Res>
    extends _$ReminderNotificationCustomizationCopyWithImpl<$Res, _$ReminderNotificationCustomizationImpl>
    implements _$$ReminderNotificationCustomizationImplCopyWith<$Res> {
  __$$ReminderNotificationCustomizationImplCopyWithImpl(
    _$ReminderNotificationCustomizationImpl _value,
    $Res Function(_$ReminderNotificationCustomizationImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? word = null,
    Object? isInVisibleReminderDate = null,
    Object? isInVisiblePillNumber = null,
    Object? isInVisibleDescription = null,
    Object? dailyTakenMessage = null,
    Object? missedTakenMessage = null,
  }) {
    return _then(
      _$ReminderNotificationCustomizationImpl(
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as String,
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
        dailyTakenMessage: null == dailyTakenMessage
            ? _value.dailyTakenMessage
            : dailyTakenMessage // ignore: cast_nullable_to_non_nullable
                  as String,
        missedTakenMessage: null == missedTakenMessage
            ? _value.missedTakenMessage
            : missedTakenMessage // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$ReminderNotificationCustomizationImpl extends _ReminderNotificationCustomization {
  const _$ReminderNotificationCustomizationImpl({
    this.version = 'v2',
    this.word = pillEmoji,
    this.isInVisibleReminderDate = false,
    this.isInVisiblePillNumber = false,
    this.isInVisibleDescription = false,
    this.dailyTakenMessage = '',
    this.missedTakenMessage = '飲み忘れていませんか？\n服用記録がない日が複数あります$thinkingFaceEmoji',
  }) : super._();

  factory _$ReminderNotificationCustomizationImpl.fromJson(Map<String, dynamic> json) => _$$ReminderNotificationCustomizationImplFromJson(json);

  /// 設定のバージョン番号
  ///
  /// 新機能追加時の後方互換性を保つためのバージョン管理に使用されます。
  /// 現在の最新バージョンは'v2'です。
  @override
  @JsonKey()
  final String version;

  /// 通知タイトルの冒頭に表示される文字
  ///
  /// 通知のタイトル部分に表示される絵文字や文字を設定します。
  /// デフォルトは💊絵文字が設定されています。
  @override
  @JsonKey()
  final String word;

  /// 通知に日付表示を含めるかどうかの制御フラグ
  ///
  /// trueの場合、通知タイトルに日付（例: 8/14 (水)）を表示しません。
  /// falseの場合、通知タイトルに日付を表示します。
  @override
  @JsonKey()
  final bool isInVisibleReminderDate;

  /// 通知にピル番号表示を含めるかどうかの制御フラグ
  ///
  /// trueの場合、通知タイトルにピル番号（例: 15番目）を表示しません。
  /// falseの場合、通知タイトルにピル番号を表示します。
  @override
  @JsonKey()
  final bool isInVisiblePillNumber;

  /// 通知に説明文を含めるかどうかの制御フラグ
  ///
  /// trueの場合、通知の説明文（メッセージ本文）を表示しません。
  /// falseの場合、dailyTakenMessageまたはmissedTakenMessageが表示されます。
  @override
  @JsonKey()
  final bool isInVisibleDescription;
  // BEGIN: From v2
  /// 日々の服用時に表示するメッセージ
  ///
  /// v2で追加された機能です。通常の服用リマインダー時に表示される
  /// カスタマイズ可能なメッセージです。
  @override
  @JsonKey()
  final String dailyTakenMessage;
  // TODO: [Localizations]
  /// 飲み忘れ時に表示するメッセージ
  ///
  /// v2で追加された機能です。複数日の飲み忘れが検出された場合に
  /// 表示されるメッセージです。デフォルトでは🤔絵文字付きの
  /// 日本語メッセージが設定されています。
  @override
  @JsonKey()
  final String missedTakenMessage;

  @override
  String toString() {
    return 'ReminderNotificationCustomization(version: $version, word: $word, isInVisibleReminderDate: $isInVisibleReminderDate, isInVisiblePillNumber: $isInVisiblePillNumber, isInVisibleDescription: $isInVisibleDescription, dailyTakenMessage: $dailyTakenMessage, missedTakenMessage: $missedTakenMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReminderNotificationCustomizationImpl &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.word, word) || other.word == word) &&
            (identical(other.isInVisibleReminderDate, isInVisibleReminderDate) || other.isInVisibleReminderDate == isInVisibleReminderDate) &&
            (identical(other.isInVisiblePillNumber, isInVisiblePillNumber) || other.isInVisiblePillNumber == isInVisiblePillNumber) &&
            (identical(other.isInVisibleDescription, isInVisibleDescription) || other.isInVisibleDescription == isInVisibleDescription) &&
            (identical(other.dailyTakenMessage, dailyTakenMessage) || other.dailyTakenMessage == dailyTakenMessage) &&
            (identical(other.missedTakenMessage, missedTakenMessage) || other.missedTakenMessage == missedTakenMessage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    version,
    word,
    isInVisibleReminderDate,
    isInVisiblePillNumber,
    isInVisibleDescription,
    dailyTakenMessage,
    missedTakenMessage,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReminderNotificationCustomizationImplCopyWith<_$ReminderNotificationCustomizationImpl> get copyWith =>
      __$$ReminderNotificationCustomizationImplCopyWithImpl<_$ReminderNotificationCustomizationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReminderNotificationCustomizationImplToJson(this);
  }
}

abstract class _ReminderNotificationCustomization extends ReminderNotificationCustomization {
  const factory _ReminderNotificationCustomization({
    final String version,
    final String word,
    final bool isInVisibleReminderDate,
    final bool isInVisiblePillNumber,
    final bool isInVisibleDescription,
    final String dailyTakenMessage,
    final String missedTakenMessage,
  }) = _$ReminderNotificationCustomizationImpl;
  const _ReminderNotificationCustomization._() : super._();

  factory _ReminderNotificationCustomization.fromJson(Map<String, dynamic> json) = _$ReminderNotificationCustomizationImpl.fromJson;

  @override
  /// 設定のバージョン番号
  ///
  /// 新機能追加時の後方互換性を保つためのバージョン管理に使用されます。
  /// 現在の最新バージョンは'v2'です。
  String get version;
  @override
  /// 通知タイトルの冒頭に表示される文字
  ///
  /// 通知のタイトル部分に表示される絵文字や文字を設定します。
  /// デフォルトは💊絵文字が設定されています。
  String get word;
  @override
  /// 通知に日付表示を含めるかどうかの制御フラグ
  ///
  /// trueの場合、通知タイトルに日付（例: 8/14 (水)）を表示しません。
  /// falseの場合、通知タイトルに日付を表示します。
  bool get isInVisibleReminderDate;
  @override
  /// 通知にピル番号表示を含めるかどうかの制御フラグ
  ///
  /// trueの場合、通知タイトルにピル番号（例: 15番目）を表示しません。
  /// falseの場合、通知タイトルにピル番号を表示します。
  bool get isInVisiblePillNumber;
  @override
  /// 通知に説明文を含めるかどうかの制御フラグ
  ///
  /// trueの場合、通知の説明文（メッセージ本文）を表示しません。
  /// falseの場合、dailyTakenMessageまたはmissedTakenMessageが表示されます。
  bool get isInVisibleDescription;
  @override // BEGIN: From v2
  /// 日々の服用時に表示するメッセージ
  ///
  /// v2で追加された機能です。通常の服用リマインダー時に表示される
  /// カスタマイズ可能なメッセージです。
  String get dailyTakenMessage;
  @override // TODO: [Localizations]
  /// 飲み忘れ時に表示するメッセージ
  ///
  /// v2で追加された機能です。複数日の飲み忘れが検出された場合に
  /// 表示されるメッセージです。デフォルトでは🤔絵文字付きの
  /// 日本語メッセージが設定されています。
  String get missedTakenMessage;
  @override
  @JsonKey(ignore: true)
  _$$ReminderNotificationCustomizationImplCopyWith<_$ReminderNotificationCustomizationImpl> get copyWith => throw _privateConstructorUsedError;
}
