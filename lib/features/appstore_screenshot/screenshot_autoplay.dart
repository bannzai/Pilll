import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// カタログアプリをホスト側のスクリプトから無人操作するための、ファイル経由の同期手順。
///
/// iPhone Duo の内側ディスプレイは Maestro の takeScreenshot では撮れず（XCTest が返す画面は
/// 外側のまま）、ホスト側の `xcrun simctl io <UDID> screenshot --display=primary-1` で撮る必要が
/// ある。そのためアプリ側がページを表示したことをホストへ知らせ、ホストが撮り終えたことを
/// アプリへ返す経路として、アプリの Documents ディレクトリ（ホストからは
/// `xcrun simctl get_app_container <UDID> <bundle id> data` + `/Documents` で辿れる）に
/// 次のファイルを置く。
///
/// - [autoplayRequestFileName]: ホストが起動前に書く。1 行目が arb 言語コード、2 行目が
///   カンマ区切りのページ番号。存在すればアプリは起動直後にその言語の各ページを順に全画面表示する
/// - [readyFileName]: アプリがページを描画し終えた後に書く。内容は `<lang> p<page>`
/// - [ackFileName]: ホストが撮影を終えた後に書く。アプリはこれを見つけるとページを閉じて次へ進む
/// - [doneFileName]: 全ページを終えた後にアプリが書く
///
/// 用途は scripts/generate_screenshots/capture_duo_screenshots.sh を参照。
/// Maestro の既存フロー（capture.yaml）はこの手順を使わず、依頼ファイルが無ければ何もしない。
const String autoplayRequestFileName = 'screenshot_autoplay.txt';

/// ページを描画し終えたことをホストへ知らせるファイル名。
const String readyFileName = 'screenshot_ready.txt';

/// ホストが撮影を終えたことをアプリへ返すファイル名。
const String ackFileName = 'screenshot_ack.txt';

/// 全ページの表示を終えたことをホストへ知らせるファイル名。
const String doneFileName = 'screenshot_done.txt';

/// [ackFileName] を探す間隔。撮影 1 枚あたりの待ちをこの粒度で抑えつつ、
/// ファイル監視を使わず Simulator の負荷を増やさない値として 100 ミリ秒にする。
const Duration ackPollInterval = Duration(milliseconds: 100);

/// Documents ディレクトリに依頼ファイルがあれば、その言語の各ページを順に全画面表示する。
///
/// 依頼ファイルが無ければ何もしない（Maestro で操作する従来の起動と同じ）。
/// [pushPage] は 1 ページを全画面で push し、閉じられるまで待つ Future を返す。
/// [applyLanguage] は L とカタログのロケールを切り替える。
/// 終了時に [doneFileName] を書く。依頼ファイルは消さない（ホストが次の言語で上書きする）。
Future<void> runScreenshotAutoplayIfRequested({
  required void Function(String lang) applyLanguage,
  required Future<void> Function({required String lang, required int page, required Directory documents}) pushPage,
}) async {
  final documents = await getApplicationDocumentsDirectory();
  final request = File('${documents.path}/$autoplayRequestFileName');
  if (!request.existsSync()) {
    return;
  }
  final lines = request.readAsLinesSync();
  final lang = lines[0].trim();
  applyLanguage(lang);
  for (final page in lines[1].split(',').map((value) => int.parse(value.trim()))) {
    await pushPage(lang: lang, page: page, documents: documents);
  }
  File('${documents.path}/$doneFileName').writeAsStringSync(lang);
}

/// ページを描画し終えた後にホストへ知らせ、ホストの撮影完了を待ってから true を返す。
///
/// [documents] に [readyFileName] を書き、[ackFileName] が現れるまで [ackPollInterval] で待つ。
/// 見つけたら両方を消してから返す（次のページが同じ名前で書き直せるようにする）。
Future<void> notifyReadyAndWaitForAck({required Directory documents, required String lang, required int page}) async {
  final ready = File('${documents.path}/$readyFileName');
  final ack = File('${documents.path}/$ackFileName');
  ready.writeAsStringSync('$lang p$page');
  while (!ack.existsSync()) {
    await Future<void>.delayed(ackPollInterval);
  }
  ack.deleteSync();
  ready.deleteSync();
}
