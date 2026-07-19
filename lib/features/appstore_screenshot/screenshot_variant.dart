/// スクリーンショットのバリアント（Custom Product Page 別の構成）定義。
///
/// バリアント名 → そのバリアントで生成するページ番号の並び順。
/// CPP ごとに主役ページを先頭へ並べ替える（v1 はコピー差し替えなし・順序のみ）。
/// 設計は cpp/plan.md、ページ内容は screenshot_page.dart の 5-A 構成に対応する。
///
/// この対応表が「どのバリアントがどの順でページを並べるか」の SSOT。
/// 撮影ハーネス（test/appstore_screenshot）と generate スクリプトが参照する。
/// 出力ファイル名の index は「このリストの位置」（0 始まり）にする。
const Map<String, List<int>> screenshotVariants = {
  // 通常配信。5-A のページ順 + 機能訴求（6 カレンダー / 7 服用履歴）。
  'main': [1, 2, 3, 4, 5, 6, 7],
  // 飲み忘れ防止・王道: 複数回リマインド（p4）を主役に。服用漏れチェックの履歴（p7）を続ける。
  'cpp-reminder': [4, 7, 2, 1, 3, 5, 6],
  // 伏せた通知・独自性: 伏せた通知（p3）を主役に。
  'cpp-privacy': [3, 1, 2, 4, 5, 6, 7],
  // 生理管理・クロスセル: 生理管理（p5）を主役に。生理予定日が見えるカレンダー（p6）を続ける。
  'cpp-menstruation': [5, 6, 2, 1, 4, 3, 7],
  // ピル服用スタート・初心者: ピルシート（p2）を主役に。
  'cpp-beginner': [2, 4, 1, 3, 5, 6, 7],
  // 英語圏 Birth Control（en 専用）: 社会的証明（p1）→伏せた通知（p3）。
  'cpp-birthcontrol': [1, 3, 2, 4, 5, 6, 7],
};

/// バリアントの表示順（ページ番号リスト）を返す。未知のバリアントは null。
List<int>? screenshotVariantOrder({required String variant}) => screenshotVariants[variant];
