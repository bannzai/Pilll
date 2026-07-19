import 'package:flutter/material.dart';
import 'package:pilll/features/appstore_screenshot/frame_layout.dart';
import 'package:pilll/features/appstore_screenshot/mock_screens/mock_calendar_screen.dart';
import 'package:pilll/features/appstore_screenshot/mock_screens/mock_lock_screen.dart';
import 'package:pilll/features/appstore_screenshot/mock_screens/mock_medication_history_screen.dart';
import 'package:pilll/features/appstore_screenshot/mock_screens/mock_menstruation_screen.dart';
import 'package:pilll/features/appstore_screenshot/mock_screens/mock_multiple_reminder_screen.dart';
import 'package:pilll/features/appstore_screenshot/mock_screens/mock_record_screen.dart';
import 'package:pilll/features/appstore_screenshot/mock_screens/mock_social_proof_screen.dart';
import 'package:pilll/features/appstore_screenshot/screenshot_background.dart';
import 'package:pilll/features/appstore_screenshot/screenshot_device.dart';
import 'package:pilll/features/appstore_screenshot/screenshot_text.dart';

/// スクリーンショットのページ数。カタログアプリ・撮影フロー・変換スクリプトが参照する SSOT。
const int allScreenshotPageCount = 7;

/// スクリーンショット 1 ページ分（背景・コピー・Mock 画面）を合成した Widget を返す。
///
/// 言語コード（arb）とページ番号から、そのページの背景・キャッチコピー・
/// Mock 画面を組み合わせて [AppStoreScreenshotFrameLayout] を構築する。
///
/// ページ構成は競合調査（tmp/research/report.md 5-A）の 5 枚 + 機能訴求 2 枚:
/// 1 社会的証明 / 2 ピルシート UI / 3 伏せた通知 / 4 複数回リマインド / 5 生理管理 /
/// 6 カレンダー（生理予定日・次シート開始）/ 7 服用履歴。
Widget screenshotPage({
  required String lang,
  required int page,
  required ScreenshotDevice device,
}) {
  final copy = ScreenshotCopy.of(lang: lang, page: page);
  return AppStoreScreenshotFrameLayout(
    device: device,
    background: ScreenshotBackground.of(page: page),
    title: copy.title,
    subtitle: copy.subtitle,
    titleAccentWord: copy.titleAccentWord,
    child: _mockScreen(lang: lang, page: page),
  );
}

/// ページ番号に対応する Mock 画面を返す。
Widget _mockScreen({required String lang, required int page}) {
  switch (page) {
    case 1:
      return MockSocialProofScreen(lang: lang);
    case 2:
      return MockRecordScreen(lang: lang);
    case 3:
      return MockLockScreen(lang: lang);
    case 4:
      return MockMultipleReminderScreen(lang: lang);
    case 5:
      return MockMenstruationScreen(lang: lang);
    case 6:
      return MockCalendarScreen(lang: lang);
    case 7:
      return MockMedicationHistoryScreen(lang: lang);
    default:
      return MockRecordScreen(lang: lang);
  }
}
