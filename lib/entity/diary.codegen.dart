```dart
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'diary.codegen.g.dart';
part 'diary.codegen.freezed.dart';

/// Firestoreにおけるdiaryコレクションのフィールド名を定義するクラス
/// 
/// クエリ作成やデータ取得時の定数として使用し、
/// フィールド名のタイポや変更時の影響範囲を最小化する
class DiaryFirestoreKey {
  /// 日記の日付フィールド名
  /// 
  /// Firestoreでの日付範囲検索やソート時に使用される
  /// 例：date >= 2023-01-01 AND date <= 2023-01-31
  static const String date = 'date';
}

/// ユーザーの体調状態を表すEnum
/// 
/// 日記記録において、その日の全体的な体調を2段階で評価する
/// 詳細な体調症状は[Diary.physicalConditions]で管理される
enum PhysicalConditionStatus {
  /// 体調良好
  /// 
  /// ピルの副作用や体調不良がない状態を表す
  fine,
  
  /// 体調不良
  /// 
  /// ピルの副作用や何らかの体調不良がある状態を表す
  /// 具体的な症状は[Diary.physicalConditions]で詳細管理される
  bad
}

/// ユーザーの日々の体調記録を管理するEntityクラス
/// 
/// Pilllアプリにおける日記機能の中核となるデータ構造で、
/// ピル服用に伴う体調変化や生理周期との関連性を記録・分析するために使用される。
/// 
/// ## Firestoreコレクション構造
/// - コレクション: `users/{userId}/diaries`
/// - ドキュメントID: `Diary_{yyyyMMdd}` (例: Diary_20230101)
/// - 一日につき一つのドキュメントが作成される
/// 
/// ## 主な用途
/// - ピル服用時の副作用記録
/// - 生理周期と体調の関連性分析
/// - 長期的な体調変化の傾向把握
/// - 医療機関での相談時の資料
/// 
/// ## 関連Entity
/// - [DiarySetting]: 体調選択肢の設定管理
/// - [PillSheet]: ピル服用記録との関連性
/// - [Menstruation]: 生理記録との関連性
@freezed
class Diary with _$Diary {
  /// Firestoreドキュメントの一意識別子
  /// 
  /// フォーマット: `Diary_{yyyyMMdd}`
  /// 例: 2023年1月1日 → "Diary_20230101"
  /// 
  /// この識別子により、日付ベースでのドキュメント管理と
  /// 高速な日付範囲検索を実現している
  String get id => 'Diary_${DateTimeFormatter.diaryIdentifier(date)}';

  @JsonSerializable(explicitToJson: true)
  const factory Diary({
    /// 日記の対象日付
    /// 
    /// この日記エントリが記録する日付を表す。
    /// 一日につき一つのDiaryエントリが作成される。
    /// 
    /// - Firestoreでは時刻情報も含むTimestamp形式で保存
    /// - UI表示時は日付部分のみ使用（時刻部分は無視）
    /// - 日付範囲検索のメインキーとして使用
    /// 
    /// ## 注意点
    /// - タイムゾーンの考慮が必要
    /// - 日付が重複しないよう、アプリ側で制御が必要
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime date,
    
    /// 日記エントリの作成日時
    /// 
    /// ユーザーが実際に日記を記録した日時を保存する。
    /// [date]とは異なり、記録作成のタイムスタンプを表す。
    /// 
    /// - 過去の日付について後から記録する場合、[date]と[createdAt]は異なる値になる
    /// - データ分析時に記録タイミングを把握するために使用
    /// - 古いデータとの互換性のためnullable（レガシーデータ対応）
    /// 
    /// ## 使用例
    /// - 1月1日の体調を1月5日に記録した場合
    ///   - date: 2023-01-01
    ///   - createdAt: 2023-01-05 14:30:00
    // NOTE: OLD data does't have createdAt
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    required DateTime? createdAt,
    
    /// その日の全般的な体調状態
    /// 
    /// ユーザーがその日の体調を大まかに評価したもの。
    /// - [PhysicalConditionStatus.fine]: 体調良好
    /// - [PhysicalConditionStatus.bad]: 体調不良
    /// - null: 未評価
    /// 
    /// ## 使用場面
    /// - カレンダーUIでの体調状態表示（アイコンや色分け）
    /// - 月間・週間の体調傾向分析
    /// - ピル服用と体調の相関関係把握
    /// 
    /// ## 詳細記録との関係
    /// この状態と[physicalConditions]の詳細記録は独立している。
    /// 詳細な症状があってもfine、症状がなくてもbadの場合がある。
    physicalConditionStatus,
    
    /// 具体的な体調症状のリスト
    /// 
    /// ユーザーがその日に感じた具体的な体調症状を記録する。
    /// [DiarySetting.physicalConditions]で定義された選択肢から複数選択可能。
    /// 
    /// ## デフォルト症状一覧
    /// - 頭痛、腹痛、吐き気、貧血、下痢、便秘
    /// - ほてり、眠気、腰痛、動悸、不正出血
    /// - 食欲不振、胸の張り、不眠
    /// 
    /// ## 分析での活用
    /// - ピル服用開始からの症状変化
    /// - 生理周期と症状の関連性
    /// - 季節や環境要因との相関関係
    /// 
    /// ## テスト時の考慮点
    /// - 空リスト[]と未選択状態の区別
    /// - 国際化対応（症状名の多言語化）
    required List<String> physicalConditions,
    
    /// その日に性行為があったかどうか
    /// 
    /// 妊娠リスクや生理周期の把握、避妊効果の確認のために記録される。
    /// - true: 性行為あり
    /// - false: 性行為なし
    /// 
    /// ## プライバシー配慮
    /// - 機密性の高い情報のため、厳重な管理が必要
    /// - ローカルでの暗号化や通信時の保護が重要
    /// 
    /// ## 医学的意義
    /// - ピルの避妊効果の確認
    /// - 妊娠可能性の把握
    /// - 生理不順との関連性分析
    /// - 医療相談時の重要な情報源
    required bool hasSex,
    
    /// 自由記述のメモ欄
    /// 
    /// 上記の構造化データでは表現しきれない、
    /// ユーザー独自の気づきや詳細な状況を記録するためのフィールド。
    /// 
    /// ## 典型的な記録内容
    /// - 症状の詳細説明："頭痛がひどく、薬を飲んだ"
    /// - 環境要因："仕事のストレスが多い日"
    /// - 服薬との関連："ピルを飲み忘れた翌日"
    /// - 生活習慣："運動した日"
    /// 
    /// ## データ処理上の注意
    /// - 最大文字数制限の考慮
    /// - 個人情報保護（氏名・連絡先等の混入防止）
    /// - 検索・分析機能での活用方法
    required String memo,
  }) = _Diary;
  
  const Diary._();

  /// 指定された日付で空の日記エントリを作成するファクトリメソッド
  /// 
  /// 新規日記作成時のデフォルト値を提供する。
  /// UIでの新規作成ダイアログや、一括初期化処理で使用される。
  /// 
  /// ## パラメータ
  /// - [date]: 日記の対象日付
  /// 
  /// ## デフォルト値
  /// - memo: 空文字列
  /// - createdAt: 現在時刻
  /// - physicalConditions: 空リスト
  /// - hasSex: false
  /// - physicalConditionStatus: null (未評価)
  factory Diary.fromDate(DateTime date) => Diary(date: date, memo: '', createdAt: now(), physicalConditions: [], hasSex: false);
  
  factory Diary.fromJson(Map<String, dynamic> json) => _$DiaryFromJson(json);
  
  /// 体調状態が評価済みかどうかを判定
  /// 
  /// [physicalConditionStatus]がnullでない場合にtrueを返す。
  /// UI上で体調評価の表示/非表示を切り替える際に使用される。
  /// 
  /// ## 使用例
  /// ```dart
  /// if (diary.hasPhysicalConditionStatus) {
  ///   // 体調アイコンを表示
  ///   showStatusIcon(diary.physicalConditionStatus!);
  /// }
  /// ```
  bool get hasPhysicalConditionStatus => physicalConditionStatus != null;
  
  /// 指定された体調状態と一致するかどうかを判定
  /// 
  /// 特定の体調状態でフィルタリングや集計を行う際に使用される。
  /// 
  /// ## パラメータ
  /// - [status]: 比較する体調状態
  /// 
  /// ## 戻り値
  /// - 現在の[physicalConditionStatus]と[status]が一致する場合true
  /// - [physicalConditionStatus]がnullの場合はfalse
  /// 
  /// ## 使用例
  /// ```dart
  /// final badDays = diaries.where((diary) => 
  ///   diary.hasPhysicalConditionStatusFor(PhysicalConditionStatus.bad)
  /// ).length;
  /// ```
  bool hasPhysicalConditionStatusFor(PhysicalConditionStatus status) => physicalConditionStatus == status;
}
```
