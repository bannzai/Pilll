import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_af.dart';
import 'app_localizations_am.dart';
import 'app_localizations_ar.dart';
import 'app_localizations_as.dart';
import 'app_localizations_az.dart';
import 'app_localizations_be.dart';
import 'app_localizations_bg.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_bs.dart';
import 'app_localizations_ca.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_cy.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_et.dart';
import 'app_localizations_eu.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fil.dart';
import 'app_localizations_gl.dart';
import 'app_localizations_gsw.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_hy.dart';
import 'app_localizations_id.dart';
import 'app_localizations_is.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ka.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_km.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ky.dart';
import 'app_localizations_lo.dart';
import 'app_localizations_lt.dart';
import 'app_localizations_lv.dart';
import 'app_localizations_mk.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mn.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_my.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_ne.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_no.dart';
import 'app_localizations_or.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_ps.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_si.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_sl.dart';
import 'app_localizations_sq.dart';
import 'app_localizations_sr.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_sw.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tl.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_uz.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';
import 'app_localizations_zu.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('af'),
    Locale('am'),
    Locale('ar'),
    Locale('as'),
    Locale('az'),
    Locale('be'),
    Locale('bg'),
    Locale('bn'),
    Locale('bs'),
    Locale('ca'),
    Locale('cs'),
    Locale('cy'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('et'),
    Locale('eu'),
    Locale('fa'),
    Locale('fi'),
    Locale('fil'),
    Locale('gl'),
    Locale('gsw'),
    Locale('gu'),
    Locale('he'),
    Locale('hi'),
    Locale('hr'),
    Locale('hu'),
    Locale('hy'),
    Locale('id'),
    Locale('is'),
    Locale('it'),
    Locale('ja'),
    Locale('ka'),
    Locale('kk'),
    Locale('km'),
    Locale('kn'),
    Locale('ko'),
    Locale('ky'),
    Locale('lo'),
    Locale('lt'),
    Locale('lv'),
    Locale('mk'),
    Locale('ml'),
    Locale('mn'),
    Locale('mr'),
    Locale('ms'),
    Locale('my'),
    Locale('nb'),
    Locale('ne'),
    Locale('nl'),
    Locale('no'),
    Locale('or'),
    Locale('pa'),
    Locale('pl'),
    Locale('ps'),
    Locale('pt'),
    Locale('ro'),
    Locale('ru'),
    Locale('si'),
    Locale('sk'),
    Locale('sl'),
    Locale('sq'),
    Locale('sr'),
    Locale('sv'),
    Locale('sw'),
    Locale('ta'),
    Locale('te'),
    Locale('th'),
    Locale('tl'),
    Locale('tr'),
    Locale('uk'),
    Locale('ur'),
    Locale('uz'),
    Locale('vi'),
    Locale('zh'),
    Locale('zu')
  ];

  /// ピルシートの種類で、21錠の薬効成分を含む錠剤と7錠の偽薬（プラセボ）で構成される28錠パックのタイプです。アプリ内でユーザーがピルのタイプを選択する際に表示されます。
  ///
  /// In ja, this message translates to:
  /// **'21錠タイプ'**
  String get pillSheetType21With7Placebo;

  /// ピルシートの種類で、28錠の薬剤のうち24錠が薬効成分を含み4錠が偽薬（プラセボ）で構成されるタイプです。アプリ内でユーザーがピルのタイプを選択する際に表示される選択肢として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'28錠タイプ(4錠偽薬)'**
  String get pillSheetType28With4Placebo;

  /// ピルシートの種類で、28錠の薬剤のうち21錠が薬効成分を含み7錠が偽薬（プラセボ）で構成されるタイプです。アプリ内でユーザーがピルのタイプを選択する際に表示される選択肢として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'28錠タイプ(7錠偽薬)'**
  String get pillSheetType28With7Placebo;

  /// ピルシートの種類で、28錠すべてが薬効成分を含む実薬で構成されるタイプです。アプリ内でユーザーがピルのタイプを選択する際に表示される選択肢として使用され、プラセボ（偽薬）を含まない28錠タイプであることを示します。
  ///
  /// In ja, this message translates to:
  /// **'28錠タイプ(すべて実薬)'**
  String get pillSheetType28;

  /// ピルシートの種類で、24錠すべてが薬効成分を含む実薬で構成されるタイプです。アプリ内でユーザーがピルのタイプを選択する際に表示される選択肢として使用され、プラセボ（偽薬）を含まない24錠タイプであることを示します。
  ///
  /// In ja, this message translates to:
  /// **'24錠タイプ(すべて実薬)'**
  String get pillSheetType24;

  /// ピルシートの種類で、21錠すべてが薬効成分を含む実薬で構成されるタイプです。アプリ内でユーザーがピルのタイプを選択する際に表示される選択肢として使用され、プラセボ（偽薬）を含まない21錠タイプであることを示します。
  ///
  /// In ja, this message translates to:
  /// **'21錠タイプ(すべて実薬)'**
  String get pillSheetType21;

  /// ピルシートの種類で、24錠のうち20錠が薬効成分を含む実薬、4錠が休薬期間用のプラセボ錠（偽薬）で構成されるタイプです。アプリ内でユーザーがピルのタイプを選択する際に表示される選択肢として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'24錠タイプ'**
  String get pillSheetType24WithRest4;

  /// ピルの服用サイクル中の休薬期間を指す用語です。通常はプラセボ錠を服用するか薬を飲まない期間で、この期間中に生理が来ることが多いです。
  ///
  /// In ja, this message translates to:
  /// **'休薬'**
  String get restPeriod;

  /// ピルパックに含まれるホルモン非含有錠で、休薬期間中に服用する錠剤を指します。プラセボ錠を服用している期間中に生理が来ることが一般的です。
  ///
  /// In ja, this message translates to:
  /// **'偽薬'**
  String get placebo;

  /// ログインやアカウント検索時に、指定されたユーザーが存在しない場合に表示されるエラーメッセージです。アプリ内でユーザーアカウントが見つからない状況で使用されます。
  ///
  /// In ja, this message translates to:
  /// **'ユーザーが見つかりません'**
  String get userNotFound;

  /// アカウント作成やユーザー登録時に、入力されたメールアドレスや電話番号が既に他のアカウントで使用されている場合に表示されるエラーメッセージです。ユーザーに対して既存のアカウントでログインするか、別の認証情報を使用するよう促す文脈で使用されます。
  ///
  /// In ja, this message translates to:
  /// **'すでにユーザーが存在してます'**
  String get userAlreadyExists;

  /// ピルアプリ内で、過去に服用したピルの記録を確認できる画面やメニューのタイトルとして使用されます。ユーザーがいつピルを飲んだかの履歴を表示する機能の名称です。
  ///
  /// In ja, this message translates to:
  /// **'服用履歴'**
  String get medicationHistory;

  /// ピルアプリ内で、ユーザーがアプリの各種設定（通知設定、服用時間設定、プロフィール設定など）を変更できる設定画面のタイトルやメニュー項目として使用されます。アプリの動作や表示をカスタマイズするための設定機能全般を指す用語です。
  ///
  /// In ja, this message translates to:
  /// **'設定'**
  String get settings;

  /// ピルアプリの設定画面で表示されるメニュー項目で、ユーザーのログイン情報や個人プロフィール、アカウント設定などを管理する機能にアクセスするためのラベルです。
  ///
  /// In ja, this message translates to:
  /// **'アカウント'**
  String get account;

  /// 機種変更や端末紛失時に、ピルの服用記録や生理記録などのデータを新しい端末に引き継ぐには、アカウント登録が必要であることをユーザーに説明する文章です。
  ///
  /// In ja, this message translates to:
  /// **'機種変更やスマホ紛失時など、データの引き継ぎ・復元には、アカウント登録が必要です。'**
  String get dataTransferRequiresAccount;

  /// Pilllアプリの有料プラン（サブスクリプション）の名称です。アプリ名「Pilll」と「Premium」を組み合わせたブランド名として、設定画面や課金関連のUIで表示されます。
  ///
  /// In ja, this message translates to:
  /// **'Pilllプレミアム'**
  String get pillPremium;

  /// プレミアムプラン加入者が利用できる機能無制限期間について説明するテキストです。設定画面や課金関連のUIで、ユーザーに有料プランの特典期間を案内する際に表示されます。
  ///
  /// In ja, this message translates to:
  /// **'機能無制限の期間について'**
  String get unlimitedFeatureDuration;

  /// 避妊薬が包装されているシート状のパッケージのことで、アプリではピルシートをメタファーとしたUIを提供し、ユーザーがどこまで薬を飲んだか、いつ生理が来るかなどを一目で確認できます。
  ///
  /// In ja, this message translates to:
  /// **'ピルシート'**
  String get pillSheet;

  /// アプリがユーザーに送るプッシュ通知や画面内の通知のことで、ピルの服用時刻を知らせるリマインダーや重要な情報を伝える機能を指します。
  ///
  /// In ja, this message translates to:
  /// **'通知'**
  String get notification;

  /// ピル服用管理アプリにおける女性の生理（月経）を指し、生理周期の記録・管理機能で使用される医学的な用語です。ユーザーが生理日を記録して健康管理を行う際に表示されます。
  ///
  /// In ja, this message translates to:
  /// **'生理'**
  String get menstruation;

  /// 各種選択肢や分類項目において、既存の選択肢に該当しない場合に選択する汎用的な「その他」オプションです。
  ///
  /// In ja, this message translates to:
  /// **'その他'**
  String get others;

  /// アプリ内のヘルプ・サポートセクションで表示される「よくある質問」を意味するラベルです。ユーザーがピルの服用方法や機能について疑問を持った際にアクセスするページのタイトルとして使用されます。
  ///
  /// In ja, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// 新機能紹介
  ///
  /// In ja, this message translates to:
  /// **'新機能紹介'**
  String get newFeaturesIntroduction;

  /// アプリ内のメニューやボタンで表示される、ユーザーがサポートチームに問い合わせや相談をするための機能名です。
  ///
  /// In ja, this message translates to:
  /// **'お問い合わせ'**
  String get contactUs;

  /// アプリ内の各種データ（服用記録、生理記録、日記など）を削除する際に表示されるボタンやメニューの文言です。ユーザーが操作を取り消したい時に使用される汎用的な削除機能を表します。
  ///
  /// In ja, this message translates to:
  /// **'削除'**
  String get delete;

  /// 服用記録や生理記録などのデータを削除する際のボタンに表示される動詞形の文言です。
  ///
  /// In ja, this message translates to:
  /// **'削除する'**
  String get doDelete;

  /// アカウント削除機能で表示される文言で、ユーザーのアカウントと関連する全ての服用記録・生理記録データを完全に削除することを示します。重要な操作のため、各言語で適切に警告的なニュアンスを持つ表現にしてください。
  ///
  /// In ja, this message translates to:
  /// **'ユーザーを削除'**
  String get deleteUser;

  /// アプリ内の日記機能（体調記録）で特定の日記エントリを削除する際に表示される文言です。ユーザーの大切な体調記録が削除されることを示すため、各言語で適切に警告的なニュアンスを持つ表現にしてください。
  ///
  /// In ja, this message translates to:
  /// **'日記を削除します'**
  String get deleteDiary;

  /// 生理管理機能でユーザーが記録した生理期間のデータを削除する際に表示される確認ダイアログの文言です。重要な記録の削除を確認するため、各言語で慎重で丁寧な表現を使用してください。
  ///
  /// In ja, this message translates to:
  /// **'生理期間を削除しますか？'**
  String get confirmDeletingMenstruation;

  /// ピルの服用リマインダー機能で、ユーザーが新しい通知時間を追加する際に表示されるボタンやメニュー項目の文言です。簡潔で分かりやすい表現を使用してください。
  ///
  /// In ja, this message translates to:
  /// **'通知時間の追加'**
  String get addNotificationTime;

  /// ピル服用リマインダーの時刻設定で、ユーザーが設定した時間と端末のタイムゾーンが異なる場合に、端末のタイムゾーンに合わせて同期するかを確認するダイアログメッセージです。{deviceTimezoneName}には実際のタイムゾーン名（例：Asia/Tokyo）が表示されます。
  ///
  /// In ja, this message translates to:
  /// **'端末のタイムゾーン({deviceTimezoneName})と同期しますか？'**
  String syncWithDeviceTimeZone(String deviceTimezoneName);

  /// 設定画面等で表示される、ユーザーの端末で現在設定されているタイムゾーンを示すラベルです。ピルの服用リマインド機能で正確な時刻管理を行うため、タイムゾーン設定の確認に使用されます。
  ///
  /// In ja, this message translates to:
  /// **'現在設定されているタイムゾーン'**
  String get currentTimeZone;

  /// アプリ内のダイアログボックスやアラートで使用される肯定的な応答ボタンのラベルです。ユーザーが何かの確認や質問に対して「はい」と答える際に表示されます。
  ///
  /// In ja, this message translates to:
  /// **'はい'**
  String get yes;

  /// アプリ内のダイアログボックスやアラートで使用される否定的な応答ボタンのラベルです。ユーザーが何かの確認や質問に対して「いいえ」と答える際に表示されます。
  ///
  /// In ja, this message translates to:
  /// **'いいえ'**
  String get no;

  /// プレミアムプランの解約手続きや解約に関する情報へのリンク・ボタンのラベルです。ユーザーがサブスクリプションの解約方法を確認したい時に表示されます。
  ///
  /// In ja, this message translates to:
  /// **'解約について'**
  String get unsubscribeInfo;

  /// アプリがユーザーにピル（経口避妊薬）の服用時刻を知らせるリマインダー通知機能の名称です。設定画面や通知関連のメニューで表示されます。
  ///
  /// In ja, this message translates to:
  /// **'ピルの服用通知'**
  String get pillReminder;

  /// ピルの服用リマインダー通知を分類するための通知チャンネル名です。ユーザーの端末の通知設定画面で表示され、この種類の通知のオン・オフを制御するために使われます。
  ///
  /// In ja, this message translates to:
  /// **'服用通知'**
  String get takePillReminderChannelName;

  /// ピルの服用時刻になった時にユーザーに送信されるプッシュ通知のメッセージです。簡潔で親しみやすく、服用を促すトーンで翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'💊の時間です'**
  String get takePillReminder;

  /// アプリに問題が発生した際に、サポートや開発者への報告のために技術的なデバッグ情報をクリップボードにコピーするボタンのテキストです。ユーザーにとって分かりやすく、行動を促す表現で翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'COPY DEBUG INFO'**
  String get copyDebugInfo;

  /// 各種ダイアログや操作確認画面で、現在の操作を中止して前の画面に戻るためのボタンのテキストです。ユーザーが誤操作を防げるよう、明確で分かりやすい表現で翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'キャンセル'**
  String get cancel;

  /// ユーザーアカウントからサインアウト/ログアウトするためのボタンやメニュー項目のテキストです。各言語で一般的に使用される「ログアウト」の表現で翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'サインアウト'**
  String get signOut;

  /// アプリが新しいピルの服用サイクルを開始する際に、ピルシートの管理グループを自動的に作成・追加する機能のタイトルです。ユーザーが手動で設定しなくても、システムが自動的にピルシートの管理単位を追加することを表しています。
  ///
  /// In ja, this message translates to:
  /// **'ピルシートグループの自動追加'**
  String get autoAddPillSheetGroup;

  /// 現在服用中のピルシート（1パック分）が終了した際に、次のピルシートを自動的に追加する機能の説明文です。設定画面で表示される機能の説明として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'今のピルシートグループが終了したら、新しいシートを自動で追加します'**
  String get autoAddNewSheetAfterCurrentEnds;

  /// 設定画面で表示される「アカウント設定」メニュー項目のラベルです。ユーザーの個人情報やアカウント関連の設定を管理する画面へのナビゲーションとして使用されます。
  ///
  /// In ja, this message translates to:
  /// **'アカウント設定'**
  String get accountSettings;

  /// 外部サービスやアカウントとの連携が完了している状態を表すステータス表示です。設定画面などで「連携済み」として表示されます。
  ///
  /// In ja, this message translates to:
  /// **'連携済み'**
  String get linked;

  /// 外部サービスやアカウントとの連携がまだ完了していない状態を表すステータス表示です。設定画面などで「未登録」や「未連携」として表示され、ユーザーがまだ登録手続きを行っていないことを示します。
  ///
  /// In ja, this message translates to:
  /// **'未登録'**
  String get unregistered;

  /// ピルの服用を素早く記録するための機能名です。ワンタップで簡単に服用記録を付けられる機能を表します。
  ///
  /// In ja, this message translates to:
  /// **'クイックレコード'**
  String get quickRecord;

  /// 通知画面でのクイック記録機能の説明文です。今日飲むべきピルの確認と服用記録を同じ画面で素早く行えることを表現してください。
  ///
  /// In ja, this message translates to:
  /// **'通知画面で今日飲むピルが分かり、そのまま服用記録できます。'**
  String get quickRecordDescription;

  /// 設定画面等で表示される機能名で、iOSのヘルスケアアプリやその他の健康管理アプリとのデータ連携機能を指します。ピルの服用記録や生理データを外部の健康管理システムと同期する機能の名称として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'ヘルスケア連携'**
  String get healthCareIntegration;

  /// ピルの服用管理アプリPilllで記録した生理記録を、iOSの「ヘルスケア」アプリに自動的に同期する機能の説明文です。設定画面などでユーザーに機能の利便性を伝える際に表示されます。
  ///
  /// In ja, this message translates to:
  /// **'Pilllで記録した生理記録を自動でヘルスケアに記録できます'**
  String get healthCareIntegrationDescription;

  /// 有料プランの詳細や料金を確認するためのボタンやリンクのテキストです。設定画面やプレミアム機能の紹介画面で、ユーザーがプレミアムプランの内容を見る際に使用されます。
  ///
  /// In ja, this message translates to:
  /// **'プレミアムプランを見る'**
  String get viewPremiumPlan;

  /// ピルシートUIで今日服用するべきピル番号を手動で変更する機能のテキストです。飲み忘れやピルシートの進捗調整時に、ユーザーが今日の服用予定を修正する際に表示されます。
  ///
  /// In ja, this message translates to:
  /// **'今日飲むピル番号の変更'**
  String get changePillNumberForToday;

  /// アプリに登録されているすべてのピルシート情報を削除する機能のボタンテキストです。ユーザーがピル管理をリセットしたい場合や、すべてのデータを一括削除したい場合に使用される重要な操作です。
  ///
  /// In ja, this message translates to:
  /// **'ピルシートをすべて破棄'**
  String get discardAllPillSheets;

  /// ユーザーが何らかの操作を実行する前の確認ダイアログで表示される汎用的な確認フレーズです。{doing}部分には具体的な操作内容（削除、変更など）が入り、「その操作を本当に実行しますか？」という意味で使用されます。
  ///
  /// In ja, this message translates to:
  /// **'{doing}しますか？'**
  String areYouSureDoing(String doing);

  /// 画面上で現在表示されている項目やコンテンツを示すラベルです。ピルシートや履歴画面などで、表示中の内容を説明する際に使用されます。
  ///
  /// In ja, this message translates to:
  /// **'現在表示されている'**
  String get currentlyDisplayed;

  /// ユーザーが使用している過去・現在のピルシート一覧を表示する画面やセクションのタイトルです。複数のピルシートを管理・閲覧する際に表示されるラベルとして使用されます。
  ///
  /// In ja, this message translates to:
  /// **'すべてのピルシート'**
  String get allPillSheets;

  /// データやピルシートなどのオブジェクトが削除・破棄される際に使用される文言です。確認ダイアログなどで「〜が破棄されます」として表示される部分に使用されます。
  ///
  /// In ja, this message translates to:
  /// **'が破棄されます'**
  String get willBeDiscarded;

  /// ピルシートやデータなどを削除・廃棄する際のボタンやアクションに使用される動詞です。確認ダイアログなどで「破棄する」「削除する」として表示されます。
  ///
  /// In ja, this message translates to:
  /// **'破棄する'**
  String get discard;

  /// ユーザーがピルシート（避妊薬のパッケージ）を物理的に破棄・処分した際に表示される確認メッセージです。アプリ内でピルシートの管理状態を更新した後に、ユーザーに対して破棄完了を知らせるために使用されます。
  ///
  /// In ja, this message translates to:
  /// **'ピルシートを破棄しました'**
  String get pillSheetDiscarded;

  /// アプリ内で生理に関する情報や教育コンテンツを提供するセクション・メニューのタイトルです。ピルの服用管理と合わせて生理周期についての理解を深めるための情報ページへのリンクとして使用されます。
  ///
  /// In ja, this message translates to:
  /// **'生理について'**
  String get aboutMenstruation;

  /// ピルシートタイプを変更した際に、以前設定した生理開始日のピル番号が新しいピルシートには存在しない場合に表示される警告メッセージです。ユーザーに設定の確認と修正を促すエラー通知として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'生理開始日のピル番号をご確認ください。現在選択しているピルシートタイプには存在しないピル番号が設定されています'**
  String get checkPillNumberForMenstruationStart;

  /// ピル服用のリマインダー通知をユーザーが自分好みに設定できる機能の項目名です。通知時刻や通知方法などをカスタマイズする設定画面への入り口として表示されます。
  ///
  /// In ja, this message translates to:
  /// **'服用通知のカスタマイズ'**
  String get customizeMedicationNotifications;

  /// ピルの服用時刻を知らせるプッシュ通知やリマインダー機能の名称です。設定画面や通知関連の項目で表示されます。
  ///
  /// In ja, this message translates to:
  /// **'服用通知'**
  String get medicationNotification;

  /// 特定の機能や設定項目（{x}で表される）をユーザーが自分の好みに合わせて調整・変更できることを伝えるメッセージです。設定画面などで「通知設定をカスタマイズできます」のような形で表示されます。
  ///
  /// In ja, this message translates to:
  /// **'{x}のカスタマイズができます'**
  String xCanBeCustomized(String x);

  /// ユーザーがアプリの改善やフィードバックに協力してくれた際に表示される感謝メッセージです。丁寧で感謝の気持ちが伝わるような表現にしてください。
  ///
  /// In ja, this message translates to:
  /// **'ご協力ありがとうございます'**
  String get thankYouForCooperation;

  /// ユーザーがアプリに対してフィードバックや意見を送信した際に表示される、運営側がそのフィードバックをどのように活用するかを説明するメッセージです。丁寧で感謝の気持ちが伝わり、今後のサービス改善への活用を約束する表現にしてください。
  ///
  /// In ja, this message translates to:
  /// **'いただいた意見は今後の改善へと活用させていただきます。'**
  String get feedbackUsage;

  /// ダイアログ、モーダル、各種設定画面などを閉じるためのボタンのラベルです。アプリ全体で汎用的に使用される基本的なUI要素のため、その言語で最も自然で一般的な「閉じる」の表現を使用してください。
  ///
  /// In ja, this message translates to:
  /// **'閉じる'**
  String get close;

  /// 新規ユーザーがピル服用管理アプリPilllのアカウントを作成するためのボタンや項目です。アプリの初回利用時やログイン画面で表示される、アカウント新規登録を促すUI要素として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'アカウント登録'**
  String get registerAccount;

  /// ログインセッションが切れた際やエラーが発生した際に、ユーザーがアプリに再度ログインするためのボタンや項目です。健康管理アプリの継続的な利用において、セキュリティやセッション管理の観点から再認証が必要になった場合に表示されます。
  ///
  /// In ja, this message translates to:
  /// **'再ログイン'**
  String get reLogin;

  /// ユーザーのログイン認証情報（パスワードやアカウント設定など）の更新が正常に完了した際に表示される成功メッセージです。健康管理アプリのセキュリティ強化や問題解決後にユーザーに安心感を与える通知として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'認証情報を更新しました'**
  String get authenticationInfoUpdated;

  /// ユーザーのログイン認証情報（パスワードやアカウント設定など）を更新する機能で表示されるボタンやメニューのテキストです。健康管理アプリのセキュリティ強化や問題解決の際にユーザーが操作する重要な機能として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'認証情報を更新します'**
  String get updateAuthenticationInformation;

  /// アカウント登録完了時にユーザーに表示される確認メッセージで、{accountTypeProviderName}にはGoogleやAppleなどのソーシャルログインサービス名が入ります。ユーザーが正常に登録できたことを伝える肯定的なメッセージとして使用されます。
  ///
  /// In ja, this message translates to:
  /// **'{accountTypeProviderName}で登録しました'**
  String registeredWithProvider(String accountTypeProviderName);

  /// ユーザーアカウントを外部サービス（GoogleやAppleアカウントなど）と連携してデータの同期やバックアップを行う機能のボタンやメニューに表示されるテキストです。
  ///
  /// In ja, this message translates to:
  /// **'連携する'**
  String get linkAccount;

  /// ユーザーがPilllアプリのサービスから完全に退会（アカウント削除）する際にボタンやメニューに表示されるテキストです。アプリの利用を停止し、すべてのデータを削除する最終的な操作を表します。
  ///
  /// In ja, this message translates to:
  /// **'退会する'**
  String get withdraw;

  /// ユーザーがPilllアプリのアカウント削除（退会）処理を完了した後に表示される確認メッセージです。退会操作が正常に完了したことをユーザーに伝える重要な通知文言になります。
  ///
  /// In ja, this message translates to:
  /// **'退会しました'**
  String get withdrawalCompleted;

  /// データリセットや初期化などの重要な操作の後に表示される確認メッセージです。ユーザーにアプリの再起動と初期設定のやり直しが必要であることを伝える重要な通知文言になります。
  ///
  /// In ja, this message translates to:
  /// **'アプリを一度終了します。新しく始める場合はアプリを再起動後、初期設定を行ってください。'**
  String get appExitMessage;

  /// ダイアログボックスや確認画面で使用される汎用的な「OK」ボタンのラベルです。ユーザーが操作を確認・承認する際に表示されます。
  ///
  /// In ja, this message translates to:
  /// **'OK'**
  String get oK;

  /// ピルシートUI上で表示される各ピルの番号（1番、2番など）を変更・調整する機能です。ユーザーが自分の使いやすい番号表示にカスタマイズできる設定項目として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'ピル番号の変更'**
  String get changePillNumber;

  /// 設定画面やピルシート番号調整などで使用される汎用的な「変更」ボタンやアクションラベルです。ユーザーが何かを変更・調整する際に表示される動詞として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'変更'**
  String get change;

  /// 避妊ピル（経口避妊薬）を指す医療用語です。アプリの核となる概念で、各言語の医療分野で一般的に使用される「ピル」「錠剤」に相当する用語で翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'ピル'**
  String get pill;

  /// アプリ内で生理記録、服用履歴、体調日記、予定管理などを表示・入力するためのカレンダー機能を指します。各言語で一般的に使用される「カレンダー」「暦」に相当する用語で翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'カレンダー'**
  String get calendar;

  /// アカウント削除やデータリセット時に表示される警告メッセージです。ユーザーの服用履歴、生理記録、体調日記などのすべての個人データが完全に削除されることを伝える重要な確認メッセージとして翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'ユーザー情報が削除されます'**
  String get userInformationWillBeDeleted;

  /// アカウント退会時に表示される最終確認メッセージです。全データが削除され、同じアカウントで再ログインできなくなることを強調する重要な警告として翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'退会をするとすべてデータが削除され、二度と同じアカウントでログインができなくなります。'**
  String get withdrawalMessage;

  /// ピルの服用記録を確認・管理するページの名前です。ユーザーが過去の服用履歴を閲覧したり、服用状況を記録したりする機能を持つメインページの一つとして翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'RecordPage'**
  String get recordPage;

  /// 認証エラーや認証期限切れなどで、ユーザーに再度ログインを促すメッセージです。アプリのアカウント認証システムで使用されます。
  ///
  /// In ja, this message translates to:
  /// **'再ログインしてください'**
  String get doReLogin;

  /// アカウント退会処理を開始する前に、セキュリティ確保のため本人確認として再ログインを促すメッセージです。ユーザーが退会手続きを選択した際に表示され、再ログイン完了後に自動的に退会処理が実行されることを説明しています。
  ///
  /// In ja, this message translates to:
  /// **'退会前に本人確認のために再ログインをしてください。再ログイン後、自動的に退会処理が始まります'**
  String get reLoginMessage;

  /// アカウント退会処理時に、セキュリティ確保のため再ログインを求める際に表示されるメッセージです。ユーザーに認証情報の更新が必要であることを説明します。
  ///
  /// In ja, this message translates to:
  /// **'再度ログインをして認証情報を更新します'**
  String get updateAuthenticationAfterReLogin;

  /// ピルアプリ内で生理記録や管理を行うページの名前です。アプリのナビゲーションやタイトルバーに表示されます。
  ///
  /// In ja, this message translates to:
  /// **'MenstruationPage'**
  String get menstruationPage;

  /// ピルアプリ内で体調記録や通院予定などの将来の予定を管理するカレンダーページの名前です。アプリのナビゲーションやタイトルバーに表示されます。
  ///
  /// In ja, this message translates to:
  /// **'CalendarPage'**
  String get calendarPage;

  /// ピルアプリ内でアプリの各種設定を変更・管理する設定ページの名前です。アプリのナビゲーションやタイトルバーに表示されます。
  ///
  /// In ja, this message translates to:
  /// **'SettingsPage'**
  String get settingsPage;

  /// ユーザーが記録した生理期間のデータを削除した際に表示される確認・完了メッセージです。削除操作が正常に完了したことをユーザーに伝える文章として翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'生理期間を削除しました'**
  String get menstruationDeleted;

  /// ユーザーが過去に記録した生理期間のデータ（開始日・終了日など）を修正・編集する際に表示されるボタンやメニュー項目のテキストです。生理管理機能の編集操作を表す動作として翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'生理期間を編集'**
  String get editMenstruationPeriod;

  /// ユーザーが過去に記録した生理期間のデータ（開始日・終了日など）を編集完了した後に表示される確認メッセージです。生理管理機能での編集操作の完了を知らせる文言として翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'生理期間を編集しました'**
  String get menstruationEdited;

  /// ユーザーが日記機能で体調を記録する際の詳細情報を表示する画面やセクションのタイトルです。体調に関する具体的な症状や状況を詳しく入力・閲覧できる機能の見出しとして翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'体調詳細'**
  String get physicalConditionDetail;

  /// 薬の服用履歴画面で、一定期間以上過去の履歴を閲覧しようとした際に無料ユーザーに表示される制限メッセージです。プレミアム機能への登録を促す内容として翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'これ以上の閲覧はプレミアム機能になります'**
  String get medicationHistoryPremiumFeatureRestriction;

  /// 詳細情報や追加の情報を表示するためのボタンやリンクのテキストです。「もっと見る」「詳細を見る」といった意味で、ユーザーがより詳しい情報にアクセスしたい時に表示されます。
  ///
  /// In ja, this message translates to:
  /// **'くわしくみる'**
  String get viewMoreDetails;

  /// 追加の詳細情報を表示するためのボタンテキストです。リストや概要表示で、さらに多くの項目や詳細を見たい時にタップするリンクとして使用されます。
  ///
  /// In ja, this message translates to:
  /// **'もっと見る'**
  String get viewMore;

  /// ピルシートUI上で、最後に服用したピルの次に飲むべきピルの番号を表示するテキストです。数字の後に付ける序数詞（日本語では「番」、英語では「th」など）を各言語に適した形で翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'{afterLastTakenPillNumber}番'**
  String afterLastTakenPillNumber(String afterLastTakenPillNumber);

  /// ピルシートUIで表示される「残り服用数-最後に服用したピル番号」の形式です。例：「7-21番」は残り7錠で、21番目のピルまで服用済みを表します。
  ///
  /// In ja, this message translates to:
  /// **'{left}-{afterLastTakenPillNumber}番'**
  String leftDashAfterLastTakenPillNumber(String left, String afterLastTakenPillNumber);

  /// 最後に服用したピルの1つ前の番号を表示します。ピルシートのUI上で服用履歴の範囲表示に使用される番号です。
  ///
  /// In ja, this message translates to:
  /// **'{beforeLastTakenPillNumber}番'**
  String beforeLastTakenPillNumber(String beforeLastTakenPillNumber);

  /// ピルシートUIで、最後に服用したピルの番号から次に服用予定のピルの番号までの範囲を「-」でつないで表示するテキストです。「3-4番」のように連続する番号の範囲を示します。
  ///
  /// In ja, this message translates to:
  /// **'{beforeLastTakenPillNumber}-{afterLastTakenPillNumberPlusOne}番'**
  String beforeLastDashAfterLastTakenPlusOnePillNumber(String beforeLastTakenPillNumber, String afterLastTakenPillNumberPlusOne);

  /// ピルシートの表示番号設定で、1番から設定した開始番号までの範囲を示すテキストです。ピルシート上での番号表示のカスタマイズ機能で使用されます。
  ///
  /// In ja, this message translates to:
  /// **'1→{afterDisplayNumberSettingBeginPillNumber}番'**
  String oneToAfterDisplayNumberBeginPillNumber(String afterDisplayNumberSettingBeginPillNumber);

  /// ピルシートの表示番号設定で、元の開始番号から変更後の開始番号への変更を示すテキストです。番号の変更前後を矢印で表現しています。
  ///
  /// In ja, this message translates to:
  /// **'{beforeBeginPillNumber}→{afterDisplayNumberSettingBeginPillNumber}番'**
  String beforeBeginToAfterDisplayNumberBeginPillNumber(String beforeBeginPillNumber, String afterDisplayNumberSettingBeginPillNumber);

  /// ピルシートUIでピルの番号表示範囲を示すテキストです。「1番目から設定された最後の番号まで」という意味で、ピルシートの表示範囲を表します。
  ///
  /// In ja, this message translates to:
  /// **'1→{afterDisplayNumberSettingEndPillNumber}番'**
  String oneToAfterDisplayNumberEndPillNumber(String afterDisplayNumberSettingEndPillNumber);

  /// ピルシートの最後の薬の表示番号を変更する際に使用されます。変更前の番号から変更後の番号への変更を矢印で示します。
  ///
  /// In ja, this message translates to:
  /// **'{beforeEndPillNumber}→{afterDisplayNumberSettingEndPillNumber}番'**
  String beforeEndToAfterDisplayNumberEndPillNumber(String beforeEndPillNumber, String afterDisplayNumberSettingEndPillNumber);

  /// ピルの休薬期間（服用を一時的に停止する期間）の開始日をカレンダーから選択する際に表示される画面タイトルです。生理周期に合わせた服用スケジュール管理で使用されます。
  ///
  /// In ja, this message translates to:
  /// **'服用お休み開始日選択'**
  String get selectPauseStartDate;

  /// ピルの休薬期間（服用を一時的に停止する期間）の長さを選択する際に表示される画面タイトルです。生理周期に合わせた服用スケジュール管理で使用されます。
  ///
  /// In ja, this message translates to:
  /// **'服用お休み期間を選択'**
  String get selectPausePeriod;

  /// ピルの休薬期間（服用を一時的に停止する期間）の開始日を指定する際に表示されるラベルです。生理周期に合わせた服用スケジュール管理で使用されます。
  ///
  /// In ja, this message translates to:
  /// **'服用お休み開始日'**
  String get pauseStartDate;

  /// ピルの休薬期間（服用を一時的に停止する期間）の終了日を指定する際に表示されるラベルです。生理周期に合わせた服用スケジュール管理で使用されます。
  ///
  /// In ja, this message translates to:
  /// **'服用お休み終了日'**
  String get pauseEndDate;

  /// ピル（経口避妊薬）の一包装（通常シート状で28日分程度）がすべて服用完了した際に表示されるメッセージです。次のピルシートへの切り替えやタイミングを知らせる重要な通知として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'ピルシート終了'**
  String get endPillSheet;

  /// 服用が完了した空のピルシート（ブリスターパック）を適切に廃棄・処分する際に表示されるアクションやメッセージです。環境に配慮した廃棄方法の案内や、次のシートへの切り替えを促す文脈で使用されます。
  ///
  /// In ja, this message translates to:
  /// **'ピルシート破棄'**
  String get discardPillSheet;

  /// ユーザーがピルを服用する予定時刻を表示・設定する際に使用されるラベルです。リマインダー機能や服用履歴において、何時に薬を飲むべきかを示す文脈で表示されます。
  ///
  /// In ja, this message translates to:
  /// **'服用時間'**
  String get takingTime;

  /// ユーザーが服用履歴機能にアクセスしようとした際に表示される、その機能がプレミアムプラン限定であることを伝えるメッセージです。無料ユーザーに対して有料プランへのアップグレードを促す文脈で使用されます。
  ///
  /// In ja, this message translates to:
  /// **'服用履歴はプレミアム機能です'**
  String get takingHistoryIsPremiumFeature;

  /// ピルシートUI上で表示される説明文で、ユーザーが服用を一時停止した場合にピルシート上の順序番号が進まないことを伝えるメッセージです。アプリの核心機能であるピルシート管理において、服用の順序性を正確に保つための重要な動作説明です。
  ///
  /// In ja, this message translates to:
  /// **'服用をお休みするとピル番号は進みません'**
  String get pauseTakingDoesNotAdvancePillNumber;

  /// ピルシートUI上で、ユーザーが特定の番号（{number}）から薬の服用を一時停止することを確認するダイアログメッセージです。ピル管理アプリにおける重要な機能で、服用スケジュールの変更を行う際にユーザーの意思を確認するために表示されます。
  ///
  /// In ja, this message translates to:
  /// **'{number}から服用をお休みしますか？'**
  String pauseTakingFromNumber(String number);

  /// 次に服用すべきピルの番号を表示するためのテキストです。ピルシートUIで「◯番目のピルを飲む」という形で使用されます。
  ///
  /// In ja, this message translates to:
  /// **'{pillSheetGroupLastTakenPillSheetOrFirstPillSheetLastTakenPillNumberPlusOne}番'**
  String lastTakenPlusOnePillNumber(String pillSheetGroupLastTakenPillSheetOrFirstPillSheetLastTakenPillNumberPlusOne);

  /// ピルの服用を表す単語。服用記録や服用時刻などの機能で使用される。
  ///
  /// In ja, this message translates to:
  /// **'服用'**
  String get taking;

  /// 前回使用していたピルシート（ブリスターパック）の最後に服用したピルの番号を表示するテキストです。新しいシートに移る際の継続性を示すために使用されます。
  ///
  /// In ja, this message translates to:
  /// **'前回のシートの最後：{estimatedEndPillNumber}番'**
  String estimatedEndPillNumber(int estimatedEndPillNumber);

  /// 新しいピル薬のパック（シート）をアプリに登録するためのボタンのテキストです。ユーザーが新しいピルを飲み始める際に使用される機能です。
  ///
  /// In ja, this message translates to:
  /// **'ピルシートを追加'**
  String get addPillSheetButton;

  /// ピルを服用したことを示すステータス表示です。服用履歴画面などで、ユーザーが既にピルを飲み終えた状態を表現するために使用されます。
  ///
  /// In ja, this message translates to:
  /// **'飲んだ'**
  String get taken;

  /// ピルの服用状態を示すステータス表示で、ユーザーがその日にピルを服用していない状態を表します。服用履歴画面やピルシートUIで「taken」（服用済み）と対になって表示される重要な状態表示です。
  ///
  /// In ja, this message translates to:
  /// **'飲んでない'**
  String get notTaken;

  /// ピルの服用管理アプリで、物理的なピルシート（薬のブリスターパック）をデジタル化したUI表示や服用スケジュールに関する設定画面のタイトル。ピルシートの種類選択、表示番号調整、服用パターンなどの設定項目を含む重要な機能設定です。
  ///
  /// In ja, this message translates to:
  /// **'ピルシートの設定'**
  String get pillSheetSettings;

  /// ユーザーがピルの服用を一時停止（休薬）する際に、今日予定されているピルを「未服用」状態にマークする機能に関するメッセージです。休薬期間を開始する前段階として、当日のピル服用状況をリセットする操作を説明しています。
  ///
  /// In ja, this message translates to:
  /// **'今日飲むピルを未服用にしてから'**
  String get unmarkTodayPillAsTakenToPause;

  /// ピルの服用を一時的に停止・休薬する際に表示されるボタンやメニュー項目のテキストです。ユーザーが意図的にピル服用をお休みする機能を表しています。
  ///
  /// In ja, this message translates to:
  /// **'服用お休み'**
  String get pauseTaking;

  /// ピルの服用を一時的に休止する期間（休薬期間）の開始日を変更する機能のボタンやメニュー項目です。ユーザーが既に設定した休薬開始日を後から変更したい場合に使用されます。
  ///
  /// In ja, this message translates to:
  /// **'服用お休み開始日変更'**
  String get changePauseStartDate;

  /// ピルの服用を一時的に休止する休薬期間が終了したことをユーザーに通知するメッセージです。通知やダイアログなどで表示される短いテキストです。
  ///
  /// In ja, this message translates to:
  /// **'服用のお休み期間が終了しました'**
  String get pauseTakingPeriodEnded;

  /// ピルシートの最後のピル番号を表示するテキストです。ピルシートUIで「何番目まで飲むか」を示す数値が入ります。
  ///
  /// In ja, this message translates to:
  /// **'{endValueOrPillSheetGroupSequentialEstimatedEndPillNumber}'**
  String endValue(int endValueOrPillSheetGroupSequentialEstimatedEndPillNumber);

  /// ピルシート（ブリスターパック）の服用期間日数を変更する設定項目。ユーザーが21日間、28日間など、そのシートを何日間服用するかを設定できる機能のラベルです。
  ///
  /// In ja, this message translates to:
  /// **'シートの服用日数を変更'**
  String get changePillDaysForSheet;

  /// ピルシートの表示番号（開始番号と終了番号）をユーザーが変更した際に表示される確認메ッセージです。例えば「1番～28番」から「3番～30番」に変更した場合などに使用されます。
  ///
  /// In ja, this message translates to:
  /// **'始まりと終わりの番号を変更しました'**
  String get changedStartAndEndNumbers;

  /// ピルシート画面で、ピルの服用を開始する日付または日数を表示するラベルです。ユーザーがピルシートの表示番号を調整する際に使用されます。
  ///
  /// In ja, this message translates to:
  /// **'服用日数の始まり'**
  String get startOfPillDays;

  /// ピルシート管理画面で、前回使用していたピルシートの最後の服用日を示すテキストです。ユーザーがピルの服用進度や次のシートとの関連性を把握するために表示される情報です。
  ///
  /// In ja, this message translates to:
  /// **'前回のシートの最後：{beforePillSheetGroupSequentialEstimatedEndPillNumber}日目'**
  String beforePillSheetGroupSequentialEstimatedEndDay(int beforePillSheetGroupSequentialEstimatedEndPillNumber);

  /// ピルシートの服用期間が完了したことをユーザーに知らせるメッセージです。次のサイクルに進む前の区切りを示します。
  ///
  /// In ja, this message translates to:
  /// **'服用日数の終わり'**
  String get endOfPillDays;

  /// ピルシートUIでピルの表示番号を変更する機能に関するメッセージです。ユーザーがピルの番号表示を調整する際に使用されます。
  ///
  /// In ja, this message translates to:
  /// **'番に変更'**
  String get changedToNumber;

  /// ピルシートや設定画面で表示形式を選択する機能のラベルです。ユーザーがアプリの表示方法を変更する際に使用されます。
  ///
  /// In ja, this message translates to:
  /// **'表示モード'**
  String get displayMode;

  /// 設定画面で日付の表示形式を選択する機能のラベルです。ピルの服用記録や生理日などの日付情報をどのような形式で表示するかを設定する際に使用されます。
  ///
  /// In ja, this message translates to:
  /// **'日付表示'**
  String get dateDisplay;

  /// ピル番号
  ///
  /// In ja, this message translates to:
  /// **'ピル番号'**
  String get pillNumber;

  /// 1つの服用周期において、実際にピルを服用する日数を表示する項目です。通常のピルでは21日間服用、7日間休薬という28日周期が一般的です。
  ///
  /// In ja, this message translates to:
  /// **'服用日数'**
  String get pillDaysCycle;

  /// 1つのピルシート（通常21日分のピルが入った包装シート）を全て服用し終えた時に表示されるメッセージです。ユーザーにピルシートの終了を通知し、次のシートの準備や休薬期間への移行を促します。
  ///
  /// In ja, this message translates to:
  /// **'ピルシートが終了しました'**
  String get pillSheetEnded;

  /// ユーザーが最後にピルを服用した日付を確認するためのボタンやリンクに表示されるテキストです。服用履歴の確認や飲み忘れ防止のために使用されます。
  ///
  /// In ja, this message translates to:
  /// **'最後に服用した日を確認'**
  String get checkLastTakenDate;

  /// ユーザーがアカウント登録を求められる際に表示されるメッセージです。データの同期やバックアップのためにアカウント作成が必要な場面で使用されます。
  ///
  /// In ja, this message translates to:
  /// **'アカウント登録をしてください'**
  String get pleaseRegisterAccount;

  /// アカウント未登録のユーザーに対して、端末の機種変更や紛失時にプレミアム機能が引き継げないことを警告するメッセージです。アカウント登録を促すための注意喚起として表示されます。
  ///
  /// In ja, this message translates to:
  /// **'機種変更やスマホ紛失時に、プレミアム機能を引き継げません'**
  String get cannotTransferPremiumWithoutAccount;

  /// プレミアム機能の14日間無料再体験キャンペーンを告知し、ユーザーにSNSでのシェアを促すメッセージです。タップするとシェア機能が起動される想定のボタンテキストとして使用されます。
  ///
  /// In ja, this message translates to:
  /// **'プレミアム機能を14日間再体験できます！\nタップしてSNSにシェアしましょう！'**
  String get reexperiencePremiumFeatures;

  /// シェア機能でユーザーがシェア先（SNSなど）を選択する際に表示される選択画面のタイトルテキストです。プレミアム機能の再体験キャンペーンなどの情報をシェアする場面で使用されます。
  ///
  /// In ja, this message translates to:
  /// **'どちらにシェアしますか？'**
  String get whereToShare;

  /// ピルの服用サイクルにおいて、休薬期間（通常7日間）の何日目かを表示するテキストです。{day}には「1」「2」「3」などの数字が入り、「🌙 服用お休み 3日目」のように表示されます。
  ///
  /// In ja, this message translates to:
  /// **'🌙 服用お休み {day}日目'**
  String pauseTakingDay(int day);

  /// ピルシートや服用履歴で「何日目」かを表示する際に使用されます。{word}には数字（1、2、3など）が入り、「1日目」「2日目」のように表示されます。
  ///
  /// In ja, this message translates to:
  /// **'{word}日目'**
  String withDay(String word);

  /// 休薬期間（ピルを服用しない期間）の経過日数を表示する際に使用されます。{restDurationDays}には日数が入り、全体で「休薬〇日目」のような形で表示されます。
  ///
  /// In ja, this message translates to:
  /// **'{activePillSheetPillSheetTypeNotTakenWord}{restDurationDays}日目'**
  String restDurationDays(String activePillSheetPillSheetTypeNotTakenWord, int restDurationDays);

  /// ピルの服用期間から休薬期間までの残り日数を知らせるメッセージです。{diffPlusOne}は日数、{activePillSheetPillSheetTypeNotTakenWord}は休薬期間等の用語が入ります。
  ///
  /// In ja, this message translates to:
  /// **'あと{diffPlusOne}日で{activePillSheetPillSheetTypeNotTakenWord}期間です'**
  String daysUntilPausePeriod(int diffPlusOne, String activePillSheetPillSheetTypeNotTakenWord);

  /// プレミアムプラン（有料機能）の無料試用期間や有料契約の残り日数を表示するメッセージです。ユーザーにあと何日間、アプリのすべての機能（広告非表示、詳細統計など）が利用できるかを伝えています。
  ///
  /// In ja, this message translates to:
  /// **'残り{diff}日間すべての機能を使えます'**
  String remainingDaysAllFeatures(int diff);

  /// ピルの服用管理画面で、今日がピル服用の予定日であることをユーザーに通知するメッセージです。カレンダーやホーム画面などで、今日が服用日であることを示すステータス表示として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'💊 今日は服用'**
  String get todayIsTaking;

  /// ピル服用管理画面で、今日服用すべきピルを示すラベルです。ホーム画面やカレンダーなどで、今日飲む予定のピルがあることをユーザーに伝える際に使用されます。
  ///
  /// In ja, this message translates to:
  /// **'💊 今日飲むピル'**
  String get todayPillToTake;

  /// ピルシートUI上でピルの位置・順番を示す番号のラベルです。「1番」「2番」のように表示される際の「番」部分に相当します。
  ///
  /// In ja, this message translates to:
  /// **'番'**
  String get number;

  /// ユーザーが生理開始日を記録した後に表示される確認メッセージです。「○月○日から生理開始として記録しました」という意味で、記録が完了したことをユーザーに知らせる文言です。
  ///
  /// In ja, this message translates to:
  /// **'{DateTimeFormatterMonthAndDay}から生理開始で記録しました'**
  String recordedMenstruationStartDate(String DateTimeFormatterMonthAndDay);

  /// 生理管理機能で、ユーザーが生理の開始日を記録する際に表示されるラベルです。
  ///
  /// In ja, this message translates to:
  /// **'生理開始日'**
  String get menstruationStartDate;

  /// 生理管理機能で、ユーザーが生理の終了日を記録する際に表示されるラベル・項目名です。生理開始日とペアで使用され、生理期間を管理するために重要な情報です。
  ///
  /// In ja, this message translates to:
  /// **'生理終了日'**
  String get menstruationEndDate;

  /// 生理管理機能で、アプリが計算・予測した次回生理開始予定日を表示する際のラベル・項目名です。ユーザーの生理周期から自動算出される予測日であり、カレンダーやスケジュール画面で「次の生理はいつ頃来るか」を示すために使用されます。
  ///
  /// In ja, this message translates to:
  /// **'生理予定日'**
  String get menstruationScheduleDate;

  /// 生理管理機能で、アプリが予測した次回生理開始日までの残り日数を「生理予定：X日目」形式で表示する際に使用される文字列です。{diffPlusOne}には具体的な日数（1日目、2日目など）が入り、ユーザーのピル服用スケジュールと連動した生理周期予測を示します。
  ///
  /// In ja, this message translates to:
  /// **'生理予定：{diffPlusOne}日目'**
  String menstruationScheduleDateWithNumber(int diffPlusOne);

  /// ピルシート上で生理予定日の表示に使用される文字列。{diffPlusOne}は周期の何日目か、{pillNumber}はその日に服用するピルの番号を表示します。
  ///
  /// In ja, this message translates to:
  /// **'生理予定：{diffPlusOne}日目の{pillNumber}'**
  String menstruationScheduleDateWithNumberAndPillNumber(int diffPlusOne, String pillNumber);

  /// 次回の生理予定日まであと何日かを示すメッセージです。{diff}に残り日数が入ります。
  ///
  /// In ja, this message translates to:
  /// **'あと{diff}日'**
  String menstruationRemainingDay(int diff);

  /// 生理開始から経過した日数を表示する際に使用されるテキストです。生理管理画面で「3日目」「5日目」のように現在の生理周期の進行状況を示します。
  ///
  /// In ja, this message translates to:
  /// **'{diffPlusOne}日目'**
  String menstruationProgressingDay(int diffPlusOne);

  /// 生理記録機能のラベルです。ユーザーが生理の開始や期間を入力・記録する際に表示されるテキストです。
  ///
  /// In ja, this message translates to:
  /// **'生理を記録'**
  String get recordMenstruation;

  /// これまでに記録された生理の履歴・データを表示する画面やメニューのラベルです。ユーザーが過去の生理周期や記録を確認するための機能名として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'生理履歴'**
  String get menstruationHistory;

  /// 生理記録機能で、ユーザーが今日から生理が開始したことを記録する際に表示されるボタンやメニューのラベルです。生理周期の管理において、新しい生理期間の開始日を今日として登録するための操作に使用されます。
  ///
  /// In ja, this message translates to:
  /// **'今日から生理'**
  String get menstruationFromToday;

  /// 生理記録機能で、ユーザーが昨日から生理が開始したことを記録する際に表示されるボタンやメニューのラベルです。生理周期の管理において、新しい生理期間の開始日を昨日として登録するための操作に使用されます。
  ///
  /// In ja, this message translates to:
  /// **'昨日から生理'**
  String get menstruationFromYesterday;

  /// 生理記録機能で、ユーザーが新しい生理期間の開始日を設定する際に表示されるボタンやメニューのラベルです。生理周期の管理において、生理開始日を記録するための操作に使用されます。
  ///
  /// In ja, this message translates to:
  /// **'生理開始日を選択'**
  String get selectMenstruationStartDate;

  /// 生理周期の日数を表示する際に使用されるテキストです。{menstruationDuration}には28日、30日などの周期日数が入ります。
  ///
  /// In ja, this message translates to:
  /// **'{menstruationDuration}日周期'**
  String menstruationCycle(int menstruationDuration);

  /// アプリにアカウントでログインする際のボタンやリンクに表示されるテキストです。ユーザーが既存のアカウントでサインインするためのアクション表示に使用されます。
  ///
  /// In ja, this message translates to:
  /// **'ログイン'**
  String get login;

  /// プレミアム機能の説明や紹介をする際の導入部分として表示されるテキストです。ユーザーが有料プランの詳細を確認する前に表示される前置きの文言として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'プレミアム登録の前に…'**
  String get beforePremiumRegistration;

  /// ログイン画面や初回利用時に表示される、新規ユーザー向けの説明テキストです。初めてアプリを使用するユーザーに対して、自動的にアカウントが作成されることを知らせる案内文として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'Pilllにまだログインしたことが無い場合は新しくアカウントが作成されます'**
  String get createNewAccountIfNotLoggedIn;

  /// アカウント登録によりピルの服用履歴や生理記録などのデータをバックアップ・復元できることを伝えるメッセージです。デバイス変更や再インストール時のデータ移行機能について説明しています。
  ///
  /// In ja, this message translates to:
  /// **'アカウント登録するとデータの引き継ぎが可能になります'**
  String get registerAccountForDataTransfer;

  /// ユーザーの服用履歴や生理記録などの大切なデータを保持・維持するために、アカウント登録を促すメッセージです。データの永続化とバックアップのためのアカウント作成を案内しています。
  ///
  /// In ja, this message translates to:
  /// **'アカウント情報を保持するため、アカウント登録をお願いします'**
  String get registerAccountToKeepData;

  /// 外部サービス（Google、Apple等）を使用してアプリにサインインするためのボタンテキストです。{loginName}にはGoogleやAppleなどの認証サービス名が動的に挿入され、ユーザーの服用データや生理記録を安全に保管するためのアカウント作成・ログイン機能の一部として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'{loginName}でサインイン'**
  String signInWith(String loginName);

  /// アカウント新規登録時に、指定されたログイン方法（Google、Apple、メールアドレスなど）を使って登録することを示すボタンやメッセージ。{loginName}には具体的なサービス名が入ります。
  ///
  /// In ja, this message translates to:
  /// **'{loginName}で登録'**
  String registerWith(String loginName);

  /// 有料プラン「Pilll Premium」への登録が正常に完了したことをユーザーに知らせる成功メッセージです。アプリ名「Pilll」は翻訳せずそのまま使用してください。
  ///
  /// In ja, this message translates to:
  /// **'Pilllプレミアム登録完了'**
  String get premiumRegistrationComplete;

  /// ご登録ありがとうございます。
  /// すべての機能が使えるようになりました！
  ///
  /// In ja, this message translates to:
  /// **'ご登録ありがとうございます。\nすべての機能が使えるようになりました！'**
  String get thankYouForRegistration;

  /// アプリのプレミアム機能に関する期間限定キャンペーンのメッセージです。特別価格でサブスクリプションに加入すれば、その価格でずっと使い続けられることを表現しています。
  ///
  /// In ja, this message translates to:
  /// **'今なら限定価格でずっと使える'**
  String get limitedTimeDiscount;

  /// アプリのプレミアム機能に関する通常価格の月額サブスクリプションプランの名称です。割引プランと区別するために表示されます。
  ///
  /// In ja, this message translates to:
  /// **'通常 月額プラン'**
  String get standardMonthlyPlan;

  /// アプリのプレミアム機能に関する年額サブスクリプションプランの名称です。月額プランと区別するために表示されます。
  ///
  /// In ja, this message translates to:
  /// **'年額プラン'**
  String get annualPlan;

  /// 年額プレミアムプランの価格表示で、placeholderに価格が入り「価格/年」の形式で表示されます。各言語で「年」を表す適切な単位を使用してください。
  ///
  /// In ja, this message translates to:
  /// **'{annualPackageStoreProductPriceString}/年'**
  String annualPrice(String annualPackageStoreProductPriceString);

  /// プレミアムプランの月額料金を表示する際の形式で、価格の後に「/月」を付けて表示します。
  ///
  /// In ja, this message translates to:
  /// **'{monthlyPriceString}/月'**
  String monthlyPrice(String monthlyPriceString);

  /// プレミアムプランの1日あたりの料金を表示する際に使用されます。{dailyPriceString}は計算された1日の価格が入ります。
  ///
  /// In ja, this message translates to:
  /// **'{dailyPriceString}/日'**
  String dailyPrice(String dailyPriceString);

  /// プレミアムプランの利用規約で表示される、サブスクリプションの自動更新に関する重要な契約条件です。法的文書として正確で分かりやすい翻訳が必要です。
  ///
  /// In ja, this message translates to:
  /// **'・プレミアム契約期間は開始日から起算して1ヶ月または1年ごとの自動更新となります\n'**
  String get premiumTermsNotice1;

  /// プレミアムプランの利用規約で項目を列挙する際に使用する箇条書きのバレット記号です。各言語の慣習に合わせた適切な箇条書き記号（・、•、-など）に翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'・'**
  String get premiumTermsBullet;

  /// UIで項目を区切る際に使用するスラッシュ記号です。各言語の慣習に合わせて、適切な区切り文字（/、｜、-など）とスペースの有無を調整してください。
  ///
  /// In ja, this message translates to:
  /// **' / '**
  String get slashSeparator;

  /// プレミアムプラン（有料機能）の法的情報を表示する際のタイトルです。日本の特定商取引法に基づく事業者情報の表示義務に対応します。
  ///
  /// In ja, this message translates to:
  /// **'特定商取引法に基づく表示'**
  String get premiumTermsNotice2;

  /// プレミアムプラン登録時に、利用規約や法的事項の確認を促すメッセージの最後の部分です。ユーザーに内容を確認してから登録を進めるよう案内する文言です。
  ///
  /// In ja, this message translates to:
  /// **'をご確認のうえ登録してください\n'**
  String get premiumTermsNotice3;

  /// プレミアムプランの自動更新に関する法的通知で、アプリストアの規約に準拠するために表示される重要な文言です。正確な法的意味を保持して翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'・プレミアム契約期間の終了日の24時間以上前に解約しない限り契約期間が自動更新されます\n'**
  String get autoRenewNotice;

  /// プレミアムプランの自動更新解約方法を説明する重要な文言で、App StoreやGoogle Play Storeでの解約手順とアプリ内では解約できないことを正確に伝える必要があります。
  ///
  /// In ja, this message translates to:
  /// **'・購入後、自動更新の解約は{storeName}アプリのアカウント設定で行えます。(アプリ内から自動更新の解約は行なえません)。'**
  String cancelAutoRenewInfo(String storeName);

  /// 詳細情報を表示するためのリンクやボタンに使用されるテキストです。ユーザーが追加の情報を確認したい時にタップ/クリックする要素の表示文言として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'詳細はこちら'**
  String get moreDetails;

  /// ピルアプリのプレミアムプラン（有料機能）を復元した際に表示される成功メッセージです。ユーザーが機種変更や再インストール後に、以前購入したプレミアム機能を復元完了したことを知らせる通知文言として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'購入情報を復元しました'**
  String get restorePurchase;

  /// ピルアプリのプレミアムプラン購入画面で、既に購入済みのユーザーが機種変更や再インストール後に購入履歴を復元するためのリンクまたはボタンに表示されるテキストです。新規購入ではなく、過去の購入を復元したいユーザー向けの案内文言として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'以前購入した方はこちら'**
  String get previouslyPurchased;

  /// プレミアムプラン購入復元時に、以前の購入履歴が見つからない場合にユーザーに表示されるエラーメッセージです。機種変更や再インストール後に購入復元を試みたが失敗した際のメッセージとして使用されます。
  ///
  /// In ja, this message translates to:
  /// **'以前の購入情報が見つかりません。アカウントをお確かめの上再度お試しください'**
  String get noPreviousPurchaseInfo;

  /// プレミアム機能を利用するための月額課金プラン名です。年額プランと対比して表示される課金オプションとして使用されます。
  ///
  /// In ja, this message translates to:
  /// **'月額プラン'**
  String get monthlyPlan;

  /// プレミアム機能の月額課金プランの価格表示で、価格の後に続く「/月」部分です。年額プランと対比されるため、各言語で適切な月単位の表現を使用してください。
  ///
  /// In ja, this message translates to:
  /// **'{monthlyPackageStoreProductPriceString}/月'**
  String monthlyPlanPrice(String monthlyPackageStoreProductPriceString);

  /// アプリ内の有料プランの支払い方式の1つで、一度購入すれば永続的に利用できるプランを指します。サブスクリプション（月額・年額）とは異なる買い切り型の課金方式です。
  ///
  /// In ja, this message translates to:
  /// **'買い切り'**
  String get lifetimePlan;

  /// 買い切り型有料プランの説明文で、一度の支払いで永続的にプレミアム機能が利用できることを示すテキストです。
  ///
  /// In ja, this message translates to:
  /// **'一度の購入でずっとプレミアム'**
  String get lifetimePlanDescription;

  /// 買い切り型プレミアムプランの期間限定特別価格オファーを表示するタイトルテキストです。課金画面で通常価格より安い特別価格で提供される際に使用されます。
  ///
  /// In ja, this message translates to:
  /// **'買い切りプラン\n期間限定特別価格'**
  String get lifetimePlanSpecialOffer;

  /// 買い切り型プレミアムプランの通常価格を表示するラベルテキストです。課金画面で特別価格オファーと対比して表示される際に使用されます。
  ///
  /// In ja, this message translates to:
  /// **'通常価格'**
  String get lifetimePlanStandardPrice;

  /// プレミアムプラン（有料プラン）に加入しているユーザーに表示される会員ステータスメッセージです。
  ///
  /// In ja, this message translates to:
  /// **'あなたは\nプレミアムメンバーです'**
  String get youArePremiumMember;

  /// プレミアムプラン（有料プラン）のユーザーに向けて表示される感謝のメッセージです。アプリの利用とサポートに対する感謝を表現し、運営継続への貢献を認める内容にしてください。
  ///
  /// In ja, this message translates to:
  /// **'ご利用ありがとうございます。\nお陰様でPilllの運営を継続できています。'**
  String get thankYouMessage;

  /// プレミアムプラン（有料プラン）で利用できる機能の一覧を表示する際の見出しまたはタイトルです。ユーザーがプレミアム機能を確認する画面で使用されます。
  ///
  /// In ja, this message translates to:
  /// **'プレミアム機能一覧'**
  String get premiumFeaturesList;

  /// プッシュ通知を受信した際に、アプリを開かずに通知から直接ピルの服用記録を行う機能の名称です。プレミアム機能の一覧で表示される項目として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'📩 プッシュ通知から服用記録'**
  String get pushNotificationForTakingRecord;

  /// ピルの服用記録を過去に遡って確認したり、新たな服用記録を登録したりできる機能の名称です。プレミアム機能の一覧で表示される項目として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'🗂 服用履歴の記録・閲覧'**
  String get viewAndRecordTakingHistory;

  /// プレミアム機能の一覧で表示される機能名です。ピルシートのUI画面上に日付情報を表示する機能を指しており、ユーザーがピルの服用管理をしやすくするための視覚的サポート機能です。
  ///
  /// In ja, this message translates to:
  /// **'📆 ピルシート上に日付表示'**
  String get displayDateOnPillSheet;

  /// プレミアム機能の一覧で表示される機能名です。現在使用中のピルシートが終了間近になった際に、自動的に新しいピルシートの設定を作成してくれる便利機能を表しています。
  ///
  /// In ja, this message translates to:
  /// **'📦 新しいピルシートを自動補充'**
  String get autoRefillNewPillSheet;

  /// プレミアム機能の一覧で表示される機能名です。過去の服用記録、生理記録、体調記録などの履歴データを閲覧できる機能を表しています。
  ///
  /// In ja, this message translates to:
  /// **'👀 過去のデータ閲覧'**
  String get viewPastData;

  /// プレミアム機能の一覧で表示される機能名です。ユーザーが日記機能で体調を記録する際に使用するタグ（頭痛、吐き気、気分など）を自分好みにカスタマイズできる機能を表しています。
  ///
  /// In ja, this message translates to:
  /// **'🏷 体調タグをカスタマイズ'**
  String get customizeHealthTags;

  /// プレミアム機能の一覧で表示される機能名です。有料プランに加入することでアプリ内の広告（バナー広告など）を非表示にできる機能を表しています。
  ///
  /// In ja, this message translates to:
  /// **'🚫 広告の非表示'**
  String get hideAds;

  /// プレミアム機能の詳細画面に遷移するボタンやリンクのテキストです。ユーザーが有料プランの機能について詳しく知りたい時にタップする要素として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'プレミアム機能の詳細を見る'**
  String get seeDetailsOfPremiumFeatures;

  /// アプリ内で人気の高い機能やおすすめ機能を紹介する見出しやタイトルとして使用されます。UI上で改行（\n）が含まれる場合があり、レイアウトを考慮して翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'人気の\n機能'**
  String get popularFeatures;

  /// プレミアム機能（有料機能）の詳細や内容を確認するためのボタンやリンクテキストとして使用されます。ユーザーをプレミアム機能の紹介画面に誘導する際の行動を促すテキストです。
  ///
  /// In ja, this message translates to:
  /// **'プレミアム機能を見る'**
  String get viewPremiumFeatures;

  /// ボタンやリンクテキストとして使用され、ピルの服用履歴や生理記録、プレミアム機能などの詳細情報を表示する画面に遷移する際の行動を促すテキストです。
  ///
  /// In ja, this message translates to:
  /// **'詳細を見る'**
  String get seeDetails;

  /// アプリの初期設定やオンボーディングプロセスにおける3番目（最終）のステップを示すテキストで、「3/3」の形式で進捗を表示します。画面上部などに表示され、ユーザーに現在のステップ位置を分数形式で伝える役割があります。
  ///
  /// In ja, this message translates to:
  /// **'3/3'**
  String get stepThreeOfThree;

  /// 設定した服用時刻にピルを飲み忘れた際にユーザーに送信されるプッシュ通知のタイトルまたは内容として表示されるテキストです。アプリの主要機能である「飲み忘れ防止」のためのリマインド機能の一部として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'ピルの飲み忘れ通知'**
  String get missedPillNotification;

  /// ピルの服用リマインダーを複数設定することで飲み忘れを防げることをユーザーに説明するメッセージです。リマインダー設定画面や説明画面で表示されます。
  ///
  /// In ja, this message translates to:
  /// **'複数設定しておく事で飲み忘れを防げます'**
  String get setMultipleReminders;

  /// 2つの項目や要素を並列に繋ぐ際に使用される接続詞です。アプリ内のテキストで「設定と履歴」「朝と夜」などの表現に使われます。
  ///
  /// In ja, this message translates to:
  /// **'と'**
  String get and;

  /// 利用規約やプライバシーポリシー等の重要な情報を読んでから、アプリの使用を開始することを促すボタンまたは案内文です。ユーザーに対して情報の確認と利用開始の両方のアクションを促している表現です。
  ///
  /// In ja, this message translates to:
  /// **'を読んで\n利用をはじめてください'**
  String get readAndStartUsing;

  /// 画面やフォームで次のステップに進むためのボタンラベルです。初回設定、チュートリアル、各種設定画面などで使用されます。
  ///
  /// In ja, this message translates to:
  /// **'次へ'**
  String get next;

  /// 複数のピル服用リマインダー通知がある場合に、各通知を番号で区別するためのラベルです。通知設定画面や通知一覧で「通知1」「通知2」のように表示されます。
  ///
  /// In ja, this message translates to:
  /// **'通知{number}'**
  String notificationIndex(int number);

  /// プッシュ通知から直接ピルの服用記録を行える機能を説明するユーザー向けの案内文です。リマインド通知を受け取ったユーザーが、アプリを開かなくても通知から服用記録できる便利さを伝える文言です。
  ///
  /// In ja, this message translates to:
  /// **'\\ 通知から服用記録ができます /'**
  String get takingRecordFromNotification;

  /// 新規ユーザーがアプリの利用を開始する際に表示されるボタンやリンクのテキストです。オンボーディングやチュートリアル完了後に、実際にPilllアプリの機能を使い始めることを促す文言として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'アプリをはじめる'**
  String get startApp;

  /// ユーザーが外部認証プロバイダー（Google、Apple、Facebookなど）を使用してログインに成功した際に表示される確認メッセージです。{accountTypeProviderName}には使用したサービス名が入ります。
  ///
  /// In ja, this message translates to:
  /// **'{accountTypeProviderName}でログインしました'**
  String loggedInWithProvider(String accountTypeProviderName);

  /// 医師から処方されたピルのシート（薬のパッケージ）に関する情報を入力してもらう際のメッセージです。ユーザーが使用しているピルの種類や詳細について教えてもらうための画面で表示されます。
  ///
  /// In ja, this message translates to:
  /// **'処方されるシートについて\n教えてください'**
  String get tellAboutPrescribedSheet;

  /// アカウント作成や初回設定画面で、すでにアプリにアカウントを持っているユーザーがログイン画面に移動するためのリンクテキストです。新規ユーザー向けの画面で、既存ユーザーを適切な画面に誘導する役割を持ちます。
  ///
  /// In ja, this message translates to:
  /// **'すでにアカウントをお持ちの方はこちら'**
  String get existingAccountUsers;

  /// ピルシート画面で、今日服用予定または服用済みのピルの番号をタップするよう促すユーザー向けの操作説明です。服用記録を行うためのUI要素に表示されます。
  ///
  /// In ja, this message translates to:
  /// **'今日({todayString})\n飲む・飲んだピルの番号をタップ'**
  String selectTodayPillNumber(String todayString);

  /// ユーザーがまだ情報を入力していない、または設定していない状態を表示する際に使用されます。生理予定日や服用スケジュールなど、アプリの各機能でデータが未確定の場合に表示されるテキストです。
  ///
  /// In ja, this message translates to:
  /// **'まだ分からない'**
  String get notYetKnown;

  /// 特定の日付に服用予定のピルを表示する際のラベルテキストです。ピルシート画面やカレンダー表示で、その日に飲むべきピルの情報を示す前置きとして使用されます。
  ///
  /// In ja, this message translates to:
  /// **'{today}に飲むピルは'**
  String pillForToday(String today);

  /// ピルシート上で今日服用すべきピルの番号（例：1錠目、15錠目など）を表示する際に使用されます。リマインダー通知やログ記録でも参照される重要な値です。
  ///
  /// In ja, this message translates to:
  /// **'{todayPillNumberPillNumberInPillSheet}'**
  String todayPillNumber(
      String todayPillNumberPillNumberInPillSheet,
      Object brojDanasnjiePilule,
      Object jinTianYaoPianBianHao,
      Object nambariYaDawaYaLeo,
      Object nomerTabletkiSegodnyaVBlistere,
      Object numeroPildoraHoy,
      Object numeroPindolaAvuiAlFullDePindoles,
      Object numriPilulesSeSpot,
      Object rhifBilsenHeddiwYnYDdalenBilsennau);

  /// 設定や入力内容を事前に確認するためのプレビュー表示に使用される文字列です。ユーザーが何かを実行・保存する前の確認画面で表示されます。
  ///
  /// In ja, this message translates to:
  /// **'プレビュー'**
  String get preview;

  /// アプリ内で状態や設定を表す際の「通常」や「正常」を意味する汎用的な文字列です。ピルの服用状態、生理の状態、アプリの動作モードなど、標準的・正常な状態を示す場面で使用されます。
  ///
  /// In ja, this message translates to:
  /// **'通常'**
  String get normal;

  /// ピルの服用予定時刻を過ぎても服用していない状態を表す表示ラベルです。アプリ内でユーザーがピルを飲み忘れた際に表示される状態表示として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'飲み忘れ'**
  String get missed;

  /// 設定画面やオプションメニューで使用される、日付表示の有無を切り替える設定項目のラベルです。ユーザーがアプリ内で日付情報を表示するかどうかを選択する際に表示されます。
  ///
  /// In ja, this message translates to:
  /// **'日付を表示'**
  String get showsDate;

  /// ピルシートの各薬に表示される順番の数字（1日目、2日目など）を表示するかどうかを切り替える設定項目のラベルです。ユーザーがピルシートUI上で薬の服用順序を数字で確認したい場合に使用されます。
  ///
  /// In ja, this message translates to:
  /// **'番号を表示'**
  String get showsPillNumber;

  /// アプリ内の設定画面で、説明文やヘルプテキストの表示・非表示を切り替えるオプションのラベルです。ユーザーがUIをシンプルにしたい場合に説明文を隠すことができる機能を指します。
  ///
  /// In ja, this message translates to:
  /// **'説明文を表示'**
  String get showsDescription;

  /// 予定やスケジュールの件名・タイトルを表します。通院予定や体調記録などの見出しとして使用されます。
  ///
  /// In ja, this message translates to:
  /// **'タイトル'**
  String get title;

  /// エラー発生時やシステム処理時に表示される汎用的なメッセージです。主にプレミアム機能の購入・復元処理やSNSシェア機能でのエラーメッセージとして使用されます。
  ///
  /// In ja, this message translates to:
  /// **'メッセージ'**
  String get message;

  /// アプリ内の設定項目やメニューでの選択肢を表す汎用的な用語です。設定画面やダイアログでの選択項目として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'オプション'**
  String get option;

  /// テキスト入力やピッカーでの選択などの作業を完了・確定する際に押すボタンのテキストです。日記投稿、スケジュール投稿、通知設定などの画面で使用されます。
  ///
  /// In ja, this message translates to:
  /// **'完了'**
  String get completed;

  /// ピルの服用管理アプリ「Pilll」のアプリ名です。基本的には「Pilll」のまま使用しますが、各言語の文字体系に合わせて表記を調整してください。
  ///
  /// In ja, this message translates to:
  /// **'Pilll'**
  String get pilll;

  /// ピルの服用を忘れた際に表示される通知メッセージを、ユーザーが自分で編集・カスタマイズできる機能の説明文です。設定画面などで表示される機能説明として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'飲み忘れてる場合の通知文言を変更できます'**
  String get changeMissedNotificationMessage;

  /// ピルの服用を忘れた際のカスタム通知メッセージの文字数制限を表示するテキストです。現在の入力文字数と最大文字数（100文字）を「現在文字数/100」の形式で表示します。
  ///
  /// In ja, this message translates to:
  /// **'{missedTakenMessageValueCharactersLength}/100'**
  String missedNotificationMessageLength(int missedTakenMessageValueCharactersLength);

  /// プッシュ通知のタイトル部分をユーザーがカスタマイズできる機能について説明するテキストです。設定画面などで、服用リマインダー通知の冒頭メッセージを変更できることを伝えています。
  ///
  /// In ja, this message translates to:
  /// **'通知の先頭部分の変更ができます'**
  String get changeNotificationHeader;

  /// プッシュ通知のヘッダー（タイトル）をカスタマイズする際の文字数制限表示で、現在の入力文字数を8文字制限中の何文字目かを示すテキストです。数字の「8」は文字数制限のため変更せず、スラッシュ（/）も区切り文字として保持してください。
  ///
  /// In ja, this message translates to:
  /// **'{wordValueCharactersLength}/8'**
  String notificationHeaderLength(int wordValueCharactersLength);

  /// フォーム入力時に最低文字数を満たしていない場合に表示されるバリデーションエラーメッセージです。日記や体調記録などの入力フィールドで使用されます。
  ///
  /// In ja, this message translates to:
  /// **'0文字以上入力してください'**
  String get enterAtLeastOneCharacter;

  /// ピルを正常に服用した場合（飲み忘れていない場合）の通知メッセージをユーザーがカスタマイズできる機能の説明文です。アプリの設定画面で表示される機能説明として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'飲み忘れていない場合の通知文言を変更できます'**
  String get changeDailyNotificationMessage;

  /// {dailyTakenMessageValueCharactersLength}/100
  ///
  /// In ja, this message translates to:
  /// **'{dailyTakenMessageValueCharactersLength}/100'**
  String dailyNotificationMessageLength(int dailyTakenMessageValueCharactersLength);

  /// ピルの服用リマインダー通知の設定項目で、当日の朝9:00に通知を受け取る機能を表します。通知時刻が固定で朝9:00となっているボタンやメニューのテキストです。
  ///
  /// In ja, this message translates to:
  /// **'当日9:00に通知を受け取る'**
  String get receiveDailyNotificationAt9AM;

  /// 設定変更や入力内容を確定・保存する際に表示されるボタンのテキストです。アプリ内の様々な画面（服用設定、通知設定、プロフィール編集など）で汎用的に使用されます。
  ///
  /// In ja, this message translates to:
  /// **'保存'**
  String get save;

  /// 日記機能において、ユーザーが体調や身体の状態を記録する際の項目名として表示されます。ピル服用による体調の変化や身体のコンディションを記録するために使用されます。
  ///
  /// In ja, this message translates to:
  /// **'体調'**
  String get physicalCondition;

  /// 日記機能において、日記を削除する際の確認画面や警告メッセージとして表示されます。削除操作が不可逆であることをユーザーに伝える重要な注意文です。
  ///
  /// In ja, this message translates to:
  /// **'削除された日記は復元ができません'**
  String get deletedDiaryCannotBeRecovered;

  /// 日記機能において、体調記録の一項目として性的活動の有無を記録する際のラベルです。ピル服用管理との関連で重要な体調データとして使用されます。
  ///
  /// In ja, this message translates to:
  /// **'sex'**
  String get sex;

  /// ピル服用管理において、複数のピルシート（薬のパッケージ）をグループとして管理する際の、時系列的に一つ前に使用していたピルシートのまとまりを指します。服用履歴や切り替えの管理画面で表示される項目として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'前回のピルシートグループ'**
  String get previousPillSheetGroup;

  /// アプリ内で前回使用していたピルシートのグループが存在しない状況（初回使用時や履歴がない場合など）で表示される状態メッセージです。ユーザーが過去の服用履歴を確認しようとした際に、まだ前回のデータが登録されていないことを伝える文言として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'前回のピルシートグループがまだ存在しません'**
  String get noPreviousPillSheetGroup;

  /// アプリ内でユーザーが過去のピル服用履歴を確認しようとした際に、システムエラーやネットワーク障害などでデータの取得に失敗した場合に表示されるエラーメッセージです。{error}部分には具体的なエラー内容が挿入されます。
  ///
  /// In ja, this message translates to:
  /// **'服用履歴情報の取得に失敗しました。{error}'**
  String failedToFetchPillHistory(String error);

  /// アプリ内でFAQ（よくある質問）ページへ移動するためのボタンやリンクのテキストです。ピルの服用方法やアプリの操作方法に関する質問と回答を確認できるページに誘導します。
  ///
  /// In ja, this message translates to:
  /// **'FAQを見る'**
  String get seeFAQ;

  /// アプリでデータの読み込みエラーが発生した際に、画面を再読み込みするためのボタンやリンクのテキストです。服用記録や生理記録などの情報を再取得して画面を更新する機能に使用されます。
  ///
  /// In ja, this message translates to:
  /// **'画面を再読み込み'**
  String get reloadScreen;

  /// アプリで技術的な問題やエラーが発生し、ユーザー自身では解決できない場合に、サポートチームに連絡するためのリンクやボタンのテキストです。トラブルシューティング画面で「お問い合わせ」や「サポートに連絡」の意味で使用されます。
  ///
  /// In ja, this message translates to:
  /// **'解決しない場合はこちら'**
  String get contactIfNotResolved;

  /// ユーザーにアプリに対する感想やフィードバックの提供を促すメッセージです。設定画面やフィードバック画面で、アプリの改善のためにユーザーの意見を求める際に表示されます。
  ///
  /// In ja, this message translates to:
  /// **'Pilllの感想をお聞かせください'**
  String get shareFeedback;

  /// アクションや選択内容を確定する際に使用される一般的な確認ボタンのラベルです。ダイアログボックスやフォームでユーザーの操作を最終確認する場面で表示されます。
  ///
  /// In ja, this message translates to:
  /// **'決定'**
  String get confirm;

  /// アプリ利用者に対してサービス品質向上を目的としたアンケート調査への協力を任意でお願いする丁寧なメッセージです。ユーザーの負担感を軽減するため、協力は任意であることを示す敬語表現を含めてください。
  ///
  /// In ja, this message translates to:
  /// **'よろしければサービス改善のためのアンケートにもご協力ください'**
  String get surveyForServiceImprovement;

  /// サービス改善アンケートに参加・協力するためのボタンやリンクのテキストです。ユーザーがアンケート調査に協力することを表現する動詞として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'協力する'**
  String get participate;

  /// フィードバックやアンケートで「役に立ったか」という質問に対する否定的な回答選択肢として使用されます。英語版では「Not helpful」として表示されるボタンやリンクのテキストです。
  ///
  /// In ja, this message translates to:
  /// **'しない'**
  String get notHelp;

  /// アプリ内でユーザーのフィードバックを収集するためのアンケート機能のタイトルや見出しとして表示される文字列です。Pilllアプリのサービス向上を目的としたユーザー向けアンケートを指しています。
  ///
  /// In ja, this message translates to:
  /// **'サービス改善アンケート'**
  String get serviceImprovementSurvey;

  /// アプリのサービス向上アンケートで使用される満足度評価の選択肢です。ユーザーがアプリに対して「満足している」という回答を選択する際に表示される文字列です。
  ///
  /// In ja, this message translates to:
  /// **'満足している'**
  String get satisfied;

  /// アプリのサービス向上アンケートで使用される満足度評価の選択肢です。ユーザーがアプリに対して「満足していない」という回答を選択する際に表示される文字列です。
  ///
  /// In ja, this message translates to:
  /// **'満足では無い'**
  String get notSatisfied;

  /// ピルシートの薬の番号（1番、2番...）ごとに何かを行う際に使用される表現です。ピル管理機能で薬の順番や番号に基づいた表示・操作を示すフレーズです。
  ///
  /// In ja, this message translates to:
  /// **'番ごとに'**
  String get perNumber;

  /// 生理管理機能で、ユーザーの生理期間（日数）を入力してもらう際の質問文です。通常3-7日程度の期間を想定した設定画面で使用されます。
  ///
  /// In ja, this message translates to:
  /// **'何日間生理が続く？'**
  String get howManyDaysDoesMenstruationLast;

  /// 生理管理機能で、ユーザーが設定した生理期間の日数を表示する際のテキストです。数値の後に続けて「X日間生理が続く」のような形で使用されます。
  ///
  /// In ja, this message translates to:
  /// **'日間生理が続く'**
  String get daysMenstruationLasts;

  /// ピルシートUI上で、ユーザーが生理開始時のピル番号を指定する際の操作指示です。生理周期を正確に管理するための重要な設定項目として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'生理がはじまるピル番号をタップ'**
  String get selectPillNumberForMenstruationStart;

  /// ピルシートUI上で複数のシートがある場合に、現在表示しているピルシートが何枚目かを示す順序表示です。「1枚目」「2枚目」のように数値とともに使用されます。
  ///
  /// In ja, this message translates to:
  /// **'{number}枚目'**
  String countOfSheet(int number);

  /// 新しいピルシート（1ヶ月分のピルパック）の服用を開始するためのボタンやメニュー項目に表示されるテキストです。ユーザーが前のシートを終了して新しいサイクルを始める際に使用します。
  ///
  /// In ja, this message translates to:
  /// **'新しいピルシート開始 ▶︎'**
  String get newPillSheetStart;

  /// アプリの初期設定やピル変更時に、使用するピルの種類（21日タイプ、28日タイプなど）を選択するためのボタンやメニュー項目に表示されるテキストです。ユーザーが自分の服用しているピルに合わせて適切な種類を選択する際に使用されます。
  ///
  /// In ja, this message translates to:
  /// **'ピルの種類を選択'**
  String get selectPillType;

  /// ピルの種類選択時に表示される選択肢で、1シートに21錠入ったピル（21日間服用タイプ）を表します。ユーザーが自分の使用しているピルの種類を選択する際の医療用語として正確に翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'21錠'**
  String get twentyOnePills;

  /// ピルの種類選択時に表示される選択肢で、1シートに28錠入ったピル（28日間連続服用タイプ）を表します。ユーザーが自分の使用しているピルの種類を選択する際の医療用語として正確に翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'28錠'**
  String get twentyEightPills;

  /// ピルの種類選択時に表示される選択肢で、1シートに24錠入ったピルを表します。ユーザーが自分の使用しているピルの種類を選択する際の医療用語として正確に翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'24錠'**
  String get twentyFourPills;

  /// ピルの種類選択時に表示される選択肢で、21日間連続でピルを服用した後、7日間休薬する服用スケジュールを表します。医療用語として正確に翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'21錠＋7日休薬'**
  String get twentyOnePlusSevenDaysBreak;

  /// ピルの種類選択時に表示される選択肢で、28日間のピルシートのうち24日間は有効成分入りの錠剤、4日間は休薬期間用のプラセボ（偽薬）錠剤を服用する服用スケジュールを表します。医療用語として正確に翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'24錠＋4錠偽薬'**
  String get twentyFourPlusFourPlacebo;

  /// ピルの種類選択で表示される28日間の服用スケジュールで、21日間は有効成分入りの錠剤、7日間は休薬期間用のプラセボ（偽薬）を服用することを表します。医療用語として正確に翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'21錠＋7錠偽薬'**
  String get twentyOnePlusSevenPlacebo;

  /// ピルの種類選択で表示される、28日間すべてが有効成分入りの錠剤（プラセボなし）であることを表す医療用語です。
  ///
  /// In ja, this message translates to:
  /// **'すべて実薬'**
  String get allActivePills;

  /// 24日間ピルを服用し4日間休薬する、28日周期のピル服用パターンを表す医療用語です。
  ///
  /// In ja, this message translates to:
  /// **'24錠＋4錠休薬'**
  String get twentyFourPlusFourDaysBreak;

  /// ピルの初期設定時に表示される、ユーザーが使用するピルの服用パターン（21日型、28日型など）を選択する画面で使用されるボタンやラベルのテキストです。
  ///
  /// In ja, this message translates to:
  /// **'ピルの種類を選ぶ'**
  String get choosePillType;

  /// ピルシートの休薬期間やプラセボ期間など、薬を服用しない期間に関するプッシュ通知のタイトルとして使用されます。プレースホルダーには「休薬」「プラセボ」などの期間タイプが入ります。
  ///
  /// In ja, this message translates to:
  /// **'{pillSheetPillSheetTypeNotTakenWord}期間の通知'**
  String notificationForNotTakenPeriod(String pillSheetPillSheetTypeNotTakenWord);

  /// プッシュ通知機能がオフの状態でも、休薬期間（プラセボ期間）の服用記録が自動的に作成されることを説明するメッセージです。{pillSheetPillSheetTypeNotTakenWord}は「休薬期間」「プラセボ期間」などの期間名が入るプレースホルダーです。
  ///
  /// In ja, this message translates to:
  /// **'通知オフの場合は、{pillSheetPillSheetTypeNotTakenWord}期間の服用記録も自動で付けられます'**
  String autoRecordForNotTakenPeriodIfNotificationOff(String pillSheetPillSheetTypeNotTakenWord);

  /// ユーザーがプレミアムプランの解約手続きを完了した後に表示される、解約理由などを聞くアンケートへの協力をお願いするメッセージです。丁寧で協力的なトーンで翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'解約後のアンケートご協力のお願い'**
  String get requestForCancelSurvey;

  /// アプリストアなどで表示されるPilllアプリの短い説明文です。ピル（避妊薬）の服用管理に特化したリマインダーアプリであることを簡潔で魅力的に表現してください。
  ///
  /// In ja, this message translates to:
  /// **'Pilll ピル服用に特化したピルリマインダーアプリ'**
  String get pilllDescription;

  /// ピルの服用リマインダー時刻を登録する際、設定可能な上限数に達した時に表示されるエラーメッセージです。ユーザーに対してリマインダー時刻の数を制限内（{ReminderTimeMaximumCount}で指定された件数以内）に収めるよう促しています。
  ///
  /// In ja, this message translates to:
  /// **'登録できる上限に達しました。{ReminderTimeMaximumCount}件以内に収めてください'**
  String reachedMaximumCountOfReminderTimes(int ReminderTimeMaximumCount);

  /// ピルの服用リマインド通知を設定する際に、必要最低限の通知時間数が設定されていない場合に表示されるエラーメッセージです。ユーザーが通知設定で最低限必要な件数を満たしていない時に警告として表示されます。
  ///
  /// In ja, this message translates to:
  /// **'通知時間は最低{ReminderTimeMinimumCount}件必要です'**
  String minimumCountOfReminderTimes(int ReminderTimeMinimumCount);

  /// アプリ内課金処理中に予期しないエラーが発生した際にユーザーに表示されるメッセージです。エラーの詳細情報と共に、再試行や問い合わせ方法を案内しています。
  ///
  /// In ja, this message translates to:
  /// **'原因不明のエラーが発生しました。時間をおいて再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: {exceptionMessage}:{exceptionDetails}'**
  String purchaseErrorUnknownError(String exceptionMessage, String exceptionDetails);

  /// アプリ内課金の購入時にApp StoreやGoogle Playなどのストアで問題が発生した際のエラーメッセージです。{storeName}には各プラットフォームのストア名が入ります。
  ///
  /// In ja, this message translates to:
  /// **'{storeName} でエラーが発生しています。しばらくお時間をおいて再度お試しください'**
  String purchaseErrorStoreProblemError(String storeName);

  /// アプリ内課金でプレミアムプランを購入しようとした際に、端末側の設定や制限により購入ができない場合に表示されるエラーメッセージです。
  ///
  /// In ja, this message translates to:
  /// **'このデバイスで購入が許可されていません'**
  String get purchaseErrorPurchaseNotAllowedError;

  /// アプリ内課金でプレミアムプランを購入する際に、支払い方法が無効または支払い処理に失敗した場合に表示されるエラーメッセージです。
  ///
  /// In ja, this message translates to:
  /// **'支払いに失敗しました。有効な支払い方法かどうかをご確認の上再度お試しください'**
  String get purchaseErrorPurchaseInvalidError;

  /// アプリ内課金でプレミアムプランを購入しようとした際に、選択したプランが一時的に利用できない状態の場合に表示されるエラーメッセージです。ユーザーにアプリの再起動を促す内容が含まれます。
  ///
  /// In ja, this message translates to:
  /// **'対象のプランは現在販売しておりません。お手数ですがアプリを再起動の上お試しください'**
  String get purchaseErrorProductNotAvailableForPurchaseError;

  /// すでにプレミアムプランを購入済みのユーザーが再度購入しようとした際に表示されるエラーメッセージです。購入情報の復元方法を案内する内容が含まれます。
  ///
  /// In ja, this message translates to:
  /// **'すでにプランを購入済みです。この端末で購入情報を復元する場合は「以前購入した方はこちら」から購入情報を復元してくさい'**
  String get purchaseErrorProductAlreadyPurchasedError;

  /// プレミアムプラン購入時に、購入情報（レシート）が既に別のユーザーアカウントで使用されている場合に表示されるエラーメッセージです。ユーザーにアカウント確認を促す内容が含まれます。
  ///
  /// In ja, this message translates to:
  /// **'既に購入済み。もくは購入情報は別のユーザーで使用されています。{accountName}を確認してください'**
  String purchaseErrorReceiptAlreadyInUseError(String accountName);

  /// アプリ内課金でプレミアムプラン購入時に、レシート情報が無効だった場合に表示されるエラーメッセージです。ユーザーに購入情報の確認を促す内容にしてください。
  ///
  /// In ja, this message translates to:
  /// **'不正な購入情報です。購入情報を確かめてください'**
  String get purchaseErrorInvalidReceiptError;

  /// アプリ内課金でプレミアムプラン購入時に、デバイスにサインインしているアカウントと購入情報が一致しない場合に表示されるエラーメッセージです。ユーザーに正しいアカウントでのサインインを促す内容にしてください。
  ///
  /// In ja, this message translates to:
  /// **'購入者の情報が存在しません。{accountName} で端末にサインインをした上でお試しください'**
  String purchaseErrorMissingReceiptFileError(String accountName);

  /// アプリ内課金（プレミアムプラン購入）時にネットワーク接続が不安定な場合に表示されるエラーメッセージです。ユーザーに接続状況の確認と再試行を促す内容で翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'ネットワーク状態が不安定です。接続状況を確認した上でお試しください。'**
  String get purchaseErrorNetworkError;

  /// アプリ内課金（プレミアムプラン購入）時に無効な認証情報が原因で購入が失敗した場合に表示されるエラーメッセージです。ユーザーに時間をおいて再試行を促し、解決しない場合はサポートへの連絡を案内する内容で翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'購入に失敗しました。時間をおいて再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: {exceptionMessage}:{exceptionDetails}'**
  String purchaseErrorInvalidCredentialsError(String exceptionMessage, String exceptionDetails);

  /// アプリ内でプレミアムプラン購入時に予期しないサーバーエラーが発生した際に表示されるエラーメッセージです。ユーザーに再試行を促し、問題が解決しない場合のサポート連絡方法を案内します。
  ///
  /// In ja, this message translates to:
  /// **'現在購入ができません。時間をおいて再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: {exceptionMessage}:{exceptionDetails}'**
  String purchaseErrorUnexpectedBackendResponseError(String exceptionMessage, String exceptionDetails);

  /// アプリ内課金（プレミアムプラン）で、同じ購入レシートが別のユーザーアカウントで既に使用されている場合に表示されるエラーメッセージです。ユーザーにデバイスにログインしているアカウント名を確認するよう促しています。
  ///
  /// In ja, this message translates to:
  /// **'購入情報は別のユーザーで使用されています。端末にログインしている{accountName}を確認してください'**
  String purchaseErrorReceiptInUseByOtherSubscriberError(String accountName);

  /// アプリ内課金時にユーザーIDの検証に失敗した場合のエラーメッセージです。アプリの再起動を促し、技術的なエラー詳細も表示されます。
  ///
  /// In ja, this message translates to:
  /// **'ユーザーが確認できませんでした。アプリを再起動の上再度お試しください。詳細: {exceptionMessage}:{exceptionDetails}'**
  String purchaseErrorInvalidAppUserIdError(String exceptionMessage, String exceptionDetails);

  /// アプリ内課金処理中に別の購入操作が実行された際に表示されるエラーメッセージです。ユーザーに重複した購入処理を避けるよう促すメッセージとして使用されます。
  ///
  /// In ja, this message translates to:
  /// **'購入処理が別途進んでおります。お時間をおいて再度ご確認ください'**
  String get purchaseErrorOperationAlreadyInProgressError;

  /// アプリ内課金処理で不明なバックエンドエラーが発生した際に表示されるエラーメッセージです。ユーザーに購入の一時的な失敗を伝え、再試行を促すとともに、問題が継続する場合のサポート連絡先を案内する内容として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'現在購入ができません。時間をおいて再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: {exceptionMessage}:{exceptionDetails}'**
  String purchaseErrorUnknownBackendError(String exceptionMessage, String exceptionDetails);

  /// Apple App Storeでのサブスクリプション購入失敗時に表示されるエラーメッセージです。ユーザーに再試行を促し、解決しない場合のサポート連絡方法と技術的な詳細情報を案内する内容です。
  ///
  /// In ja, this message translates to:
  /// **'購入に失敗しました。時間をおいて再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: {exceptionMessage}:{exceptionDetails}'**
  String purchaseErrorInvalidAppleSubscriptionKeyError(String exceptionMessage, String exceptionDetails);

  /// アプリ内課金（プレミアムプラン購入）でユーザーが購入資格を満たしていない場合に表示されるエラーメッセージです。一時的な問題の可能性もあるため、再試行とサポート連絡を案内しています。
  ///
  /// In ja, this message translates to:
  /// **'お使いのユーザーでの購入に失敗しました。時間をおいて再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: {exceptionMessage}:{exceptionDetails}'**
  String purchaseErrorIneligibleError(String exceptionMessage, String exceptionDetails);

  /// アプリ内課金でプレミアムプランに加入しようとした際に、ユーザーのApple IDやGoogle アカウントに課金権限がない場合に表示されるエラーメッセージです。アカウント設定や支払い方法に問題があることをユーザーに伝える内容です。
  ///
  /// In ja, this message translates to:
  /// **'お使いの {accountName} ではプランへの加入ができません。お支払い情報をご確認の上再度お試しください'**
  String purchaseErrorInsufficientPermissionsError(String accountName);

  /// アプリ内課金の支払い処理が中断された際に表示されるエラーメッセージです。ユーザーにストア（App Store/Google Play）で支払い状況を確認するよう案内します。
  ///
  /// In ja, this message translates to:
  /// **'支払いが途中で止まっております。ログイン中の{accountName}で{storeName}をお確かめくだい'**
  String purchaseErrorPaymentPendingError(String accountName, String storeName);

  /// プレミアムプランなどの有料機能の購入処理でエラーが発生した際にユーザーに表示されるメッセージです。購入失敗の原因を説明し、再試行やサポートへの問い合わせ方法を案内する内容になります。
  ///
  /// In ja, this message translates to:
  /// **'購入に失敗しました。時間をおいて再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: {exceptionMessage}:{exceptionDetails}'**
  String purchaseErrorInvalidSubscriberAttributesError(String exceptionMessage, String exceptionDetails);

  /// プレミアムプラン購入時にユーザー情報の取得に失敗した際のエラーメッセージです。再試行とサポートへの問い合わせ方法を案内しています。
  ///
  /// In ja, this message translates to:
  /// **'ユーザー情報を取得失敗しました。時間をおいて再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: {exceptionMessage}:{exceptionDetails}'**
  String purchaseErrorLogOutWithAnonymousUserError(String exceptionMessage, String exceptionDetails);

  /// アプリ内課金（プレミアムプラン）の設定情報取得に失敗した際に表示されるエラーメッセージです。ユーザーに再試行を促し、問題が解決しない場合はサポートへの問い合わせを案内する内容です。
  ///
  /// In ja, this message translates to:
  /// **'購入情報取得に失敗しました。時間をおいて再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: {exceptionMessage}:{exceptionDetails}'**
  String purchaseErrorConfigurationError(String exceptionMessage, String exceptionDetails);

  /// アプリ内課金（プレミアムプラン購入）で未対応のエラーが発生した際にユーザーに表示されるエラーメッセージです。アップデートやサポート連絡を促す丁寧な案内文として翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'原因不明のエラーです。最新版にアップデートして再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。コード: {errorCode} 詳細: {exceptionMessage}:{exceptionDetails}'**
  String purchaseErrorUnsupportedError(String errorCode, String exceptionMessage, String exceptionDetails);

  /// アプリ内課金でプレミアムプラン購入時に、ユーザー情報の取得に失敗した場合に表示される技術的なエラーメッセージです。
  ///
  /// In ja, this message translates to:
  /// **'原因不明のエラーです。購入情報を事前に取得できませんでした。詳細: {exceptionMessage}:{exceptionDetails}'**
  String purchaseErrorEmptySubscriberAttributesError(String exceptionMessage, String exceptionDetails);

  /// アプリ内課金でプレミアムプランを購入する際、商品の割引情報の識別子が見つからない場合に表示されるエラーメッセージです。
  ///
  /// In ja, this message translates to:
  /// **'原因不明のエラーです。最新版にアップデートして再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。コード: {errorCode} 詳細: {exceptionMessage}:{exceptionDetails}'**
  String purchaseErrorProductDiscountMissingIdentifierError(String errorCode, String exceptionMessage, String exceptionDetails);

  /// プレミアムプラン購入時に発生する原因不明のエラーをユーザーに伝えるメッセージです。アプリの更新や問い合わせ方法を案内し、技術的なエラー情報（コード・詳細）も含まれます。
  ///
  /// In ja, this message translates to:
  /// **'原因不明のエラーです。最新版にアップデートして再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。コード: {errorCode} 詳細: {exceptionMessage}:{exceptionDetails}'**
  String purchaseErrorUnknownNonNativeError(String errorCode, String exceptionMessage, String exceptionDetails);

  /// プレミアムプラン購入時に発生する技術的なエラーのメッセージです。ユーザーには原因不明として一般的な対処法（アップデート、問い合わせ）を案内します。
  ///
  /// In ja, this message translates to:
  /// **'原因不明のエラーです。最新版にアップデートして再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。コード: {errorCode} 詳細: {exceptionMessage}:{exceptionDetails}'**
  String purchaseErrorProductDiscountMissingSubscriptionGroupIdentifierError(String errorCode, String exceptionMessage, String exceptionDetails);

  /// プレミアムプランの購入処理で、課金システムから顧客情報を取得できない場合に表示されるエラーメッセージです。一時的なネットワークエラーやサーバー障害が原因で発生することが多いエラーです。
  ///
  /// In ja, this message translates to:
  /// **'顧客情報の取得に失敗しました。時間をおいて再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: コード: {errorCode} {exceptionMessage}:{exceptionDetails}'**
  String purchaseErrorCustomerInfoError(String errorCode, String exceptionMessage, String exceptionDetails);

  /// プレミアム機能の購入時にデバイス設定の問題で決済に失敗した場合に表示されるエラーメッセージです。ユーザーに設定確認と問い合わせ方法を案内する内容です。
  ///
  /// In ja, this message translates to:
  /// **'端末の設定に問題があります。確認して再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。コード: {errorCode} 詳細: {exceptionMessage}:{exceptionDetails}'**
  String purchaseErrorSystemInfoError(String errorCode, String exceptionMessage, String exceptionDetails);

  /// アプリ内課金のプレミアムプランで返金処理が開始された際に表示されるエラーメッセージです。ユーザーに状況確認と再試行を促し、解決しない場合のサポート連絡先も案内する内容です。
  ///
  /// In ja, this message translates to:
  /// **'返金処理が開始されています。確認して再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。コード: {errorCode} 詳細: {exceptionMessage}:{exceptionDetails}'**
  String purchaseErrorBeginRefundRequestError(String errorCode, String exceptionMessage, String exceptionDetails);

  /// アプリ内課金のプロダクト情報取得時にネットワークタイムアウトが発生した際のエラーメッセージです。ユーザーに通信環境の確認と再試行、問題が解決しない場合のサポート問い合わせを案内します。
  ///
  /// In ja, this message translates to:
  /// **'タイムアウトしました。通信環境をお確かめの上再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: {exceptionMessage}:{exceptionDetails}'**
  String purchaseErrorProductRequestTimeout(String exceptionMessage, String exceptionDetails);

  /// アプリ内課金（プレミアムプラン購入）時にAPIエンドポイントがブロックされた際に表示されるエラーメッセージです。ユーザーにアプリの更新と問い合わせ方法を案内する内容になります。
  ///
  /// In ja, this message translates to:
  /// **'原因不明のエラーです。最新版にアップデートして再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。コード: {errorCode} 詳細: {exceptionMessage}:{exceptionDetails}'**
  String purchaseErrorApiEndpointBlocked(String errorCode, String exceptionMessage, String exceptionDetails);

  /// アプリ内課金でプロモーション・割引プランの購入に失敗した際に表示されるエラーメッセージです。ユーザーにアップデートと再試行、問い合わせを促す内容にしてください。
  ///
  /// In ja, this message translates to:
  /// **'原因不明のエラーです。最新版にアップデートして再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。コード: {errorCode} 詳細: {exceptionMessage}:{exceptionDetails}'**
  String purchaseErrorInvalidPromotionalOfferError(String errorCode, String exceptionMessage, String exceptionDetails);

  /// アプリ内課金処理時にネットワーク接続エラーが発生した際に表示されるエラーメッセージです。ユーザーに通信環境の確認と再試行を促し、問題が続く場合のサポート連絡方法を案内しています。
  ///
  /// In ja, this message translates to:
  /// **'通信不良です。通信環境をお確かめの上再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: {exceptionMessage}:{exceptionDetails}'**
  String purchaseErrorOfflineConnectionError(String exceptionMessage, String exceptionDetails);

  /// アプリの新しいバージョンが必要で、ユーザーが強制的にアップデートしなければならない状況で表示されるタイトルです。緊急性を伝えつつ、丁寧な表現で更新を促してください。
  ///
  /// In ja, this message translates to:
  /// **'アプリをアップデートしてください'**
  String get forceUpdateTitle;

  /// アプリのバージョンが古いため、強制的にアップデートが必要な場合にユーザーに表示されるメッセージです。{storeName}にはApp StoreやGoogle Play Storeなどのストア名が入ります。
  ///
  /// In ja, this message translates to:
  /// **'お使いのアプリのバージョンのアップデートをお願いしております。{storeName}から最新バージョンにアップデートしてください'**
  String forceUpdateMessage(String storeName);

  /// アプリの予定機能で使用される項目です。定期的な医療機関への通院予定を指し、継続的な医療ケアのニュアンスを含みます。
  ///
  /// In ja, this message translates to:
  /// **'通院する'**
  String get visitHospital;

  /// ピル服用のリマインダー通知を当日の朝9:00に受け取る設定項目です。
  ///
  /// In ja, this message translates to:
  /// **'当日9:00に通知を受け取る'**
  String get receiveNotificationAt9AM;

  /// 通院予定や服用スケジュールなどの予定を削除する際に表示される警告メッセージです。一度削除した予定は元に戻せないことをユーザーに注意喚起しています。
  ///
  /// In ja, this message translates to:
  /// **'削除された予定は復元ができません'**
  String get deletedScheduleCannotBeRestored;

  /// 通院予定や服用スケジュールなどの予定を削除する際のボタンやメニューのラベルです。ユーザーが予定を削除したいときに表示される操作名称として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'予定を削除します'**
  String get deleteSchedule;

  /// 特定の機能がiOSアプリでのみ利用可能であることをユーザーに伝えるメッセージです。Androidユーザーがその機能にアクセスしようとした際などに表示される説明文として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'iOSアプリにのみ対応しています'**
  String get onlySupportiOS;

  /// AppleのHealthKit（ヘルスケア機能）に対応していない端末で、健康データ連携機能を利用しようとした際に表示されるエラーメッセージです。ユーザーに機能制限があることを丁寧に伝える文章として翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'ヘルスケアに対応していない端末ではご利用できません'**
  String get healthKitDoesNotSupport;

  /// AppleのHealthKit（ヘルスケア機能）との連携を有効にするため、ユーザーにiOSの設定アプリでの操作を促すメッセージです。ピルの服用記録や健康データをHealthKitと同期する機能を使用する際に表示されます。
  ///
  /// In ja, this message translates to:
  /// **'設定アプリよりヘルスケアを有効にしてください'**
  String get enableHealthKitFromSettings;

  /// ソーシャルログイン（Google、Apple等）のアカウントが既にユーザーのPilllアカウントと連携済みの場合に表示されるエラーメッセージです。アカウント連携時の重複エラーを説明し、画面更新やFAQ確認による解決方法を案内しています。
  ///
  /// In ja, this message translates to:
  /// **'この{accountTypeProviderName}アカウントはすでにお使いのPilllのアカウントに紐付いています。画面の更新をお試しください。FAQもご覧ください。詳細: {exceptionMessage}'**
  String accountAlreadyLinked(String accountTypeProviderName, String exceptionMessage);

  /// アカウント登録時に、GoogleやAppleアカウントなど外部アカウントが既に他のPilllアカウントに連携済みで登録できない場合のエラーメッセージです。FAQへの誘導とエラー詳細の表示も含みます。
  ///
  /// In ja, this message translates to:
  /// **'この{accountTypeProviderName}アカウントはすでに他のPilllのアカウントに紐付いているため登録ができません。FAQもご覧ください。詳細: {exceptionMessage}'**
  String accountAlreadyLinkedWithOtherPilllAccount(String accountTypeProviderName, String exceptionMessage);

  /// ユーザーがGoogle/Appleアカウントなどで登録しようとした際、そのメールアドレスが既に別のPilllアカウントと紐付いているため新規登録できない旨を伝えるエラーメッセージです。アカウント重複を防ぐためのシステムメッセージなので、ユーザーが状況を理解し適切な対処法（FAQ参照）を取れるよう明確に翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'すでに{accountTypeProviderName}アカウントでお使いのメールアドレスが他のPilllアカウントに紐付いているため登録ができません。FAQもご覧ください。詳細: {exceptionMessage}'**
  String emailAlreadyInUse(String accountTypeProviderName, String exceptionMessage);

  /// カレンダー機能で表示される「今日の予定・スケジュール」のタイトルです。ピルの服用予定や通院予定などの健康管理に関する今日の予定を指します。
  ///
  /// In ja, this message translates to:
  /// **'本日の予定です'**
  String get todaySchedule;

  /// カレンダー機能で表示される予定やスケジュールの総称です。ピルの服用予定、通院予定、生理予定などの健康管理に関する様々な予定を指します。
  ///
  /// In ja, this message translates to:
  /// **'カレンダーの予定'**
  String get calendarSchedule;

  /// 新しいピルシート（薬のパッケージ）の服用が開始される際に表示されるプッシュ通知のタイトルです。ピルの新しい服用サイクルの開始を利用者に知らせる重要な通知メッセージです。
  ///
  /// In ja, this message translates to:
  /// **'今日から新しいシートがはじまります'**
  String get newPillSheetNotificationTitle;

  /// 新しいピルシート（薬のパッケージ）の服用サイクルが開始される際にユーザーに送信されるプッシュ通知のメッセージです。ピルの新しい服用周期の開始を知らせ、飲み忘れを防ぐための重要なリマインド通知として機能します。
  ///
  /// In ja, this message translates to:
  /// **'🆕 今日から新しいシートが始まります\n忘れずに服用しましょう👍'**
  String get newPillSheetNotificationMessage;

  /// アプリ内でプレミアム機能の権限情報を取得できない場合に表示されるエラーメッセージです。ユーザーには技術的な問題が発生していることを簡潔に伝える文言として翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'プレミアム情報が見つかりませんでした'**
  String get unexpectedPremiumEntitlementsIsNotExists;

  /// アプリ内でプレミアム機能を購入した際、決済処理がまだ完了していない（保留中）状態の時にユーザーに表示されるエラーメッセージです。ユーザーには購入手続きが進行中であることを伝え、しばらく待ってから再度確認するよう案内する文言として翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'課金の有効化が完了しておりません。しばらく時間をおいてからご確認ください'**
  String get purchaseErrorPurchasePendingError;

  /// アプリの起動時（アプリを開いた瞬間）に何らかの技術的エラーが発生した場合にユーザーに表示されるエラーメッセージです。接続エラーなどの詳細情報も含まれるため、ユーザーが状況を理解できるよう翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'アプリの起動時（アプリを開いた瞬間）に何らかの技術的エラーが発生した場合にユーザーに表示されるエラーメッセージです。接続エラーなどの詳細情報も含まれるため、ユーザーが状況を理解できるよう翻訳してください。'**
  String launchError(String ErrorMessagesConnection);

  /// ピルの服用を一時的に休止する期間の入力例を示すテキストです。具体的な日付（1/12）と日数（3日間）を使って、ユーザーがアプリでどう休薬期間を指定するかを説明しています。
  ///
  /// In ja, this message translates to:
  /// **'例えば「1/12から3日間」服用お休みした場合'**
  String get exampleRestDurationDate;

  /// ピルシートの特定の錠剤番号（18番）から一定期間（3日間）服用を休止する場合の入力例を示すテキストです。ユーザーが休薬期間を記録する際の具体的な使用例として表示されます。
  ///
  /// In ja, this message translates to:
  /// **'例えば「18番から3日間」服用お休みした場合'**
  String get exampleRestDurationNumber;

  /// ピルシートの錠剤番号を表示するためのテキストです。{number}には具体的な錠剤番号（例：18）が入り、ユーザーがピルシート上のどの錠剤かを特定するために使用されます。
  ///
  /// In ja, this message translates to:
  /// **'{number}番'**
  String withNumber(String number);

  /// ユーザーが現在服用中のピルシートのデータがアプリ内で見つからない場合に表示されるエラーメッセージです。
  ///
  /// In ja, this message translates to:
  /// **'現在対象となっているピルシートが見つかりませんでした'**
  String get currentPillSheetNotFound;

  /// ユーザーがピルの服用記録を取り消そうとした際、休薬期間（プラセボ期間）中のため操作できないことを知らせるエラーメッセージです。ピル服薬管理における医学的な制約を説明する重要な通知です。
  ///
  /// In ja, this message translates to:
  /// **'ピルの服用の取り消し操作は休薬期間中は実行できません'**
  String get doNotRevertTakePillInPausePeriod;

  /// アプリへのログインや設定画面で表示されるGoogleアカウントのラベルです。ユーザー認証やデータ同期に使用されます。
  ///
  /// In ja, this message translates to:
  /// **'Google アカウント'**
  String get googleAccount;

  /// アプリ内の日記機能で体調や気分を記録する際に表示されるボタンやラベルのテキストです。カレンダー画面から日々の体調記録を行う機能に使用されます。
  ///
  /// In ja, this message translates to:
  /// **'日記を記録'**
  String get diaryRecord;

  /// アプリ内のカレンダー機能で、ユーザーが将来の予定（通院予定や生理予定など）を記録・追加する際に表示されるボタンやラベルのテキストです。
  ///
  /// In ja, this message translates to:
  /// **'予定を記入'**
  String get scheduleRecord;

  /// アプリでピルシートの履歴を確認する際、前回使用していたピルシートのグループデータが見つからない場合に表示されるエラーメッセージです。
  ///
  /// In ja, this message translates to:
  /// **'前回のピルシートグループがまだ存在しません'**
  String get previousPillSheetGroupNotFound;

  /// ピルシートの枚数を表示する際に使用される文字列で、数値の後に枚数を表す単位語が続きます。ピルの在庫管理や履歴表示などで「3枚」「5枚」のように表示されます。
  ///
  /// In ja, this message translates to:
  /// **'{number}枚'**
  String withPillSheetCount(int number);

  /// ネットワーク通信に失敗した際にユーザーに表示されるエラーメッセージです。アプリの主要機能（服用記録の同期等）で通信エラーが発生した時に使用されます。
  ///
  /// In ja, this message translates to:
  /// **'通信環境が不安定のようです。時間をおいて再度お試しください'**
  String get connectionError;

  /// アプリ内で予期しない一般的なエラーが発生した際にユーザーに表示されるメッセージです。サーバーエラーや処理失敗など、具体的な原因が不明な場合に再試行を促すために使用されます。
  ///
  /// In ja, this message translates to:
  /// **'エラーが発生しました。時間をおいて再度お試しください'**
  String get unknownErrorAndRetryAfter;

  /// アプリ内で予期しない一般的なエラーが発生した際にユーザーに表示される基本的なエラーメッセージです。具体的な原因を伝えずに、シンプルにエラーの発生を通知する場合に使用されます。
  ///
  /// In ja, this message translates to:
  /// **'エラーが発生しました'**
  String get errorOccurred;

  /// アプリ内で予期しない技術的エラーが発生した際にユーザーに表示される汎用的なエラーメッセージです。具体的な原因を特定できない場合に使用され、ユーザーに対してシンプルで理解しやすい表現が求められます。
  ///
  /// In ja, this message translates to:
  /// **'不明なエラーが発生しました'**
  String get unknownError;

  /// アプリ内で予期しない技術的エラーが発生した際にユーザーに表示される汎用的なエラーメッセージです。ピルの服用管理という健康に関わる重要な機能で使用されるため、ユーザーに不安を与えすぎない、親しみやすく理解しやすい表現が求められます。
  ///
  /// In ja, this message translates to:
  /// **'予期しないエラーが発生しました'**
  String get unexpectedErrorOccurred;

  /// ピル服用のリマインド通知を長押しすることで、アプリ内で服用記録を簡単に作成できる機能の説明です。ユーザーの利便性を伝える操作ガイダンス文です。
  ///
  /// In ja, this message translates to:
  /// **'通知を長押しすると服用記録ができます'**
  String get pressAndHoldNotificationToRecordPillTaking;

  /// 機能説明の後でユーザーに実際にその機能を使ってみることを勧める行動促進メッセージです。親しみやすく前向きな表現で翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'ぜひお試しください'**
  String get letsTryIt;

  /// プレミアム機能の無料トライアル期間中にすべての機能が利用可能であることをユーザーに伝える励ましのメッセージです。ポジティブで親しみやすい表現で翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'{number}日間すべての機能が使えます！'**
  String trialDeadlineDateOffsetDay(int number);

  /// 何かの情報を手動で入力・追加する際のボタンやラベルのテキストです。服用記録や予定などをユーザーが自分で入力して追加する場面で使用されます。
  ///
  /// In ja, this message translates to:
  /// **'入力して追加'**
  String get inputAndAdd;

  /// ユーザーの生理の平均周期（日数）を表示するラベルです。生理管理機能で使用され、過去のデータから算出された平均的な生理周期の長さを示します。
  ///
  /// In ja, this message translates to:
  /// **'平均周期'**
  String get averagePeriod;

  /// 生理管理機能で、ユーザーの過去のデータから算出された生理周期の平均日数を表示する際に使用されるラベルです。数値と併せて「平均○日」のような形で表示されます。
  ///
  /// In ja, this message translates to:
  /// **'平均日数'**
  String get averageDays;

  /// 時間の単位を表す「日」で、生理周期や服用日数などの数値と組み合わせて表示されます。言語によって単数形・複数形の使い分けが必要な場合があります。
  ///
  /// In ja, this message translates to:
  /// **'日'**
  String get days;

  /// 日記機能で体調や症状と合わせて自由にメモを記録できる入力欄のラベルです。短い単語で「メモ」や「記録」のような意味の翻訳が適切です。
  ///
  /// In ja, this message translates to:
  /// **'メモ'**
  String get memo;

  /// ピルの服用記録や生理記録などのデータをサーバーに保存・更新する際にネットワークエラーが発生した時に表示されるエラーメッセージです。ユーザーに通信状況の確認と再操作を促す丁寧な表現で翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'更新に失敗しました。通信環境をお確かめの上、再度変更してください'**
  String get failedToUpdate;

  /// 女性の健康管理アプリにおいて、体調記録や日記機能でユーザーが症状として記録する際に使用される医学的な用語です。各言語で一般的に使われる「頭痛」の適切な医療用語で翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'頭痛'**
  String get headache;

  /// 女性の健康管理アプリにおいて、体調記録や日記機能でユーザーが症状として記録する際に使用される医学的な用語です。各言語で一般的に使われる「腹痛」の適切な医療用語で翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'腹痛'**
  String get abdominalPain;

  /// 女性の健康管理アプリにおいて、体調記録や日記機能でユーザーが症状として記録する際に使用される医学的な用語です。各言語で一般的に使われる「吐き気」の適切な医療用語で翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'吐き気'**
  String get nausea;

  /// 女性の健康管理アプリにおいて、体調記録や日記機能でユーザーが症状として記録する際に使用される医学的な用語です。各言語で一般的に使われる「貧血」の適切な医療用語で翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'貧血'**
  String get anemia;

  /// 女性の健康管理アプリにおいて、体調記録や日記機能でユーザーが症状として記録する際に使用される医学的な用語です。各言語で一般的に使われる「下痢」の適切な医療用語で翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'下痢'**
  String get diarrhea;

  /// 女性の健康管理アプリにおいて、体調記録や日記機能でユーザーが症状として記録する際に使用される医学的な用語です。各言語で一般的に使われる「便秘」の適切な医療用語で翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'便秘'**
  String get constipation;

  /// 女性の健康管理アプリにおいて、体調記録や日記機能でユーザーが症状として記録する際に使用される医学的な用語です。各言語で一般的に使われる「眠気」の適切な医療用語で翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'眠気'**
  String get drowsiness;

  /// 女性の健康管理アプリにおいて、体調記録や日記機能でユーザーが症状として記録する際に使用される医学的な用語です。各言語で一般的に使われる「腰痛」の適切な医療用語で翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'腰痛'**
  String get backPain;

  /// 女性の健康管理アプリにおいて、体調記録や日記機能でユーザーが症状として記録する際に使用される医学的な用語です。各言語で一般的に使われる「動悸」の適切な医療用語で翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'動悸'**
  String get palpitation;

  /// 女性の健康管理アプリにおいて、体調記録や日記機能でユーザーが症状として記録する際に使用される医学的な用語です。各言語で一般的に使われる「不正出血」の適切な医療用語で翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'不正出血'**
  String get irregularBleeding;

  /// 女性の健康管理アプリにおいて、ユーザーが体調記録や日記機能で症状として記録する際に使用される医学的な用語です。各言語において一般的に使われる「食欲不振」の適切な医療用語で翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'食欲不振'**
  String get lossOfAppetite;

  /// 女性の健康管理アプリにおいて、ユーザーが体調記録や日記機能で症状として記録する際に使用される医学的な用語です。各言語において一般的に使われる「胸の張り」の適切な医療用語で翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'胸の張り'**
  String get chestTightness;

  /// 女性の健康管理アプリにおいて、ユーザーが体調記録や日記機能で体調の変化や不調として記録する際に選択できる症状項目の一つです。各言語において医学的に正確で、一般ユーザーにも理解しやすい「不眠・睡眠障害」の適切な表現で翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'不眠'**
  String get insomnia;

  /// ピルの服用管理アプリにおいて、ユーザーが今日以外の日から服用を一時停止（お休み）したい場合に表示される説明文です。この後に具体的な操作手順や注意事項が続くことを示唆する導入文として機能します。
  ///
  /// In ja, this message translates to:
  /// **'お休みしてください。今日以外の日から服用お休みしたい場合は下記を参考にしてください。'**
  String get pauseStartingOtherDaysInstructions;

  /// ピルの服用を一時的に停止する「服用お休み機能」の使用方法を説明するヘルプページへのリンクテキストです。ユーザーがこの機能の操作方法を学ぶためのガイドに誘導する際に表示されます。
  ///
  /// In ja, this message translates to:
  /// **'服用お休み機能の使い方を見る'**
  String get seeHowToUsePauseTakingFeature;

  /// ピルの服用を一時的に停止する「服用お休み機能」を開始する際に表示されるボタンまたはラベルのテキストです。ユーザーがピルの服用をお休みしたい時にタップする機能の開始を表します。
  ///
  /// In ja, this message translates to:
  /// **'服用お休み開始'**
  String get startPauseTakingLabel;

  /// ユーザーがピルの服用お休み期間（服用を一時停止する期間）を変更した際に表示される確認メッセージです。設定変更が完了したことをユーザーに通知する目的で使用されます。
  ///
  /// In ja, this message translates to:
  /// **'服用お休みを変更しました'**
  String get pauseTakingChanged;

  /// ピルの服用を一時的に停止する期間を設定・変更するためのボタンまたはリンクのテキストです。設定画面や編集画面で表示され、ユーザーが休薬期間を調整する際に使用されます。
  ///
  /// In ja, this message translates to:
  /// **'服用お休み期間を編集'**
  String get editPausePeriod;

  /// ピルの1シートあたりの服用日数を変更する機能のラベルです。ユーザーが自分のピルの種類に合わせて服用期間（21日間、28日間など）を設定する際に表示されます。
  ///
  /// In ja, this message translates to:
  /// **'服用日数を変更'**
  String get changePillDays;

  /// ピルシートの番号範囲を表示する際に使用される文字列です。例えば「1番 ~ 21番」のように、連続する番号の開始と終了を示すフォーマットです。
  ///
  /// In ja, this message translates to:
  /// **'{begin}番 ~ {end}番'**
  String beginToEndNumbers(int begin, int end);

  /// ピルの服用を一時的に中断していた状態から、再び服用を開始する際に使用されるボタンやラベルのテキストです。
  ///
  /// In ja, this message translates to:
  /// **'服用再開'**
  String get resumeTaking;

  /// ピルの服用サイクルにおける休薬期間（通常7日間）の日数を変更する機能です。設定画面やボタンのラベルとして使用されます。
  ///
  /// In ja, this message translates to:
  /// **'服用お休み期間変更'**
  String get changePausePeriod;

  /// ピルの服用サイクルにおける休薬期間（通常7日間）の日数設定を変更した後に表示される完了メッセージです。ユーザーに設定変更が正常に実行されたことを知らせるフィードバック文言として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'服用お休み期間を変更しました'**
  String get changedPausePeriod;

  /// 何かの日付設定を変更した後に表示される完了メッセージです。ユーザーに設定変更が正常に実行されたことを知らせるフィードバック文言として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'{date}に変更しました'**
  String changedToDate(String date);

  /// ピルの服用記録をアプリに保存する際に、技術的な問題により記録処理が失敗した可能性があることをユーザーに伝えるエラーメッセージです。
  ///
  /// In ja, this message translates to:
  /// **'服用記録が失敗した可能性があります'**
  String get quickRecordTakePillFailed;

  /// ピルの服用記録の保存に失敗した際に、ユーザーにアプリを開いて記録状況を確認してもらうためのメッセージです。記録処理エラー時の具体的な行動指示として表示されます。
  ///
  /// In ja, this message translates to:
  /// **'アプリを開いてご確認ください'**
  String get quickRecordTakePillFailedMessage;

  /// ピルの服用状態を表示する際に使用される文言で、ユーザーがすでにピルを服用したことを示します。服用履歴やピルシートUIで表示されます。
  ///
  /// In ja, this message translates to:
  /// **'服用済み'**
  String get alreadyTaken;

  /// ピルの服用管理において、定期的な休薬期間（プラセボ期間）を開始する際にユーザーが選択するボタンやメニュー項目の文言です。生理期間中や医師の指示による一時的な服用中断を意味します。
  ///
  /// In ja, this message translates to:
  /// **'服用をお休みする'**
  String get startPauseTaking;

  /// ピルの服用を一時的に休止（休薬期間やプラセボ期間）することをユーザーが開始した際に表示される確認メッセージです。医師の指示による服用中断や生理期間中の服用停止を意味します。
  ///
  /// In ja, this message translates to:
  /// **'服用お休みを開始しました'**
  String get startedPauseTaking;

  /// 次に服用すべきピルの番号を表示するテキストです。プレースホルダーには数字が入るため、各言語の序数や番号表現に適合させて翻訳してください。
  ///
  /// In ja, this message translates to:
  /// **'{pillSheetGroupSequentialLastTakenPillNumber}番'**
  String sequentialLastTakenPlusOnePillNumber(String pillSheetGroupSequentialLastTakenPillNumber);

  /// ピルシートUIで表示する薬の番号の開始位置を設定する機能のテキストです。ユーザーが任意の番号からピルシートの表示をスタートできるようにする設定項目で使用されます。
  ///
  /// In ja, this message translates to:
  /// **'番からスタート'**
  String get startFromNumber;

  /// ピルの服用記録、生理記録、未来の予定、日記などの新しいデータを追加する際に表示される汎用的なボタンやアクションのテキストです。アプリ内の様々な画面で新規登録や追加機能において使用されます。
  ///
  /// In ja, this message translates to:
  /// **'追加'**
  String get add;

  /// 新しいピル（避妊薬・治療薬）のシート・パックを服用管理対象として追加する際のボタンやアクションのテキストです。ユーザーが新しい薬のパッケージを開始する時に表示されます。
  ///
  /// In ja, this message translates to:
  /// **'ピルシートを追加'**
  String get addPillSheet;

  /// ピルの服用を一時的に休止している状態（休薬期間や服用中断）を表すステータステキストです。ユーザーが現在ピルを飲んでいない期間であることを示します。
  ///
  /// In ja, this message translates to:
  /// **'服用お休み中'**
  String get duringPauseTaking;

  /// 今日のピルを既に服用した後で「服用お休み」機能を使おうとした際に表示されるエラーメッセージです。「服用お休み」はピルの服用を一時的に休止する機能名で、既に服用済みの場合は使用できないことをユーザーに説明しています。
  ///
  /// In ja, this message translates to:
  /// **'今日飲むピルが服用済みの場合\n「服用お休み」できません'**
  String get cannotPauseAlreadyTakenToday;

  /// ユーザーがピルの服用を一時的に休止する「服用お休み」機能を開始した際に表示される確認メッセージです。服用スケジュールが一時停止状態になったことをユーザーに通知しています。
  ///
  /// In ja, this message translates to:
  /// **'服用お休みを開始しました'**
  String get pauseTakingStarted;

  /// 日付と曜日を組み合わせて表示するためのフォーマットです。「12月15日(月)」のように月日の後に括弧内で曜日を表示する形式で、カレンダーや服用記録の日付表示に使用されます。
  ///
  /// In ja, this message translates to:
  /// **'{DateTimeFormatterMonthAndDay}({DateTimeFormatterWeekday})'**
  String formattedDateAndWeekday(String DateTimeFormatterMonthAndDay, String DateTimeFormatterWeekday);

  /// ピルの服用を一時的に休止する期間の開始日を編集する画面やボタンで使用されるテキストです。ユーザーが体調や医師の指示により服用を中断したい場合に設定する機能です。
  ///
  /// In ja, this message translates to:
  /// **'服用お休み開始日を編集'**
  String get editPauseStartDate;

  /// アプリを友達に紹介・推薦する機能で使用されるテキストです。ユーザーがPilllアプリを他の人に勧める際のボタンやメニュー項目として表示されます。
  ///
  /// In ja, this message translates to:
  /// **'友達に教える'**
  String get shareWithFriends;

  /// アプリの設定画面や法的情報画面で表示される利用規約へのリンクテキストです。ユーザーがアプリの使用条件や規約を確認する際にタップする項目として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'利用規約'**
  String get termsOfService;

  /// アプリの設定画面や法的情報画面で表示されるプライバシーポリシーへのリンクテキストです。ユーザーが個人情報の取り扱いに関する規約を確認する際にタップする項目として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'プライバシーポリシー'**
  String get privacyPolicy;

  /// ユーザーがリンクやテキストをクリップボードにコピーした際に表示される成功通知メッセージです。シェア機能やURL共有時などに、コピー操作が完了したことをユーザーに知らせるフィードバックとして使用されます。
  ///
  /// In ja, this message translates to:
  /// **'クリップボードにコピーしました'**
  String get linkCopiedToClipboard;

  /// アプリ内の通知メッセージに番号を付ける際に使用される文字列です。{number}には通知を識別するための数字が入り、複数のピル服用リマインド通知を区別するために使用されます。
  ///
  /// In ja, this message translates to:
  /// **'通知{number}'**
  String notificationNumber(int number);

  /// ピルの服用リマインダーを受け取る時間を設定する際に表示されるラベルです。通知設定画面で「何時に通知を受け取るか」を指定する項目名として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'通知時間'**
  String get notificationTime;

  /// ユーザーがアプリの設定でタイムゾーンを変更した際に表示される確認メッセージです。{tz}部分には具体的なタイムゾーン名（例：Asia/Tokyo）が入り、ピルの服用リマインダー時間に影響する重要な設定変更を知らせます。
  ///
  /// In ja, this message translates to:
  /// **'{tz}に変更しました'**
  String timeZoneChangedTo(String tz);

  /// ピルシートの服用開始日や服用日数のカウント開始日を変更する設定画面で使用されます。ユーザーがピルの服用スケジュールの基準日を調整するための機能です。
  ///
  /// In ja, this message translates to:
  /// **'服用日数の始まりを変更'**
  String get changeStartOfPillDays;

  /// ピルシートの服用終了日や服用日数のカウント終了日を変更する設定画面で使用されます。ユーザーがピルの服用スケジュールの終了タイミングを調整するための機能です。
  ///
  /// In ja, this message translates to:
  /// **'服用日数の終わりを変更'**
  String get changeEndOfPillDays;

  /// ピルシートを新しいものに交換・切り替える際に、システム側で何らかの理由により処理が完了できない場合に表示されるエラーメッセージです。ユーザーに対して、該当するピルシートID付きで更新処理が失敗したことを通知します。
  ///
  /// In ja, this message translates to:
  /// **'ピルシートの置き換えによる更新できません id: {id}'**
  String cannotUpdateToReplacePillSheet(String id);

  /// ピルの服用履歴データの取得に失敗した際に表示されるエラーメッセージです。{error}には具体的なエラー内容が挿入されます。
  ///
  /// In ja, this message translates to:
  /// **'服用履歴情報の取得に失敗しました。{error}'**
  String failedToGetPillSheetHistory(String error);

  /// ユーザーが誤って記録したピルの服用履歴を取り消すためのボタンのラベル。服用管理画面で使用される。
  ///
  /// In ja, this message translates to:
  /// **'服用取り消し'**
  String get cancelTaking;

  /// アプリ内の日記機能（体調記録）で、ユーザーが日記を削除する際に表示される警告メッセージ。削除された記録は元に戻せないことを伝える重要な注意事項です。
  ///
  /// In ja, this message translates to:
  /// **'削除した日記は復元できません'**
  String get deletedDiaryCannotBeRestored;

  /// 生理記録機能で、ユーザーが既に記録した生理期間の開始日や終了日などの情報を後から修正・編集する際に表示されるボタンやメニュー項目のテキストです。
  ///
  /// In ja, this message translates to:
  /// **'生理期間を編集'**
  String get editMenstruation;

  /// ピルシートの番号設定を変更した際の履歴表示で使用される文言です。カレンダー画面の履歴機能でユーザーの過去の操作を示します。
  ///
  /// In ja, this message translates to:
  /// **'ピル番号変更'**
  String get changedPillNumber;

  /// アプリのプレミアムプラン（有料機能）で、年額プランが通常の月額プランと比較して何パーセント安くなるかを示す割引表示メッセージです。課金画面やプラン選択画面で表示されます。
  ///
  /// In ja, this message translates to:
  /// **'通常月額と比べて{offPercent}％OFF'**
  String offPercentForMonthlyPremiumPackage(int offPercent);

  /// 無料期間や割引期間が終了するユーザーに向けて表示されるメッセージです。プレミアムプランに登録することで、引き続きアプリの全機能（服用記録、生理管理、プレミアム限定機能など）が利用できることを案内しています。
  ///
  /// In ja, this message translates to:
  /// **'プレミアム登録で引き続きすべての機能が利用できます'**
  String get premiumIntroductionDiscountPriceDeadline;

  /// 限定割引キャンペーンの締切時間を知らせるメッセージです。プレミアムプラン購入画面で、残り時間（countdown）内に購入すると指定された割引率（offPercent）が適用されることをユーザーに伝えます。
  ///
  /// In ja, this message translates to:
  /// **'{countdown}内の購入で{offPercent}％OFF'**
  String countdownForDiscountPriceDeadline(String countdown, int offPercent);

  /// ユーザーがピルの服用リマインダー時刻を変更した際に表示される確認メッセージです。{value}には変更後の時刻が入ります。
  ///
  /// In ja, this message translates to:
  /// **'服用通知を{value}にしました'**
  String pillReminderChanged(String value);

  /// ピルの服用リマインダー通知が、端末の集中モードや消音設定に関係なく確実に届くことを説明する文章です。服用忘れを防ぐための重要な機能説明として表示されます。
  ///
  /// In ja, this message translates to:
  /// **'集中モードがONまたはデバイスが消音時でも、通知はロック画面に表示され、サウンドが再生されます'**
  String get silentModeNotificationDescription;

  /// ピル服用リマインダー通知の設定項目で、端末がマナーモードや消音設定になっていても確実に通知を届ける機能のオン/オフを切り替えるボタンのラベルです。服用忘れを防ぐための重要な機能として表示されます。
  ///
  /// In ja, this message translates to:
  /// **'マナーモードでも通知する'**
  String get enableNotificationInSilentMode;

  /// 設定画面でマナーモード時でもピル服用の重要な通知を確実に受け取れるようにする機能の設定項目名です。服用忘れを防ぐための重要な通知機能として各言語で適切に表現してください。
  ///
  /// In ja, this message translates to:
  /// **'マナーモードでも通知設定'**
  String get enableNotificationInSilentModeSetting;

  /// マナーモード時でも鳴らすことができるピル服用リマインダーの重要なアラート音量を設定する項目名です。服用忘れを防ぐための重要な通知音の音量レベルとして各言語で適切に表現してください。
  ///
  /// In ja, this message translates to:
  /// **'音量'**
  String get criticalAlertVolume;

  /// アプリのユーザーアカウントからログアウトする機能のボタンやメニュー項目です。設定画面等で使用されます。
  ///
  /// In ja, this message translates to:
  /// **'ログアウト'**
  String get logout;

  /// 何らかのエラーやリセット操作によってアプリが初期設定画面に戻る時に表示される案内メッセージです。ユーザーに対して再度ログインが必要な場合があることと、その方法を説明しています。
  ///
  /// In ja, this message translates to:
  /// **'初期設定に戻ります。ログインが必要な場合は初期設定下部からお願いします'**
  String get goToInitialSettingAndReloginIfNeededMessage;

  /// ユーザーアカウントとそれに紐づく服用履歴や個人データをすべて削除する機能のラベルです。設定画面などで表示される重要な操作項目として使用されます。
  ///
  /// In ja, this message translates to:
  /// **'アカウント削除'**
  String get deleteAccount;

  /// ユーザーがログアウト操作を完了した後に表示される確認メッセージです。アプリからサインアウトされ、認証状態が解除されたことをユーザーに伝えるために使用されます。
  ///
  /// In ja, this message translates to:
  /// **'ログアウトしました'**
  String get logoutCompleted;

  /// プレミアムプラン（有料機能）の特別割引キャンペーン時に表示される宣伝メッセージです。通常価格よりも安い価格でプレミアムプランを購入できることをユーザーに伝えるために使用されます。
  ///
  /// In ja, this message translates to:
  /// **'特別価格でプレミアムプランをゲット！'**
  String get specialDiscountPriceNow;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'af',
        'am',
        'ar',
        'as',
        'az',
        'be',
        'bg',
        'bn',
        'bs',
        'ca',
        'cs',
        'cy',
        'da',
        'de',
        'el',
        'en',
        'es',
        'et',
        'eu',
        'fa',
        'fi',
        'fil',
        'gl',
        'gsw',
        'gu',
        'he',
        'hi',
        'hr',
        'hu',
        'hy',
        'id',
        'is',
        'it',
        'ja',
        'ka',
        'kk',
        'km',
        'kn',
        'ko',
        'ky',
        'lo',
        'lt',
        'lv',
        'mk',
        'ml',
        'mn',
        'mr',
        'ms',
        'my',
        'nb',
        'ne',
        'nl',
        'no',
        'or',
        'pa',
        'pl',
        'ps',
        'pt',
        'ro',
        'ru',
        'si',
        'sk',
        'sl',
        'sq',
        'sr',
        'sv',
        'sw',
        'ta',
        'te',
        'th',
        'tl',
        'tr',
        'uk',
        'ur',
        'uz',
        'vi',
        'zh',
        'zu'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'af':
      return AppLocalizationsAf();
    case 'am':
      return AppLocalizationsAm();
    case 'ar':
      return AppLocalizationsAr();
    case 'as':
      return AppLocalizationsAs();
    case 'az':
      return AppLocalizationsAz();
    case 'be':
      return AppLocalizationsBe();
    case 'bg':
      return AppLocalizationsBg();
    case 'bn':
      return AppLocalizationsBn();
    case 'bs':
      return AppLocalizationsBs();
    case 'ca':
      return AppLocalizationsCa();
    case 'cs':
      return AppLocalizationsCs();
    case 'cy':
      return AppLocalizationsCy();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'et':
      return AppLocalizationsEt();
    case 'eu':
      return AppLocalizationsEu();
    case 'fa':
      return AppLocalizationsFa();
    case 'fi':
      return AppLocalizationsFi();
    case 'fil':
      return AppLocalizationsFil();
    case 'gl':
      return AppLocalizationsGl();
    case 'gsw':
      return AppLocalizationsGsw();
    case 'gu':
      return AppLocalizationsGu();
    case 'he':
      return AppLocalizationsHe();
    case 'hi':
      return AppLocalizationsHi();
    case 'hr':
      return AppLocalizationsHr();
    case 'hu':
      return AppLocalizationsHu();
    case 'hy':
      return AppLocalizationsHy();
    case 'id':
      return AppLocalizationsId();
    case 'is':
      return AppLocalizationsIs();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ka':
      return AppLocalizationsKa();
    case 'kk':
      return AppLocalizationsKk();
    case 'km':
      return AppLocalizationsKm();
    case 'kn':
      return AppLocalizationsKn();
    case 'ko':
      return AppLocalizationsKo();
    case 'ky':
      return AppLocalizationsKy();
    case 'lo':
      return AppLocalizationsLo();
    case 'lt':
      return AppLocalizationsLt();
    case 'lv':
      return AppLocalizationsLv();
    case 'mk':
      return AppLocalizationsMk();
    case 'ml':
      return AppLocalizationsMl();
    case 'mn':
      return AppLocalizationsMn();
    case 'mr':
      return AppLocalizationsMr();
    case 'ms':
      return AppLocalizationsMs();
    case 'my':
      return AppLocalizationsMy();
    case 'nb':
      return AppLocalizationsNb();
    case 'ne':
      return AppLocalizationsNe();
    case 'nl':
      return AppLocalizationsNl();
    case 'no':
      return AppLocalizationsNo();
    case 'or':
      return AppLocalizationsOr();
    case 'pa':
      return AppLocalizationsPa();
    case 'pl':
      return AppLocalizationsPl();
    case 'ps':
      return AppLocalizationsPs();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'si':
      return AppLocalizationsSi();
    case 'sk':
      return AppLocalizationsSk();
    case 'sl':
      return AppLocalizationsSl();
    case 'sq':
      return AppLocalizationsSq();
    case 'sr':
      return AppLocalizationsSr();
    case 'sv':
      return AppLocalizationsSv();
    case 'sw':
      return AppLocalizationsSw();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
    case 'th':
      return AppLocalizationsTh();
    case 'tl':
      return AppLocalizationsTl();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'ur':
      return AppLocalizationsUr();
    case 'uz':
      return AppLocalizationsUz();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
    case 'zu':
      return AppLocalizationsZu();
  }

  throw FlutterError('AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
